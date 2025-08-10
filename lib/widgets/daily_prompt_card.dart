import 'package:flutter/material.dart';
import '../models/prayer_prompt.dart';
import '../services/database_service.dart';

class DailyPromptCard extends StatefulWidget {
  const DailyPromptCard({super.key});

  @override
  State<DailyPromptCard> createState() => _DailyPromptCardState();
}

class _DailyPromptCardState extends State<DailyPromptCard> {
  PrayerPrompt? _todaysPrompt;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodaysPrompt();
  }

  Future<void> _loadTodaysPrompt() async {
    try {
      final prompt = await DatabaseService().getRandomPrayerPrompt();
      if (mounted) {
        setState(() {
          _todaysPrompt = prompt;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_todaysPrompt == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: MediaQuery.of(context).size.width < 400 ? 20 : 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Today\'s Prayer Prompt',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.width < 400 ? 8 : 12),
              Text(
                _todaysPrompt!.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                _todaysPrompt!.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: MediaQuery.of(context).size.width < 400 ? 12 : 16),
              Row(
                children: [
                  Chip(
                    label: Text(_todaysPrompt!.category),
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Use available width to determine layout
                      final availableWidth = constraints.maxWidth;
                      final isVerySmallScreen = availableWidth < 200;
                      
                      if (isVerySmallScreen) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: availableWidth.clamp(100.0, 120.0),
                              child: TextButton.icon(
                                onPressed: _loadTodaysPrompt,
                                icon: const Icon(Icons.refresh_rounded, size: 16),
                                label: const Text('New', style: TextStyle(fontSize: 12)),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  minimumSize: const Size(0, 28),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: availableWidth.clamp(100.0, 120.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _showPrayerDialog(context);
                                },
                                icon: const Icon(Icons.favorite_rounded, size: 16),
                                label: const Text('Pray', style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  minimumSize: const Size(0, 28),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      
                      return Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: (availableWidth * 0.45).clamp(80.0, 120.0),
                            ),
                            child: TextButton.icon(
                              onPressed: _loadTodaysPrompt,
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text('New', style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                minimumSize: const Size(0, 30),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: (availableWidth * 0.45).clamp(80.0, 120.0),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showPrayerDialog(context);
                              },
                              icon: const Icon(Icons.favorite_rounded, size: 16),
                              label: const Text('Pray', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                minimumSize: const Size(0, 30),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrayerDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.favorite_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('Prayer Time'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Take a moment to pray about:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _todaysPrompt!.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '🙏 Find a quiet place, close your eyes, and open your heart to God.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('May God bless your prayer time! 🙏'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('I\'m Ready'),
          ),
        ],
      ),
    );
  }
}
