import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/theme/app_colors.dart';
import 'package:medicine_app/theme/text_styles.dart';
export 'package:medicine_app/theme/app_colors.dart';
export 'package:medicine_app/theme/text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = TextTheme(
      displayLarge: GoogleFonts.manrope(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      displayMedium: GoogleFonts.manrope(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      bodyLarge: GoogleFonts.openSans(
        fontSize: 16.sp,
        color: AppColors.textDark,
      ),
      bodyMedium: GoogleFonts.openSans(
        fontSize: 14.sp,
        color: AppColors.textDark,
      ),
      labelLarge: GoogleFonts.openSans(
        fontSize: 12.sp,
        color: AppColors.textDark,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      titleMedium: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textDark,
      ),
    );

    final customTextStyles = baseTextTheme;

    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        brightness: Brightness.light,
      ),
      textTheme: baseTextTheme,
      useMaterial3: true,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: baseTextTheme.headlineMedium,
        iconTheme: const IconThemeData(color: AppColors.iconDefaultDark),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        titleTextStyle: customTextStyles.titleLargeBold,
        contentTextStyle: customTextStyles.bodyLarge,
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textDark,
          textStyle: baseTextTheme.bodyMedium,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: baseTextTheme.bodyLarge,
        floatingLabelStyle: baseTextTheme.bodyMedium!.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
        errorStyle: customTextStyles.errorStyle,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        helperStyle: baseTextTheme.bodyMedium,
        hintStyle: baseTextTheme.bodyMedium,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.borderLight,
        selectedColor: AppColors.primaryOpacity20,
        deleteIconColor: AppColors.background,
        labelStyle: baseTextTheme.bodyMedium!.copyWith(
          color: AppColors.textDark,
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),

      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: AppColors.background,
        color: AppColors.primary,
        fillColor: AppColors.primary,
        borderColor: AppColors.borderLight,
        selectedBorderColor: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        borderWidth: 1.5,
        textStyle: baseTextTheme.bodyMedium!.copyWith(color: AppColors.primary),
      ),

      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.background,
        helpTextStyle: baseTextTheme.bodyMedium!.copyWith(
          color: AppColors.background,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
        hourMinuteTextStyle: baseTextTheme.bodyLarge!.copyWith(fontSize: 20.sp),
        dayPeriodTextStyle: baseTextTheme.bodyLarge!.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        dialBackgroundColor: AppColors.primaryOpacity50,
        dialHandColor: AppColors.primary,
        entryModeIconColor: AppColors.primary,
        hourMinuteColor: AppColors.primaryOpacity10,
        hourMinuteTextColor: AppColors.textDark,
        cancelButtonStyle: TextButton.styleFrom(
          textStyle: baseTextTheme.bodyLarge,
          foregroundColor: AppColors.textDark,
        ),
        confirmButtonStyle: TextButton.styleFrom(
          textStyle: baseTextTheme.bodyLarge,
          foregroundColor: AppColors.primary,
        ),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.background,
        headerForegroundColor: AppColors.background,
        headerBackgroundColor: AppColors.primary,
        dayForegroundColor: WidgetStateProperty.all(AppColors.textDark),
        weekdayStyle: baseTextTheme.bodyMedium,

        confirmButtonStyle: TextButton.styleFrom(
          textStyle: baseTextTheme.bodyLarge,
          foregroundColor: AppColors.primary,
        ),
        cancelButtonStyle: TextButton.styleFrom(
          textStyle: baseTextTheme.bodyLarge,
          foregroundColor: AppColors.textDark,
        ),
      ),
    );
  }
}
