  import 'dart:ui';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';

  class AppTheme {
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 🎨 MODERN COLOR PALETTE - Indigo/Purple Theme
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    // Primary - Indigo (Modern, Professional, Tech)
    static const Color primary = Color(0xFF6366F1);
    static const Color primaryLight = Color(0xFF818CF8);
    static const Color primaryDark = Color(0xFF4F46E5);

    // Secondary - Blue
    static const Color secondary = Color(0xFF3B82F6);
    static const Color secondaryLight = Color(0xFF60A5FA);
    static const Color secondaryDark = Color(0xFF2563EB);

    // Accent - Pink/Purple
    static const Color accent = Color(0xFFEC4899);
    static const Color accentLight = Color(0xFFF472B6);
    static const Color accentDark = Color(0xFFDB2777);

    // Neutral Colors - Light Theme
    static const Color background = Color(0xFFF8F9FE);
    static const Color surface = Color(0xFFFFFFFF);
    static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors - Light Theme
    static const Color textPrimary = Color(0xFF1A1F3A);
    static const Color textSecondary = Color(0xFF64748B);
    static const Color textTertiary = Color(0xFF94A3B8);
    static const Color textOnPrimary = Color(0xFFFFFFFF);

    // Status Colors
    static const Color success = Color(0xFF10B981);
    static const Color warning = Color(0xFFF59E0B);
    static const Color error = Color(0xFFEF4444);
    static const Color info = Color(0xFF3B82F6);

    // Special Colors
    static const Color energyProduction = Color(0xFFF59E0B);
    static const Color cleaningActive = Color(0xFF06B6D4);
    static const Color demoMode = Color(0xFFEC4899);
    static const Color cardShadow = Color(0x0D000000);

    // Dark Theme Colors
    static const Color darkBackground = Color(0xFF0A0E21);
    static const Color darkSurface = Color(0xFF1A1F3A);
    static const Color darkSurfaceVariant = Color(0xFF252B47);
    static const Color darkTextPrimary = Color(0xFFF8FAFC);
    static const Color darkTextSecondary = Color(0xFFCBD5E1);
    static const Color darkTextTertiary = Color(0xFF94A3B8);
    static const Color darkCardShadow = Color(0x26000000);

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 📐 SPACING SYSTEM (Responsive)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    static double get space4 => 4.w;
    static double get space8 => 8.w;
    static double get space12 => 12.w;
    static double get space16 => 16.w;
    static double get space20 => 20.w;
    static double get space24 => 24.w;
    static double get space32 => 32.w;
    static double get space48 => 48.w;

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 🔲 BORDER RADIUS (Responsive)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    static double get radiusSmall => 12.r;
    static double get radiusMedium => 16.r;
    static double get radiusLarge => 20.r;
    static double get radiusXLarge => 24.r;
    static const double radiusCircular = 999.0;

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // ✨ ELEVATION & SHADOWS (Responsive)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    static List<BoxShadow> get shadowSmall => [
      BoxShadow(
        color: cardShadow,
        offset: Offset(0, 4.h),
        blurRadius: 10.r,
      )
    ];



    static List<BoxShadow> get shadowMedium => [
      BoxShadow(
        color: cardShadow,
        offset: Offset(0, 8.h),
        blurRadius: 20.r,
      )
    ];

    static List<BoxShadow> get shadowLarge => [
      BoxShadow(
        color: cardShadow,
        offset: Offset(0, 12.h),
        blurRadius: 30.r,
      )
    ];

    static List<BoxShadow> get darkShadowSmall => [
      BoxShadow(
        color: darkCardShadow,
        offset: Offset(0, 4.h),
        blurRadius: 10.r,
      )
    ];

    static List<BoxShadow> get darkShadowMedium => [
      BoxShadow(
        color: darkCardShadow,
        offset: Offset(0, 8.h),
        blurRadius: 20.r,
      )
    ];

    static List<BoxShadow> get darkShadowLarge => [
      BoxShadow(
        color: darkCardShadow,
        offset: Offset(0, 12.h),
        blurRadius: 30.r,
      )
    ];

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 📝 TEXT STYLE HELPERS - Using Poppins & Inter
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    // Poppins for headings (bold, impactful)
    static TextStyle _poppins(double size, FontWeight weight, {Color? color, double? spacing, double? height}) =>
        GoogleFonts.poppins(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: spacing,
          height: height,
        );

    // Inter for body text (readable, clean)
    static TextStyle _inter(double size, FontWeight weight, {Color? color, double? spacing, double? height}) =>
        GoogleFonts.inter(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: spacing,
          height: height,
        );

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 🎨 LIGHT THEME (Modern Design)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    static ThemeData get lightTheme {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: primary,
          onPrimary: textOnPrimary,
          secondary: secondary,
          onSecondary: textOnPrimary,
          tertiary: accent,
          surface: surface,
          onSurface: textPrimary,
          error: error,
          onError: textOnPrimary,
          outline: Color(0xFFE2E8F0),
          shadow: cardShadow,
          surfaceContainerHighest: surfaceVariant,
        ),
        scaffoldBackgroundColor: background,

        appBarTheme: AppBarTheme(
          backgroundColor: surface,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
          ),
          titleTextStyle: _poppins(20.sp, FontWeight.w600, color: textPrimary),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: textOnPrimary,
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
            textStyle: _inter(16.sp, FontWeight.w600),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: BorderSide(color: primary, width: 1.5.w),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
            textStyle: _inter(16.sp, FontWeight.w600),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primary,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSmall),
            ),
            textStyle: _inter(14.sp, FontWeight.w600),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide(color: primary, width: 2.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide(color: error, width: 1.w),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          hintStyle: _inter(14.sp, FontWeight.normal, color: textTertiary),
        ),


        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: primary,
          unselectedItemColor: textTertiary,
          selectedLabelStyle: _inter(12.sp, FontWeight.w600),
          unselectedLabelStyle: _inter(12.sp, FontWeight.normal),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        dividerTheme: DividerThemeData(
          color: const Color(0xFFE2E8F0),
          thickness: 1.h,
          space: 1.h,
        ),

        textTheme: TextTheme(
          // Display styles - Poppins (headings)
          displayLarge: _poppins(32.sp, FontWeight.bold, spacing: -0.5, height: 1.2),
          displayMedium: _poppins(28.sp, FontWeight.bold, spacing: -0.5, height: 1.3),
          displaySmall: _poppins(24.sp, FontWeight.bold, spacing: -0.25, height: 1.3),

          // Headline styles - Poppins
          headlineLarge: _poppins(22.sp, FontWeight.w600, height: 1.4),
          headlineMedium: _poppins(20.sp, FontWeight.w600, height: 1.4),
          headlineSmall: _poppins(18.sp, FontWeight.w600, height: 1.4),

          // Title styles - Poppins
          titleLarge: _poppins(16.sp, FontWeight.w600, height: 1.5),
          titleMedium: _poppins(14.sp, FontWeight.w600, height: 1.5),
          titleSmall: _poppins(12.sp, FontWeight.w600, height: 1.5),

          // Body styles - Inter (readable)
          bodyLarge: _inter(16.sp, FontWeight.normal, height: 1.6),
          bodyMedium: _inter(14.sp, FontWeight.normal, height: 1.6),
          bodySmall: _inter(10.sp, FontWeight.normal, height: 1.5),

          // Label styles - Inter
          labelLarge: _inter(14.sp, FontWeight.w600, spacing: 0.5),
          labelMedium: _inter(12.sp, FontWeight.w600, spacing: 0.5),
          labelSmall: _inter(10.sp, FontWeight.w600, spacing: 0.5),
        ),

        iconTheme: IconThemeData(color: textSecondary, size: 24.sp),
      );
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 🌙 DARK THEME (Modern Design)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    static ThemeData get darkTheme {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: primaryLight,
          onPrimary: Color(0xFF000000),
          secondary: secondaryLight,
          onSecondary: Color(0xFF000000),
          tertiary: accentLight,
          onTertiary: Color(0xFF000000),
          surface: darkSurface,
          onSurface: darkTextPrimary,
          error: error,
          onError: Color(0xFFFFFFFF),
          outline: Color(0xFF3D4A5C),
          shadow: darkCardShadow,
          surfaceContainerHighest: darkSurfaceVariant,
        ),
        scaffoldBackgroundColor: darkBackground,

        appBarTheme: AppBarTheme(
          backgroundColor: darkSurface,
          foregroundColor: darkTextPrimary,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
          ),
          titleTextStyle: _poppins(20.sp, FontWeight.w600, color: darkTextPrimary),
          iconTheme: IconThemeData(color: darkTextPrimary, size: 24.sp),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryLight,
            foregroundColor: const Color(0xFF000000),
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
            textStyle: _inter(16.sp, FontWeight.w600),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryLight,
            side: BorderSide(color: primaryLight, width: 1.5.w),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
            textStyle: _inter(16.sp, FontWeight.w600),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryLight,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSmall),
            ),
            textStyle: _inter(14.sp, FontWeight.w600),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkSurfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide(color: primaryLight, width: 2.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide(color: error, width: 1.w),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          hintStyle: _inter(14.sp, FontWeight.normal, color: darkTextSecondary),
          labelStyle: _inter(14.sp, FontWeight.normal, color: darkTextSecondary),
        ),



        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: darkSurface,
          selectedItemColor: primaryLight,
          unselectedItemColor: darkTextSecondary,
          selectedLabelStyle: _inter(12.sp, FontWeight.w600),
          unselectedLabelStyle: _inter(12.sp, FontWeight.normal),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? primaryLight : darkTextTertiary),
          trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? primaryLight.withOpacity(0.5)
              : darkSurfaceVariant),
        ),

        dividerTheme: DividerThemeData(
          color: const Color(0xFF3D4A5C),
          thickness: 1.h,
          space: 1.h,
        ),

        textTheme: TextTheme(
          // Display styles - Poppins
          displayLarge: _poppins(32.sp, FontWeight.bold, color: darkTextPrimary, spacing: -0.5, height: 1.2),
          displayMedium: _poppins(28.sp, FontWeight.bold, color: darkTextPrimary, spacing: -0.5, height: 1.3),
          displaySmall: _poppins(24.sp, FontWeight.bold, color: darkTextPrimary, spacing: -0.25, height: 1.3),

          // Headline styles - Poppins
          headlineLarge: _poppins(22.sp, FontWeight.w600, color: darkTextPrimary, height: 1.4),
          headlineMedium: _poppins(20.sp, FontWeight.w600, color: darkTextPrimary, height: 1.4),
          headlineSmall: _poppins(18.sp, FontWeight.w600, color: darkTextPrimary, height: 1.4),

          // Title styles - Poppins
          titleLarge: _poppins(16.sp, FontWeight.w600, color: darkTextPrimary, height: 1.5),
          titleMedium: _poppins(14.sp, FontWeight.w600, color: darkTextPrimary, height: 1.5),
          titleSmall: _poppins(12.sp, FontWeight.w600, color: darkTextPrimary, height: 1.5),

          // Body styles - Inter
          bodyLarge: _inter(16.sp, FontWeight.normal, color: darkTextPrimary, height: 1.6),
          bodyMedium: _inter(14.sp, FontWeight.normal, color: darkTextPrimary, height: 1.6),
          bodySmall: _inter(10.sp, FontWeight.normal, color: darkTextSecondary, height: 1.5),

          // Label styles - Inter
          labelLarge: _inter(14.sp, FontWeight.w600, color: darkTextPrimary, spacing: 0.5),
          labelMedium: _inter(12.sp, FontWeight.w600, color: darkTextPrimary, spacing: 0.5),
          labelSmall: _inter(10.sp, FontWeight.w600, color: darkTextSecondary, spacing: 0.5),
        ),

        iconTheme: IconThemeData(color: darkTextSecondary, size: 24.sp),
        primaryIconTheme: IconThemeData(color: primaryLight, size: 24.sp),
      );
    }
  }