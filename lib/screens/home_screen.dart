import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/app_provider.dart';
import '../providers/patient_provider.dart';
import '../providers/diagnosis_provider.dart';
import '../core/theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/stats_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recent_diagnoses_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.forward();
    _loadData();
  }

  Future<void> _loadData() async {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    final diagnosisProvider = Provider.of<DiagnosisProvider>(context, listen: false);
    
    await Future.wait([
      patientProvider.loadPatients(),
      diagnosisProvider.loadDiagnoses(),
    ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: _selectedIndex == 0 ? _buildHomeContent() : _buildOtherContent(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _selectedIndex == 0 ? _buildFloatingActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط التطبيق المخصص
            const CustomAppBar(),
            
            // بطاقة الترحيب
            AnimationConfiguration.staggeredList(
              position: 0,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildWelcomeCard(),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // الإحصائيات
            AnimationConfiguration.staggeredList(
              position: 1,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildStatsSection(),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // الإجراءات السريعة
            AnimationConfiguration.staggeredList(
              position: 2,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildQuickActionsSection(),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // التشخيصات الأخيرة
            AnimationConfiguration.staggeredList(
              position: 3,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildRecentDiagnosesSection(),
                ),
              ),
            ),
            
            const SizedBox(height: 100), // مساحة للـ FAB
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'في تطبيق تشخيص الأمراض الجلدية',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'استخدم الذكاء الاصطناعي للحصول على تشخيص أولي دقيق للأمراض الجلدية',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Consumer3<PatientProvider, DiagnosisProvider, AppProvider>(
      builder: (context, patientProvider, diagnosisProvider, appProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الإحصائيات',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'المرضى',
                      value: patientProvider.patients.length.toString(),
                      icon: Icons.people,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: 'التشخيصات',
                      value: diagnosisProvider.diagnoses.length.toString(),
                      icon: Icons.analytics,
                      color: AppTheme.successColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'تمت المراجعة',
                      value: diagnosisProvider.reviewedCount.toString(),
                      icon: Icons.check_circle,
                      color: AppTheme.infoColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      title: 'في الانتظار',
                      value: diagnosisProvider.pendingCount.toString(),
                      icon: Icons.pending,
                      color: AppTheme.warningColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإجراءات السريعة',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              QuickActionCard(
                title: 'تشخيص جديد',
                subtitle: 'التقط صورة للتشخيص',
                icon: Icons.camera_alt,
                color: AppTheme.primaryColor,
                onTap: () => context.push('/camera'),
              ),
              QuickActionCard(
                title: 'المرضى',
                subtitle: 'إدارة سجلات المرضى',
                icon: Icons.people,
                color: AppTheme.successColor,
                onTap: () => context.push('/patients'),
              ),
              QuickActionCard(
                title: 'التاريخ المرضي',
                subtitle: 'عرض التشخيصات السابقة',
                icon: Icons.history,
                color: AppTheme.infoColor,
                onTap: () => context.push('/history'),
              ),
              QuickActionCard(
                title: 'التقارير',
                subtitle: 'إنشاء وعرض التقارير',
                icon: Icons.assessment,
                color: AppTheme.warningColor,
                onTap: () => context.push('/reports'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentDiagnosesSection() {
    return Consumer<DiagnosisProvider>(
      builder: (context, diagnosisProvider, child) {
        final recentDiagnoses = diagnosisProvider.diagnoses.take(5).toList();
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'التشخيصات الأخيرة',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/history'),
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (recentDiagnoses.isEmpty)
                _buildEmptyState()
              else
                RecentDiagnosesList(diagnoses: recentDiagnoses),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد تشخيصات بعد',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإجراء تشخيص جديد',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherContent() {
    switch (_selectedIndex) {
      case 1:
        return const Center(
          child: Text('شاشة المرضى'),
        );
      case 2:
        return const Center(
          child: Text('شاشة التاريخ المرضي'),
        );
      case 3:
        return const Center(
          child: Text('شاشة الإعدادات'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'الرئيسية', 0),
          _buildNavItem(Icons.people, 'المرضى', 1),
          const SizedBox(width: 40), // مساحة للـ FAB
          _buildNavItem(Icons.history, 'التاريخ', 2),
          _buildNavItem(Icons.settings, 'الإعدادات', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => context.push('/camera'),
      backgroundColor: AppTheme.primaryColor,
      child: const Icon(
        Icons.camera_alt,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}