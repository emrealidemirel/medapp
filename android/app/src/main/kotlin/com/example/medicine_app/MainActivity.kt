package com.example.medicine_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.ContentResolver
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build

class MainActivity : FlutterActivity() {
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // SDK 26 (Android 8.0 Oreo) ve sonrası için kanal oluşturma
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            
            // KRİTİK DÜZELTME: Dart kodunuzdaki ID ile eşleştirildi.
            val channelId = "medication_channel_id" 
            val channelName = "İlaç Hatırlatıcıları"
            val importance = NotificationManager.IMPORTANCE_MAX
            
            val channel = NotificationChannel(
                channelId, 
                channelName, 
                importance
            )
            
            // Ses URI'sı oluşturulurken R.raw kullanıldı.
            // NOT: R.raw otomatik olarak içe aktarılır.
            val soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + 
                packageName + "/" + R.raw.alarm_sound)
                
            val audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()

            // Kanal ayarları: Sesi ve ses özniteliklerini ata
            channel.setSound(soundUri, audioAttributes)
            
            channel.enableVibration(true)
            channel.vibrationPattern = longArrayOf(1000, 1000, 1000)
            channel.enableLights(true)

            // Bildirim Yöneticisi aracılığıyla kanalı sisteme kaydet
            val notificationManager: NotificationManager = 
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            
            notificationManager.createNotificationChannel(channel)
        }
    }
}