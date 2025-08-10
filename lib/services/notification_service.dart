import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  factory NotificationService() => _instance;
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Request permissions for iOS
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  // Add method to check if we can schedule exact alarms
  Future<bool> canScheduleExactAlarms() async {
    final androidImplementation = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      final canSchedule = await androidImplementation.canScheduleExactNotifications();
      return canSchedule ?? false;
    }
    return true; // iOS or other platforms
  }

  void _onNotificationResponse(NotificationResponse response) {
    // Handle notification tap
    if (response.payload != null) {
      // Navigate to specific screen based on payload
      // Payload handled by main app navigation
    }
  }

  Future<void> scheduleDailyPrayerReminder({
    required int hour,
    required int minute,
    String? customMessage,
  }) async {
    try {
      // Check if exact alarms are allowed first
      final canScheduleExact = await canScheduleExactAlarms();
      
      // Cancel any existing prayer reminders first
      await cancelDailyPrayerReminder();
      
      final scheduledTime = _nextInstanceOfTime(hour, minute);
      
      // Try scheduling with daily repetition
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0, // notification id
        'Time for Prayer 🙏',
        customMessage ?? 'Take a moment to connect with God and reflect on His goodness.',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_reminder',
            'Prayer Reminders',
            channelDescription: 'Daily reminders for prayer time',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: canScheduleExact 
          ? AndroidScheduleMode.exactAllowWhileIdle 
          : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // Remove matchDateTimeComponents for now - it's causing issues
        payload: 'daily_prayer_reminder',
      );

      // Save reminder settings
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('prayer_reminder_hour', hour);
      await prefs.setInt('prayer_reminder_minute', minute);
      await prefs.setBool('prayer_reminder_enabled', true);
      if (customMessage != null) {
        await prefs.setString('prayer_reminder_message', customMessage);
      }
      
      // Schedule fallback notifications for the next 7 days to ensure continuity
      await _scheduleMultipleDays(hour, minute, customMessage);
      
    } catch (e) {
      // Fallback: Schedule next 7 individual notifications
      await _scheduleMultipleDays(hour, minute, customMessage);
      
      // Still save settings even if we had to use fallback
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('prayer_reminder_hour', hour);
      await prefs.setInt('prayer_reminder_minute', minute);
      await prefs.setBool('prayer_reminder_enabled', true);
      if (customMessage != null) {
        await prefs.setString('prayer_reminder_message', customMessage);
      }
    }
  }

  // Fallback method for problematic devices
  Future<void> _scheduleMultipleDays(int hour, int minute, String? customMessage) async {
    for (int i = 1; i <= 7; i++) { // Start from 1 since ID 0 is already scheduled
      try {
        final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
        tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
        
        // Add days for future notifications
        scheduledDate = scheduledDate.add(Duration(days: i));
        
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          1000 + i, // Use IDs 1000+ for fallback notifications
          'Time for Prayer 🙏',
          customMessage ?? 'Take a moment to connect with God and reflect on His goodness.',
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_reminder',
              'Prayer Reminders',
              channelDescription: 'Daily reminders for prayer time',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
              enableVibration: true,
              playSound: true,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, // Use inexact for fallback
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'daily_prayer_reminder',
        );
      } catch (e) {
        // Silently continue if individual notification fails
        continue;
      }
    }
  }

  Future<void> scheduleAnsweredPrayerReminder() async {
    try {
      // Cancel any existing weekly reminders first
      await cancelAnsweredPrayerReminder();
      
      // Schedule for Sunday at 6 PM (good time for reflection)
      final scheduledTime = _nextInstanceOfWeekday(DateTime.sunday, 18, 0);
      
      // Try scheduling with weekly repetition
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        1, // notification id
        'Remember When... 💫',
        'God answered your prayers! Tap to revisit your answered prayer stories.',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'answered_prayer_reminder',
            'Answered Prayer Reminders',
            channelDescription: 'Weekly reminders of answered prayers',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // Weekly repetition
        payload: 'answered_prayer_reminder',
      );

      // Save reminder settings
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('answered_prayer_reminder_enabled', true);
      
    } catch (e) {
      // Fallback: Schedule next 12 weeks individually
      await _scheduleMultipleWeeks();
      
      // Still save settings even if we had to use fallback
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('answered_prayer_reminder_enabled', true);
    }
  }

  // Helper method to get next instance of a specific weekday and time
  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    // Calculate days until target weekday
    int daysUntilTarget = (weekday - now.weekday) % 7;
    
    // If it's today but time has passed, schedule for next week
    if (daysUntilTarget == 0 && scheduledDate.isBefore(now)) {
      daysUntilTarget = 7;
    }
    
    if (daysUntilTarget > 0) {
      scheduledDate = scheduledDate.add(Duration(days: daysUntilTarget));
    }
    
    return scheduledDate;
  }

  // Fallback method for weekly notifications
  Future<void> _scheduleMultipleWeeks() async {
    for (int i = 0; i < 12; i++) {
      try {
        tz.TZDateTime scheduledDate = _nextInstanceOfWeekday(DateTime.sunday, 18, 0);
        
        // Add weeks for future notifications
        if (i > 0) {
          scheduledDate = scheduledDate.add(Duration(days: i * 7));
        }
        
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          2000 + i, // Use IDs 2000+ for weekly fallback notifications
          'Remember When... 💫',
          'God answered your prayers! Tap to revisit your answered prayer stories.',
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'answered_prayer_reminder',
              'Answered Prayer Reminders',
              channelDescription: 'Weekly reminders of answered prayers',
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
              icon: '@mipmap/ic_launcher',
              enableVibration: true,
              playSound: true,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'answered_prayer_reminder',
        );
      } catch (e) {
        // Silently continue if individual notification fails
        continue;
      }
    }
  }

  Future<void> showInstantGratitudeReminder() async {
    await _flutterLocalNotificationsPlugin.show(
      2, // notification id
      'Gratitude Moment 💝',
      'What is one thing you\'re grateful for right now?',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'gratitude_reminder',
          'Gratitude Reminders',
          channelDescription: 'Spontaneous gratitude reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      payload: 'gratitude_reminder',
    );
  }

  // Test method to verify notifications are working
  Future<void> showTestNotification() async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        999, // notification id
        'Test Notification 🔔',
        'Notifications are working! Your prayer reminders should work too.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_notifications',
            'Test Notifications',
            channelDescription: 'Test notifications to verify functionality',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: 'test_notification',
      );
    } catch (e) {
      // Silently fail for test notifications
    }
  }

  Future<void> cancelDailyPrayerReminder() async {
    // Cancel main daily reminder
    await _flutterLocalNotificationsPlugin.cancel(0);
    
    // Cancel fallback daily reminders (IDs 1001-1007)
    for (int i = 1; i <= 7; i++) {
      await _flutterLocalNotificationsPlugin.cancel(1000 + i);
    }
    
    // Update settings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('prayer_reminder_enabled', false);
    await prefs.remove('prayer_reminder_hour');
    await prefs.remove('prayer_reminder_minute');
    await prefs.remove('prayer_reminder_message');
  }

  Future<void> cancelAnsweredPrayerReminder() async {
    // Cancel main weekly reminder
    await _flutterLocalNotificationsPlugin.cancel(1);
    
    // Cancel fallback weekly reminders (IDs 2000-2011)
    for (int i = 0; i < 12; i++) {
      await _flutterLocalNotificationsPlugin.cancel(2000 + i);
    }
    
    // Update settings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('answered_prayer_reminder_enabled', false);
  }

  // Method to cancel all reminders
  Future<void> cancelAllReminders() async {
    await cancelDailyPrayerReminder();
    await cancelAnsweredPrayerReminder();
    
    // Cancel gratitude reminder as well
    await _flutterLocalNotificationsPlugin.cancel(2);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    
    // Update settings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('prayer_reminder_enabled', false);
    await prefs.setBool('answered_prayer_reminder_enabled', false);
  }

  Future<Map<String, dynamic>?> getPrayerReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('prayer_reminder_enabled') ?? false;
    
    if (!isEnabled) return null;
    
    return {
      'hour': prefs.getInt('prayer_reminder_hour') ?? 9,
      'minute': prefs.getInt('prayer_reminder_minute') ?? 0,
      'message': prefs.getString('prayer_reminder_message'),
      'enabled': isEnabled,
    };
  }

  Future<bool> getAnsweredPrayerReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('answered_prayer_reminder_enabled') ?? false;
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  // Custom notification for prayer request updates
  Future<void> showPrayerRequestUpdateNotification(String title, String message) async {
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000), // unique id
      title,
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_updates',
          'Prayer Updates',
          channelDescription: 'Notifications for prayer request updates',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
