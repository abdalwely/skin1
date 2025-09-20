import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/database_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/ai_service.dart';
import 'providers/app_provider.dart';
import 'providers/patient_provider.dart';
import 'providers/diagnosis_provider.dart';
import 'providers/settings_provider.dart';
import 'models/patient.dart';
import 'models/diagnosis_record.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة Hive
  await Hive.initFlutter();
  
  // تسجيل المحولات
  Hive.registerAdapter(PatientAdapter());
  Hive.registerAdapter(DiagnosisRecordAdapter());
  
  // تهيئة الخدمات
  await DatabaseService.instance.initialize();
  await StorageService.instance.initialize();
  
  runApp(const SkinDiseaseApp());
}

class SkinDiseaseApp extends StatelessWidget {
  const SkinDiseaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // إعداد شريط الحالة
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => DiagnosisProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp.router(
            title: 'تشخيص الأمراض الجلدية',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.themeMode,
            routerConfig: AppRouter.router,
            locale: settingsProvider.locale,
            supportedLocales: const [
              Locale('ar', 'SA'),
              Locale('en', 'US'),
            ],
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: settingsProvider.textScale,
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}