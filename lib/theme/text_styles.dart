import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/theme/app_colors.dart';

extension CustomTextStyles on TextTheme {
  TextStyle get labelMediumBold => bodyMedium!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  TextStyle get titleLargeBold => titleLarge!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  // Boş Ekran Başlık Stili
  TextStyle get headlineSmallPrimaryBold => headlineSmall!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  TextStyle get headlineSmallBold => headlineSmall!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  // Boş Ekran Açıklama Metni Stili
  TextStyle get bodyLargeGreyItalic => bodyLarge!.copyWith(
    color: AppColors.textGrey,
    fontStyle: FontStyle.italic,
  );

  // MedicineCard Primary Alanındaki İlaç Adı (Beyaz ve Büyütülmüş)
  TextStyle get cardTitlePrimary => bodyLarge!.copyWith(
    color: AppColors.background,
    fontWeight: FontWeight.bold,
    fontSize: 18.sp, // Büyütüldü
  );

  // Sayfa Alt Başlık Stili (Örn: "Bekleyen Bildirimler")
  TextStyle get listHeaderTitle => headlineSmall!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  // Kart İçindeki Beyaz İtalik Etiket Stili
  TextStyle get cardTagWhiteItalic =>
      bodyLarge!.copyWith(color: Colors.white70, fontStyle: FontStyle.italic);

  // Log Item Başlık Stili (bodyLarge + Bold)
  TextStyle get logItemTitle => bodyLarge!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  // Log Item Tarih/Saat Stili (bodyMedium + Koyu Gri)
  TextStyle get logItemDateTime => bodyMedium!.copyWith(
    fontSize: 15.sp,
    color: AppColors.textGrey, // Colors.grey.shade600
  );

  // bodyMedium + Semi-Bold (Status Text için)
  TextStyle get bodyMediumSemiBold => bodyMedium!.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  TextStyle get cardTitleWhite => titleMedium!.copyWith(
    color: AppColors.background,
    fontWeight: FontWeight.bold,
  );

  TextStyle get cardNotificationTitle => GoogleFonts.openSans(
    fontSize: 18.sp,
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
  );

  TextStyle get errorStyle =>
      bodyMedium!.copyWith(color: AppColors.danger, fontSize: 14.sp);

  TextStyle get chipLabelSelected =>
      bodyLarge!.copyWith(color: AppColors.background);

  // Primary renkli bodyMedium
  TextStyle get bodyMediumPrimary =>
      bodyMedium!.copyWith(color: AppColors.primary);

  // Primary renkli bodyMedium + Bold (Dialog aksiyon butonu için)
  TextStyle get bodyMediumPrimaryBold => bodyMedium!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Danger renkli bodyMedium + Bold (Dialog aksiyon butonu için)
  TextStyle get bodyMediumDangerBold => bodyMedium!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.danger,
  );

  // Seçili FilterChip metni
  TextStyle get filterChipSelected => bodyMedium!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  // Nav Bar Metni Stili (Poppins, Daha Büyük, Beyaz, Bold)
  TextStyle get navBarLabelWhiteBold => GoogleFonts.poppins(
    fontSize: 14.sp, // Boyut büyütüldü
    color: AppColors.background, // Beyaz
    fontWeight: FontWeight.bold, // Kalın
  );

  // Bildirim Rozeti Metni Stili (Küçük, Beyaz, Bold)
  TextStyle get notificationBadge => TextStyle(
    color: AppColors.background,
    fontSize: 12.sp, // Responsive boyutu korundu
    fontWeight: FontWeight.bold,
  );

  // Aksiyon Butonu Metni Stili (bodyLarge + Bold)
  TextStyle get actionButtonTextBase => bodyMedium!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textDark, // Varsayılan renk
  );

  // Tooltip Metin Stili (bodyMedium + Beyaz)
  TextStyle get tooltipTextWhite =>
      bodyMedium!.copyWith(color: AppColors.background);

  // Bildirim Kartı Bilgilendirme Metni Stili
  TextStyle get notificationInfoText => bodyMedium!.copyWith(
    // bodyMedium (14.sp) boyutunu 12.sp'ye indiriyoruz
    fontSize: 15.sp,
    color: AppColors.primaryInfoText, // primary.withOpacity(0.8)
    fontStyle: FontStyle.italic,
  );

  // Medicine List İkon ve Bilgi Yazısı
  TextStyle get medicineListInfo => bodyLarge!.copyWith(
    // bodyLarge (16.sp) kullanıldı
    color: AppColors.textDark,
  );

  // Medicine List Aksiyon Buton Yazısı
  TextStyle get medicineListActionSmall => labelLarge!.copyWith(
    fontSize: 10.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  // Form Etiketleri için ("Günleri Seçiniz", "Tarih Seçiniz", "Saat Seçiniz")
  TextStyle get formSectionHeader => headlineSmall!.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // ToggleButton Seçili Metin Stili (Beyaz ve Bold)
  TextStyle get toggleButtonSelectedWhiteBold => bodyMedium!.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.background, // Beyaz
  );

  // bodyLarge + Semi-Bold (Semi-Bold etiketler için, örn: Sürekli Alınacak İlaç)
  TextStyle get bodyLargeSemiBold => bodyLarge!.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
}