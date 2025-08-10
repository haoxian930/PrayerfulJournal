import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import 'support_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _prayerRemindersEnabled = false;
  bool _answeredPrayerRemindersEnabled = false;
  TimeOfDay _prayerReminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await NotificationService().getPrayerReminderSettings();
    final answeredPrayerEnabled = await NotificationService().getAnsweredPrayerReminderEnabled();
    
    if (settings != null) {
      setState(() {
        _prayerRemindersEnabled = (settings['enabled'] as bool?) ?? false;
        _prayerReminderTime = TimeOfDay(
          hour: (settings['hour'] as int?) ?? 9,
          minute: (settings['minute'] as int?) ?? 0,
        );
      });
    }
    
    setState(() {
      _answeredPrayerRemindersEnabled = answeredPrayerEnabled;
      _isLoading = false;
    });
  }

  Future<void> _togglePrayerReminders(bool enabled) async {
    setState(() {
      _prayerRemindersEnabled = enabled;
    });

    if (enabled) {
      await NotificationService().scheduleDailyPrayerReminder(
        hour: _prayerReminderTime.hour,
        minute: _prayerReminderTime.minute,
        customMessage: "Time for prayer 🙏 Take a moment to connect with God.",
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily prayer reminders enabled'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      await NotificationService().cancelDailyPrayerReminder();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily prayer reminders disabled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _toggleAnsweredPrayerReminders(bool enabled) async {
    setState(() {
      _answeredPrayerRemindersEnabled = enabled;
    });

    if (enabled) {
      await NotificationService().scheduleAnsweredPrayerReminder();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Weekly answered prayer reminders enabled'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      await NotificationService().cancelAnsweredPrayerReminder();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Weekly answered prayer reminders disabled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _prayerReminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dayPeriodTextColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _prayerReminderTime) {
      setState(() {
        _prayerReminderTime = picked;
      });

      // If reminders are enabled, reschedule with new time
      if (_prayerRemindersEnabled) {
        await NotificationService().scheduleDailyPrayerReminder(
          hour: _prayerReminderTime.hour,
          minute: _prayerReminderTime.minute,
          customMessage: "Time for prayer 🙏 Take a moment to connect with God.",
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Prayer reminder time updated to ${_prayerReminderTime.format(context)}'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Notification Settings Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notification Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Daily Prayer Reminders
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Daily Prayer Reminders'),
                  subtitle: Text(
                    _prayerRemindersEnabled 
                        ? 'Remind me to pray at ${_prayerReminderTime.format(context)}'
                        : 'Get daily reminders to spend time in prayer',
                  ),
                  value: _prayerRemindersEnabled,
                  onChanged: _togglePrayerReminders,
                  secondary: const Icon(Icons.schedule),
                ),
                if (_prayerRemindersEnabled) ...[
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Reminder Time'),
                    subtitle: Text(_prayerReminderTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: _selectTime,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Weekly Answered Prayer Reminders
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: SwitchListTile(
              title: const Text('Weekly Answered Prayer Reminders'),
              subtitle: const Text('Get reminded to reflect on answered prayers every Sunday at 6 PM'),
              value: _answeredPrayerRemindersEnabled,
              onChanged: _toggleAnsweredPrayerReminders,
              secondary: const Icon(Icons.celebration),
            ),
          ),

          const SizedBox(height: 24),

          // Support Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Support',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              title: const Text('Support PrayerfulJournal'),
              subtitle: const Text('Help keep this app free and ad-free'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const SupportScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // About Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'About Notifications',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'How Notifications Work',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Daily reminders help you maintain a consistent prayer routine\n'
                    '• Weekly reminders encourage you to reflect on how God has answered your prayers\n'
                    '• You can change these settings anytime\n'
                    '• Notifications require permission - you may be prompted to allow them',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
