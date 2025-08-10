import 'package:flutter/material.dart';
import '../models/prayer_request.dart';
import '../utils/app_theme.dart';
import '../screens/add_prayer_request_screen.dart';

class PrayerRequestCard extends StatelessWidget {
  const PrayerRequestCard({
    super.key,
    required this.prayer,
    this.onTap,
    this.onStatusUpdate,
    this.onEdit,
    this.onDelete,
  });

  final PrayerRequest prayer;
  final VoidCallback? onTap;
  final VoidCallback? onStatusUpdate;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      prayer.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusIndicator(status: prayer.status),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      if (prayer.status != PrayerRequestStatus.answered)
                        const PopupMenuItem(
                          value: 'mark_answered',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 18),
                              SizedBox(width: 8),
                              Text('Mark as Answered'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _handleEdit(context);
                          break;
                        case 'mark_answered':
                          onStatusUpdate?.call();
                          break;
                        case 'delete':
                          _handleDelete(context);
                          break;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                prayer.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Chip(
                    label: Text(prayer.categoryDisplayName),
                    backgroundColor: AppTheme.getCategoryColor(prayer.category.name)
                        .withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: AppTheme.getCategoryColor(prayer.category.name),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(prayer.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (prayer.status == PrayerRequestStatus.answered && prayer.answeredAt != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AppTheme.successColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Answered on ${_formatDate(prayer.answeredAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => AddPrayerRequestScreen(prayerToEdit: prayer),
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Prayer Request'),
        content: const Text('Are you sure you want to delete this prayer request? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _StatusIndicator extends StatelessWidget {

  const _StatusIndicator({required this.status});
  final PrayerRequestStatus status;

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (status) {
      case PrayerRequestStatus.pending:
        color = Colors.orange;
        icon = Icons.schedule_rounded;
        break;
      case PrayerRequestStatus.inProgress:
        color = Colors.blue;
        icon = Icons.timelapse_rounded;
        break;
      case PrayerRequestStatus.answered:
        color = AppTheme.successColor;
        icon = Icons.check_circle_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusText(status),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(PrayerRequestStatus status) {
    switch (status) {
      case PrayerRequestStatus.pending:
        return 'Pending';
      case PrayerRequestStatus.inProgress:
        return 'In Progress';
      case PrayerRequestStatus.answered:
        return 'Answered';
    }
  }
}
