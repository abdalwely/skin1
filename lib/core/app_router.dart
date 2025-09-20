import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../screens/diagnosis/camera_screen.dart';
import '../screens/diagnosis/image_preview_screen.dart';
import '../screens/diagnosis/diagnosis_result_screen.dart';
import '../screens/patients/patients_list_screen.dart';
import '../screens/patients/patient_details_screen.dart';
import '../screens/patients/add_patient_screen.dart';
import '../screens/history/diagnosis_history_screen.dart';
import '../screens/history/history_details_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/reports/report_details_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/profile_screen.dart';
import '../screens/settings/about_screen.dart';
import '../screens/settings/help_screen.dart';
import '../screens/settings/privacy_screen.dart';
import '../screens/education/education_screen.dart';
import '../screens/education/disease_info_screen.dart';
import '../screens/education/article_screen.dart';
import '../screens/statistics/statistics_screen.dart';
import '../screens/backup/backup_screen.dart';
import '../screens/notifications/notifications_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // شاشة البداية
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // شاشة التعريف بالتطبيق
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // الشاشة الرئيسية
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // شاشات التشخيص
      GoRoute(
        path: '/camera',
        name: 'camera',
        builder: (context, state) => const CameraScreen(),
      ),
      GoRoute(
        path: '/image-preview',
        name: 'image-preview',
        builder: (context, state) => ImagePreviewScreen(
          imagePath: state.extra as String,
        ),
      ),
      GoRoute(
        path: '/diagnosis-result',
        name: 'diagnosis-result',
        builder: (context, state) => DiagnosisResultScreen(
          diagnosisData: state.extra as Map<String, dynamic>,
        ),
      ),
      
      // شاشات المرضى
      GoRoute(
        path: '/patients',
        name: 'patients',
        builder: (context, state) => const PatientsListScreen(),
        routes: [
          GoRoute(
            path: '/add',
            name: 'add-patient',
            builder: (context, state) => const AddPatientScreen(),
          ),
          GoRoute(
            path: '/:patientId',
            name: 'patient-details',
            builder: (context, state) => PatientDetailsScreen(
              patientId: state.pathParameters['patientId']!,
            ),
          ),
        ],
      ),
      
      // شاشات التاريخ المرضي
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const DiagnosisHistoryScreen(),
        routes: [
          GoRoute(
            path: '/:recordId',
            name: 'history-details',
            builder: (context, state) => HistoryDetailsScreen(
              recordId: state.pathParameters['recordId']!,
            ),
          ),
        ],
      ),
      
      // شاشات التقارير
      GoRoute(
        path: '/reports',
        name: 'reports',
        builder: (context, state) => const ReportsScreen(),
        routes: [
          GoRoute(
            path: '/:reportId',
            name: 'report-details',
            builder: (context, state) => ReportDetailsScreen(
              reportId: state.pathParameters['reportId']!,
            ),
          ),
        ],
      ),
      
      // شاشات الإحصائيات
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
      
      // شاشات التعليم
      GoRoute(
        path: '/education',
        name: 'education',
        builder: (context, state) => const EducationScreen(),
        routes: [
          GoRoute(
            path: '/disease/:diseaseId',
            name: 'disease-info',
            builder: (context, state) => DiseaseInfoScreen(
              diseaseId: state.pathParameters['diseaseId']!,
            ),
          ),
          GoRoute(
            path: '/article/:articleId',
            name: 'article',
            builder: (context, state) => ArticleScreen(
              articleId: state.pathParameters['articleId']!,
            ),
          ),
        ],
      ),
      
      // شاشات الإعدادات
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/about',
            name: 'about',
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            path: '/help',
            name: 'help',
            builder: (context, state) => const HelpScreen(),
          ),
          GoRoute(
            path: '/privacy',
            name: 'privacy',
            builder: (context, state) => const PrivacyScreen(),
          ),
        ],
      ),
      
      // شاشات النسخ الاحتياطي
      GoRoute(
        path: '/backup',
        name: 'backup',
        builder: (context, state) => const BackupScreen(),
      ),
      
      // شاشة الإشعارات
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}