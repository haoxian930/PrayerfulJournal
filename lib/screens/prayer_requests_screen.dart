import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_request_provider.dart';
import '../models/prayer_request.dart';
import '../widgets/prayer_request_card.dart';
import 'add_prayer_request_screen.dart';

class PrayerRequestsScreen extends StatefulWidget {
  const PrayerRequestsScreen({super.key});

  @override
  State<PrayerRequestsScreen> createState() => _PrayerRequestsScreenState();
}

class _PrayerRequestsScreenState extends State<PrayerRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PrayerCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active', icon: Icon(Icons.favorite_rounded)),
            Tab(text: 'Answered', icon: Icon(Icons.check_circle_rounded)),
            Tab(text: 'All', icon: Icon(Icons.list_rounded)),
          ],
        ),
        actions: [
          PopupMenuButton<PrayerCategory?>(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: 'Filter by category',
            onSelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('All Categories'),
              ),
              ...PrayerCategory.values.map(
                (category) => PopupMenuItem(
                  value: category,
                  child: Text(category.name.toUpperCase()[0] + 
                            category.name.substring(1)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<PrayerRequestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading prayers',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadPrayerRequests();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildPrayerList(provider.activePrayerRequests),
              _buildPrayerList(provider.answeredPrayerRequests),
              _buildPrayerList(provider.prayerRequests),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPrayerRequestScreen(),
            ),
          );
        },
        tooltip: 'Add Prayer Request',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildPrayerList(List<PrayerRequest> prayers) {
    // Filter by category if selected
    var filteredPrayers = prayers;
    if (_selectedCategory != null) {
      filteredPrayers = prayers
          .where((prayer) => prayer.category == _selectedCategory)
          .toList();
    }

    if (filteredPrayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedCategory != null
                  ? 'No prayers in ${_selectedCategory!.name} category'
                  : 'No prayer requests yet',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first prayer request to start tracking God\'s faithfulness.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddPrayerRequestScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Prayer Request'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PrayerRequestProvider>().loadPrayerRequests();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive padding based on screen width
          final isWideScreen = constraints.maxWidth > 600;
          final horizontalPadding = isWideScreen ? 
              (constraints.maxWidth * 0.1).clamp(16.0, 80.0) : 16.0;
          
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            itemCount: filteredPrayers.length,
            itemBuilder: (context, index) {
              final prayer = filteredPrayers[index];
              return PrayerRequestCard(
                prayer: prayer,
                onTap: () {
                  // Navigate to prayer detail screen
                  _showPrayerDetails(context, prayer);
                },
                onStatusUpdate: () {
                  // Handle marking prayer as answered from popup menu
                  _showMarkAsAnsweredDialog(context, prayer);
                },
                onDelete: () async {
                  try {
                    await context.read<PrayerRequestProvider>().deletePrayerRequest(prayer.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Prayer request deleted successfully'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to delete prayer request: $e'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showPrayerDetails(BuildContext context, PrayerRequest prayer) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(prayer.categoryDisplayName),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                            ),
                            const Spacer(),
                            Chip(
                              label: Text(prayer.statusDisplayName),
                              backgroundColor: _getStatusColor(prayer.status)
                                  .withOpacity(0.1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          prayer.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          prayer.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Created: ${_formatDate(prayer.createdAt)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (prayer.updatedAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Updated: ${_formatDate(prayer.updatedAt!)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        if (prayer.answeredAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Answered: ${_formatDate(prayer.answeredAt!)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        if (prayer.status != PrayerRequestStatus.answered)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showMarkAsAnsweredDialog(context, prayer);
                              },
                              child: const Text('Mark as Answered'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMarkAsAnsweredDialog(BuildContext context, PrayerRequest prayer) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Answered'),
        content: const Text(
          'Would you like to mark this prayer as answered and create an answered prayer story?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PrayerRequestProvider>().updatePrayerRequestStatus(
                    prayer.id,
                    PrayerRequestStatus.answered,
                  );
              // Navigate to create answered story
              // Navigator.push to AnsweredStoryScreen
            },
            child: const Text('Mark Answered'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PrayerRequestStatus status) {
    switch (status) {
      case PrayerRequestStatus.pending:
        return Colors.orange;
      case PrayerRequestStatus.inProgress:
        return Colors.blue;
      case PrayerRequestStatus.answered:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
