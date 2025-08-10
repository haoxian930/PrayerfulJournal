import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color palette inspired by peaceful, spiritual themes
  static const Color primaryColor = Color(0xFF6B73FF); // Soft purple-blue
  static const Color primaryLightColor = Color(0xFF9A9FFF);
  static const Color primaryDarkColor = Color(0xFF3D47CC);
  
  static const Color secondaryColor = Color(0xFFFFB74D); // Warm gold
  static const Color secondaryLightColor = Color(0xFFFFE97D);
  static const Color secondaryDarkColor = Color(0xFFC88719);
  
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  static const Color textPrimaryColor = Color(0xFF2C2C2C);
  static const Color textSecondaryColor = Color(0xFF6B6B6B);
  static const Color textLightColor = Color(0xFF9E9E9E);
  
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);
  static const Color warningColor = Color(0xFFFFB74D);
  
  // Prayer status colors
  static const Color pendingColor = Color(0xFFE1F5FE);
  static const Color inProgressColor = Color(0xFFFFF3E0);
  static const Color answeredColor = Color(0xFFE8F5E8);
  
  // Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  static const Color darkTextPrimaryColor = Color(0xFFE1E1E1);
  static const Color darkTextSecondaryColor = Color(0xFFB0B0B0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: MaterialColor(primaryColor.value, {
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor,
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryDarkColor,
    }),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryLightColor,
      secondary: secondaryColor,
      secondaryContainer: secondaryLightColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    dividerColor: Colors.grey.withOpacity(0.1),
    
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimaryColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimaryColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondaryColor,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryColor,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textLightColor,
      ),
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      ),
      iconTheme: const IconThemeData(color: textPrimaryColor),
    ),
    
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: textSecondaryColor,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: textLightColor,
      ),
    ),
    
    chipTheme: ChipThemeData(
      backgroundColor: primaryColor.withOpacity(0.1),
      labelStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: primaryColor,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    ),
    
    dividerTheme: DividerThemeData(
      color: Colors.grey.withOpacity(0.1),
      thickness: 1,
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textLightColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static ThemeData darkTheme = lightTheme.copyWith(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryLightColor,
      primaryContainer: primaryColor,
      secondary: secondaryLightColor,
      secondaryContainer: secondaryColor,
      surface: darkSurfaceColor,
      error: errorColor,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: darkTextPrimaryColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    appBarTheme: lightTheme.appBarTheme.copyWith(
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkTextPrimaryColor,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkTextPrimaryColor,
      ),
      iconTheme: const IconThemeData(color: darkTextPrimaryColor),
    ),
    cardTheme: lightTheme.cardTheme.copyWith(
      color: darkCardColor,
    ),
    inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
      fillColor: Colors.white.withOpacity(0.05),
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: darkTextSecondaryColor,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: darkTextSecondaryColor.withOpacity(0.7),
      ),
    ),
    bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(
      backgroundColor: darkSurfaceColor,
      selectedItemColor: primaryLightColor,
      unselectedItemColor: darkTextSecondaryColor,
    ),
  );

  // Helper methods for getting colors based on prayer status
  static Color getPrayerStatusColor(String status, {bool isDark = false}) {
    switch (status.toLowerCase()) {
      case 'pending':
        return isDark ? const Color(0xFF1A2332) : pendingColor;
      case 'in progress':
      case 'inprogress':
        return isDark ? const Color(0xFF2D2516) : inProgressColor;
      case 'answered':
        return isDark ? const Color(0xFF1B2B1B) : answeredColor;
      default:
        return isDark ? darkCardColor : cardColor;
    }
  }

  static Color getCategoryColor(String category) {
    final colors = {
      'personal': const Color(0xFF6B73FF),
      'family': const Color(0xFFE91E63),
      'ministry': const Color(0xFF9C27B0),
      'global': const Color(0xFF00BCD4),
      'health': const Color(0xFF4CAF50),
      'work': const Color(0xFFFF9800),
      'relationships': const Color(0xFFF44336),
      'spiritual': const Color(0xFF3F51B5),
    };
    return colors[category.toLowerCase()] ?? primaryColor;
  }
}
