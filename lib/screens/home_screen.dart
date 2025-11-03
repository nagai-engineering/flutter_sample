import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'today_view.dart';
import 'tomorrow_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Initialize tasks when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _currentIndex == 0
                ? [
                    Colors.orange.shade100,
                    Colors.pink.shade50,
                    Colors.yellow.shade50,
                  ]
                : [
                    Colors.blue.shade100,
                    Colors.cyan.shade50,
                    Colors.lightBlue.shade50,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Tab buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabButton(
                      label: '明日',
                      index: 0,
                      backgroundColor: Colors.orange.shade500,
                      inactiveBackgroundColor: Colors.white.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 12),
                    _buildTabButton(
                      label: '今日',
                      index: 1,
                      backgroundColor: Colors.blue.shade500,
                      inactiveBackgroundColor: Colors.white.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ),

              // Page view with notebook effect
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(
                    children: [
                      // Shadow pages (notebook effect)
                      Positioned(
                        top: 8,
                        right: 8,
                        bottom: 8,
                        left: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _currentIndex == 0
                                ? Colors.orange.shade100.withValues(alpha: 0.5)
                                : Colors.blue.shade100.withValues(alpha: 0.5),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            border: Border(
                              left: BorderSide(
                                color: _currentIndex == 0
                                    ? Colors.orange.shade200
                                    : Colors.blue.shade200,
                                width: 4,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        bottom: 4,
                        left: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _currentIndex == 0
                                ? Colors.orange.shade100.withValues(alpha: 0.3)
                                : Colors.blue.shade100.withValues(alpha: 0.3),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            border: Border(
                              left: BorderSide(
                                color: _currentIndex == 0
                                    ? Colors.orange.shade100
                                    : Colors.blue.shade100,
                                width: 4,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Main page
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _currentIndex == 0
                                ? [
                                    Colors.amber.shade50,
                                    Colors.orange.shade50,
                                  ]
                                : [
                                    Colors.blue.shade50,
                                    Colors.cyan.shade50,
                                  ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border(
                            left: BorderSide(
                              color: _currentIndex == 0
                                  ? Colors.orange.shade300
                                  : Colors.blue.shade300,
                              width: 4,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: _onPageChanged,
                            children: const [
                              TomorrowView(),
                              TodayView(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required int index,
    required Color backgroundColor,
    required Color inactiveBackgroundColor,
  }) {
    final isActive = _currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: () => _onTabTapped(index),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? backgroundColor : inactiveBackgroundColor,
          foregroundColor: isActive ? Colors.white : Colors.grey.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: isActive ? 8 : 2,
          shadowColor: isActive
              ? backgroundColor.withValues(alpha: 0.5)
              : Colors.black.withValues(alpha: 0.1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
