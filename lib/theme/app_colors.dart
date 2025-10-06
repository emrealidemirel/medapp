import 'package:flutter/material.dart';

class AppColors {
  // Ana renk: Teal 400
  static const Color primary = Color(0xFF26A69A);

  // Ana rengin %80 opaklıktaki hali
  static final Color primaryInfoText = primary.withAlpha(200);

  // Ana rengin %10 opaklıktaki hali - TimePicker için
  static final Color primaryOpacity10 = primary.withAlpha(25);

  // Ana rengin %50 opaklıktaki hali - TimePicker ve Boş Ekran İkonları için
  static final Color primaryOpacity50 = primary.withAlpha(125);

  // Ana rengin %20 opaklıktaki hali (DaySelector seçili arka plan)
  static final Color primaryOpacity20 = primary.withAlpha(50);

  // Bildirim Butonu için Siyah renk
  static const Color iconDefaultDark = Colors.black87;

  // Tehlike Rengi (Kırmızı)
  static final Color danger = Colors.red.shade700;

  // Arka Plan Renkleri
  static const Color background = Colors.white;
  static const Color cardBackground = Color(0xFFF7F7F7); // Bildirim kartı

  // Metin Renkleri
  static const Color textDark = Colors.black87;
  static final Color textGrey = Colors.grey.shade600;
  static final Color textDisabled = textDark.withAlpha(150);

  // Kenarlıklar ve Ayırıcılar
  static final Color dividerGrey = Colors.grey.withAlpha(125);
  static final Color borderLight = Colors.grey.shade300;
  static const Color border = Color(0xFFBDBDBD);

  // Gölge Renkleri
  static final Color shadowDarkOpacity50 = textDark.withAlpha(125);
  static final Color shadowDarkOpacity20 = textDark.withAlpha(50);
  static final Color shadowDarkOpacity05 = textDark.withAlpha(15);

  // Gradient
  static final LinearGradient primaryGradient = LinearGradient(
    colors: [Colors.teal.shade700, primary],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}