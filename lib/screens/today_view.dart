import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../widgets/tip_bubble.dart';
import '../widgets/task_card.dart';

class TodayView extends StatelessWidget {
  const TodayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.todayTasks;
        final completedCount = taskProvider.todayCompletedCount;
        final totalCount = taskProvider.todayTotalCount;
        final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tip Bubble
              TipBubble(
                emoji: '😎',
                text: '昨日のジブンからのお願いです。かなえてあげましょう!',
                icon: Icons.auto_awesome,
                backgroundColor: Colors.blue.shade50,
                borderColor: Colors.blue.shade300,
                textColor: Colors.blue.shade900,
                iconColor: Colors.blue.shade600,
              ),
              const SizedBox(height: 24),

              // Date and Progress
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.blue.shade500),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('M月d日(E)', 'ja_JP').format(DateTime.now()),
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                '昨日のジブンからのお願い',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.blue.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$completedCount/$totalCount',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Achievement badge when all tasks completed
              if (totalCount > 0 && completedCount == totalCount)
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Transform.rotate(
                          angle: -0.2,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: const Text(
                              '💮',
                              style: TextStyle(fontSize: 80),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

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
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 32,
              color: Colors.blue.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '昨日のジブンからのお願いはありません',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ゆっくり休もう!',
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
        'bg': Colors.blue.shade100,
        'border': Colors.blue.shade300,
        'text': Colors.blue.shade900,
      },
      {
        'bg': Colors.cyan.shade100,
        'border': Colors.cyan.shade300,
        'text': Colors.cyan.shade900,
      },
      {
        'bg': Colors.lightBlue.shade100,
        'border': Colors.lightBlue.shade300,
        'text': Colors.lightBlue.shade900,
      },
      {
        'bg': Colors.indigo.shade100,
        'border': Colors.indigo.shade300,
        'text': Colors.indigo.shade900,
      },
    ];

    final rotations = [-1.0, 1.0, -2.0, 2.0];

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

        return TaskCard(
          text: task.text,
          completed: task.completed,
          onTap: () => taskProvider.toggleTodayTask(task.id!),
          backgroundColor: color['bg'] as Color,
          borderColor: color['border'] as Color,
          textColor: color['text'] as Color,
          rotation: rotation,
          showCheckbox: true,
        );
      },
    );
  }
}
