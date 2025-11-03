import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../database/database_helper.dart';

class TaskProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Task> _todayTasks = [];
  List<Task> _tomorrowTasks = [];
  bool _isLoading = false;

  List<Task> get todayTasks => _todayTasks;
  List<Task> get tomorrowTasks => _tomorrowTasks;
  bool get isLoading => _isLoading;

  int get todayCompletedCount =>
      _todayTasks.where((task) => task.completed).length;
  int get todayTotalCount => _todayTasks.length;

  // Format date as YYYY-MM-DD
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String get todayDate => _formatDate(DateTime.now());
  String get tomorrowDate =>
      _formatDate(DateTime.now().add(const Duration(days: 1)));

  // Initialize and check for date changes
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _checkAndHandleDateChange();
    await loadTasks();

    _isLoading = false;
    notifyListeners();
  }

  // Check if date has changed since last app launch
  Future<void> _checkAndHandleDateChange() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLaunchDate = prefs.getString('last_launch_date');
    final currentDate = todayDate;

    if (lastLaunchDate != null && lastLaunchDate != currentDate) {
      // Date has changed - delete old today tasks
      await _dbHelper.deleteTasksByDate(lastLaunchDate);

      // Yesterday's tomorrow tasks already have today's date, so no need to update
    }

    // Save current date
    await prefs.setString('last_launch_date', currentDate);
  }

  // Load tasks from database
  Future<void> loadTasks() async {
    _todayTasks = await _dbHelper.getTasksByDate(todayDate);
    _tomorrowTasks = await _dbHelper.getTasksByDate(tomorrowDate);
    notifyListeners();
  }

  // Today's tasks operations (read-only except for completion)
  Future<void> toggleTodayTask(int id) async {
    final taskIndex = _todayTasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final task = _todayTasks[taskIndex];
      final updatedTask = task.copyWith(completed: !task.completed);

      await _dbHelper.updateTask(updatedTask);
      _todayTasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }

  // Tomorrow's tasks operations (full CRUD)
  Future<void> addTomorrowTask(String text) async {
    if (text.trim().isEmpty) return;

    final newTask = Task(
      text: text.trim(),
      completed: false,
      date: tomorrowDate,
    );

    final createdTask = await _dbHelper.createTask(newTask);
    _tomorrowTasks.add(createdTask);
    notifyListeners();
  }

  Future<void> updateTomorrowTask(int id, String text) async {
    if (text.trim().isEmpty) return;

    final taskIndex = _tomorrowTasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final task = _tomorrowTasks[taskIndex];
      final updatedTask = task.copyWith(text: text.trim());

      await _dbHelper.updateTask(updatedTask);
      _tomorrowTasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> deleteTomorrowTask(int id) async {
    await _dbHelper.deleteTask(id);
    _tomorrowTasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  // Refresh all tasks
  Future<void> refresh() async {
    await loadTasks();
  }
}
