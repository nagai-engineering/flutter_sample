import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../widgets/tip_bubble.dart';
import '../widgets/task_card.dart';

class TomorrowView extends StatefulWidget {
  const TomorrowView({super.key});

  @override
  State<TomorrowView> createState() => _TomorrowViewState();
}

class _TomorrowViewState extends State<TomorrowView> {
  final TextEditingController _textController = TextEditingController();
  int? _editingTaskId;
  final TextEditingController _editController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _editController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_textController.text.trim().isNotEmpty) {
      context.read<TaskProvider>().addTomorrowTask(_textController.text);
      _textController.clear();
    }
  }

  void _startEdit(int id, String currentText) {
    setState(() {
      _editingTaskId = id;
      _editController.text = currentText;
    });
  }

  void _saveEdit() {
    if (_editingTaskId != null && _editController.text.trim().isNotEmpty) {
      context
          .read<TaskProvider>()
          .updateTomorrowTask(_editingTaskId!, _editController.text);
      setState(() {
        _editingTaskId = null;
        _editController.clear();
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _editingTaskId = null;
      _editController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tomorrowTasks;
        final tomorrow = DateTime.now().add(const Duration(days: 1));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tip Bubble
              TipBubble(
                emoji: '😊',
                text: '無責任にいろいろ明日のジブンに任せちゃおう!',
                icon: Icons.lightbulb_outline,
                backgroundColor: Colors.yellow.shade50,
                borderColor: Colors.yellow.shade300,
                textColor: Colors.amber.shade900,
                iconColor: Colors.amber.shade600,
              ),
              const SizedBox(height: 24),

              // Date
              Row(
                children: [
                  Icon(Icons.mail_outline, size: 20, color: Colors.orange.shade500),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('M月d日(E)', 'ja_JP').format(tomorrow)}のジブンへ',
                    style: TextStyle(
                      color: Colors.orange.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Add task input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: '頼んだ!明日のジブン!',
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.orange.shade300,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.orange.shade300,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.orange.shade500,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _addTask(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '🙏 頼む',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tasks grid
              if (tasks.isEmpty)
                _buildEmptyState()
              else
                _buildTasksGrid(context, tasks, taskProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mail_outline,
              size: 32,
              color: Colors.orange.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '明日のジブンにお願いしてみよう',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'わくわくすることを自由に書いてね',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksGrid(
    BuildContext context,
    List tasks,
    TaskProvider taskProvider,
  ) {
    final colors = [
      {
        'bg': Colors.yellow.shade100,
        'border': Colors.yellow.shade300,
        'text': Colors.yellow.shade900,
      },
      {
        'bg': Colors.orange.shade100,
        'border': Colors.orange.shade300,
        'text': Colors.orange.shade900,
      },
      {
        'bg': Colors.pink.shade100,
        'border': Colors.pink.shade300,
        'text': Colors.pink.shade900,
      },
      {
        'bg': Colors.amber.shade100,
        'border': Colors.amber.shade300,
        'text': Colors.amber.shade900,
      },
    ];

    final rotations = [1.0, -1.0, 2.0, -2.0];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final color = colors[index % colors.length];
        final rotation = rotations[index % rotations.length];
        final isEditing = _editingTaskId == task.id;

        if (isEditing) {
          return _buildEditingCard(color);
        }

        return TaskCard(
          text: task.text,
          backgroundColor: color['bg'] as Color,
          borderColor: color['border'] as Color,
          textColor: color['text'] as Color,
          rotation: rotation,
          onEdit: () => _startEdit(task.id!, task.text),
          onDelete: () => taskProvider.deleteTomorrowTask(task.id!),
        );
      },
    );
  }

  Widget _buildEditingCard(Map<String, Color> color) {
    return Transform.rotate(
      angle: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color['bg']!,
              color['bg']!.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color['border']!, width: 2),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _editController,
              autofocus: true,
              maxLines: 2,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: color['border']!, width: 2),
                ),
                contentPadding: const EdgeInsets.all(8),
              ),
              style: TextStyle(
                color: color['text']!,
                fontSize: 14,
              ),
              onSubmitted: (_) => _saveEdit(),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _saveEdit,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('保存'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                TextButton.icon(
                  onPressed: _cancelEdit,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('キャンセル'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
