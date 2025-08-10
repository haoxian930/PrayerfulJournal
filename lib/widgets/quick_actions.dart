import 'package:flutter/material.dart';
import '../screens/add_prayer_request_screen.dart';
import '../screens/prayer_requests_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Stack vertically on very small screens
            final isVerySmallScreen = constraints.maxWidth < 300;
            
            if (isVerySmallScreen) {
              return Column(
                children: [
                  _QuickActionCard(
                    title: 'Add Prayer',
                    subtitle: 'New request',
                    icon: Icons.add_circle_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const AddPrayerRequestScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _QuickActionCard(
                    title: 'View Prayers',
                    subtitle: 'All requests',
                    icon: Icons.list_rounded,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const PrayerRequestsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            
            return Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    title: 'Add Prayer',
                    subtitle: 'New request',
                    icon: Icons.add_circle_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const AddPrayerRequestScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    title: 'View Prayers',
                    subtitle: 'All requests',
                    icon: Icons.list_rounded,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const PrayerRequestsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: isSmallScreen ? 20 : 24,
                child: Icon(
                  icon,
                  color: color,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : 12),
              Text(
                title,
                style: isSmallScreen 
                    ? Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)
                    : Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: isSmallScreen 
                    ? Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)
                    : Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
