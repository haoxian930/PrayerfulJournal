import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> with WidgetsBindingObserver {
  bool _showThankYou = false;
  bool _donationInProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _donationInProgress) {
      // User has returned to the app after visiting PayPal
      setState(() {
        _showThankYou = true;
        _donationInProgress = false;
      });
      
      // Hide thank you message after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _showThankYou = false;
          });
        }
      });
    }
  }

  Future<void> _launchPayPalDonation() async {
    const paypalUrl = 'https://www.paypal.com/ncp/payment/7TVBYJHRVY628';
    
    try {
      final Uri uri = Uri.parse(paypalUrl);
      setState(() {
        _donationInProgress = true;
      });
      
      // Try different launch modes for better Android compatibility
      bool launched = false;
      
      // First try external application
      if (await canLaunchUrl(uri)) {
        launched = await launchUrl(
          uri, 
          mode: LaunchMode.externalApplication,
        );
      }
      
      // If that fails, try platform default
      if (!launched) {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      }
      
      // If still failed, try in-app web view as last resort
      if (!launched) {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
        );
      }
      
      if (!launched) {
        setState(() {
          _donationInProgress = false;
        });
        _showErrorDialog('Unable to open donation page. Please visit:\n$paypalUrl');
      }
    } catch (e) {
      setState(() {
        _donationInProgress = false;
      });
      _showErrorDialog('Error opening donation link: $e\n\nPlease visit: $paypalUrl');
    }
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unable to Open Donation Page'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Support PrayerfulJournal',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2D3748)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 32,
                          color: Color(0xFF667EEA),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Support Our Mission',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Help us keep PrayerfulJournal free and ad-free for everyone',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF718096),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Why Support Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why Support Us?',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.block,
                        title: 'No Ads',
                        description: 'Peaceful prayer time without interruptions',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.security,
                        title: 'Privacy First',
                        description: 'Your prayers stay private on your device',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.update,
                        title: 'Regular Updates',
                        description: 'New features and improvements',
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(
                        icon: Icons.support,
                        title: 'Free Forever',
                        description: 'Accessible to everyone, regardless of means',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Donation Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Make a Donation',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your support helps us maintain and improve PrayerfulJournal for the entire community.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _donationInProgress ? null : _launchPayPalDonation,
                          icon: _donationInProgress 
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.favorite, color: Colors.white),
                          label: Text(
                            _donationInProgress ? 'Opening donation page...' : 'Make a Donation',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667EEA),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFF667EEA),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Supports PayPal, Venmo, and all major credit/debit cards securely.',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF667EEA),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Thank You Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Every Contribution Matters',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Whether big or small, your support makes a real difference in keeping this app available for everyone. Thank you for being part of our prayer community! 🙏',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF718096),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
          
          // Thank You Overlay
          if (_showThankYou)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          size: 48,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Thank You! 🙏',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your generosity helps keep PrayerfulJournal free for everyone. May God bless you abundantly!',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF718096),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: const Color(0xFF667EEA),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF718096),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
