import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_request_provider.dart';
import 'prayer_requests_screen.dart';
import 'settings_screen.dart';
import '../widgets/dashboard_overview.dart';
import '../widgets/quick_actions.dart';
import '../widgets/daily_prompt_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const PrayerRequestsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      // Load prayer requests
      await context.read<PrayerRequestProvider>().loadPrayerRequests();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
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
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading your prayer journey...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Prayers',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Prayerful Journey',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive padding based on screen width
          final isWideScreen = constraints.maxWidth > 600;
          final horizontalPadding = isWideScreen ? 
              (constraints.maxWidth * 0.1).clamp(16.0, 80.0) : 16.0;
          
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DailyPromptCard(),
                SizedBox(height: MediaQuery.of(context).size.width < 400 ? 16 : 24),
                const QuickActions(),
                SizedBox(height: MediaQuery.of(context).size.width < 400 ? 16 : 24),
                const DashboardOverview(),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning! 🌅';
    } else if (hour < 17) {
      return 'Good afternoon! ☀️';
    } else {
      return 'Good evening! 🌙';
    }
  }
}
