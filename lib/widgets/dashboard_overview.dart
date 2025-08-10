import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_request_provider.dart';
import '../utils/app_theme.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Prayer Journey',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        const _StatisticsCards(),
        const SizedBox(height: 24),
        const _RecentActivity(),
      ],
    );
  }
}

class _StatisticsCards extends StatelessWidget {
  const _StatisticsCards();

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerRequestProvider>(
      builder: (context, prayerProvider, child) {
        final activePrayers = prayerProvider.activePrayerRequests.length;
        final answeredPrayers = prayerProvider.answeredPrayerRequests.length;

        return LayoutBuilder(
          builder: (context, constraints) {
            // Use responsive layout based on screen width
            final isWideScreen = constraints.maxWidth > 600;
            final isSmallScreen = constraints.maxWidth < 400;
            final crossAxisCount = isWideScreen ? 4 : 2;
            final childAspectRatio = isSmallScreen ? 1.8 : (isWideScreen ? 1.2 : 1.5);
            
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: isSmallScreen ? 8 : 12,
              mainAxisSpacing: isSmallScreen ? 8 : 12,
              children: [
                _StatCard(
                  title: 'Active Prayers',
                  value: activePrayers.toString(),
                  icon: Icons.favorite_rounded,
                  color: AppTheme.primaryColor,
                  subtitle: 'Ongoing requests',
                  isCompact: isSmallScreen,
                ),
                _StatCard(
                  title: 'Answered Prayers',
                  value: answeredPrayers.toString(),
                  icon: Icons.check_circle_rounded,
                  color: AppTheme.successColor,
                  subtitle: 'Blessed responses',
                  isCompact: isSmallScreen,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
    this.isCompact = false,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: isCompact 
                        ? Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
                        : Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  icon,
                  color: color,
                  size: isCompact ? 18 : 20,
                ),
              ],
            ),
            SizedBox(height: isCompact ? 4 : 8),
            Text(
              value,
              style: (isCompact 
                  ? Theme.of(context).textTheme.headlineMedium
                  : Theme.of(context).textTheme.displaySmall)?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: isCompact 
                  ? Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)
                  : Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Prayers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () {
                // Navigate to prayers screen
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Consumer<PrayerRequestProvider>(
          builder: (context, prayerProvider, child) {
            final recentPrayers = prayerProvider.prayerRequests.take(5).toList();

            if (recentPrayers.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Start Your Prayer Journey',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your first prayer request to begin tracking God\'s faithfulness in your life.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: recentPrayers.map((prayer) => _ActivityItem(
                title: prayer.title,
                subtitle: 'Prayer Request • ${prayer.categoryDisplayName}',
                icon: Icons.favorite_rounded,
                color: AppTheme.getCategoryColor(prayer.category.name),
                date: prayer.createdAt,
              )).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.date,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          _formatDate(date),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
