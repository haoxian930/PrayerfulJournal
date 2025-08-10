import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'utils/app_theme.dart';
import 'providers/prayer_request_provider.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone database
  tz.initializeTimeZones();
  
  // Set local timezone - this is crucial for proper scheduling
  try {
    // Try to get system timezone offset and find matching timezone
    final now = DateTime.now();
    final utcOffset = now.timeZoneOffset;
    
    // For Windows, try common timezone names first
    final possibleTimezones = [
      'America/New_York',
      'America/Chicago', 
      'America/Denver',
      'America/Los_Angeles',
      'Europe/London',
      'Europe/Paris',
      'UTC'
    ];
    
    tz.Location? location;
    for (final tzName in possibleTimezones) {
      try {
        final testLocation = tz.getLocation(tzName);
        final testTime = tz.TZDateTime.now(testLocation);
        if (testTime.timeZoneOffset == utcOffset) {
          location = testLocation;
          print('Found matching timezone: $tzName');
          break;
        }
      } catch (e) {
        // Continue trying other timezones
      }
    }
    
    // Fallback to UTC if no match found
    location ??= tz.getLocation('UTC');
    tz.setLocalLocation(location);
    print('Timezone set to: ${location.name}');
    
  } catch (e) {
    print('Error setting timezone: $e');
    // Fallback to UTC
    tz.setLocalLocation(tz.getLocation('UTC'));
  }
  
  // Initialize notification service
  await NotificationService().initialize();
  
  runApp(const PrayerfulJourneyApp());
}

class PrayerfulJourneyApp extends StatelessWidget {
  const PrayerfulJourneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PrayerRequestProvider()),
      ],
      child: MaterialApp(
        title: 'Prayerful Journey',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
