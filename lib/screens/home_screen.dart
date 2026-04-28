import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/health_service.dart';
import '../services/risk_calculator.dart';
import '../widgets/vital_card.dart';
import '../widgets/risk_gauge.dart';
import '../widgets/heartbeat_wave.dart';
import 'questionnaire_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HealthService _healthService = HealthService();

  bool _isLoading = false;
  bool _hasPermission = false;
  bool _permissionChecked = false;

  HeartRateResult? _hrResult;
  int _steps = 0;
  int? _spo2;

  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _checkPermissions();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final has = await _healthService.hasPermissions();
    if (mounted) {
      setState(() {
        _hasPermission = has;
        _permissionChecked = true;
      });
      if (has) _loadVitals();
    }
  }

  Future<void> _requestPermissionsAndLoad() async {
    setState(() => _isLoading = true);
    final granted = await _healthService.requestPermissions();
    if (mounted) {
      setState(() {
        _hasPermission = granted;
        _isLoading = false;
      });
      if (granted) {
        _loadVitals();
      } else {
        _showPermissionError();
      }
    }
  }

  Future<void> _loadVitals() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      _healthService.getRestingHeartRate(),
      _healthService.getTodaySteps(),
      _healthService.getBloodOxygen(),
    ]);

    if (mounted) {
      setState(() {
        _hrResult = results[0] as HeartRateResult;
        _steps = results[1] as int;
        _spo2 = results[2] as int?;
        _isLoading = false;
      });
    }
  }

  void _showPermissionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Health Connect permission denied. Please grant access in Settings.',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.accentRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _goToQuestionnaire() {
    if (_hrResult == null || !_hrResult!.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please load your heart rate data first.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: AppTheme.accentAmber,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => QuestionnaireScreen(
          restingHR: _hrResult!.restingHeartRate!,
          spo2: _spo2,
        ),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Heartbeat wave visualizer
                  const HeartbeatWave(),
                  const SizedBox(height: 28),
                  // Vitals section header
                  _buildSectionHeader('Live Vitals', Icons.monitor_heart),
                  const SizedBox(height: 16),
                  // Vitals grid
                  _buildVitalsGrid(),
                  const SizedBox(height: 28),
                  // Permission / connect card
                  if (!_hasPermission && _permissionChecked) _buildConnectCard(),
                  if (_hrResult != null && !_hrResult!.success) _buildErrorCard(),
                  // Analyze button
                  if (_hasPermission || !_permissionChecked)
                    _buildAnalyzeButton(),
                  const SizedBox(height: 24),
                  // Quick stats row
                  if (_hrResult != null && _hrResult!.success) _buildQuickStats(),
                  const SizedBox(height: 24),
                  // PCOS info banner
                  _buildPcosBanner(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: AppTheme.bgDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A0A0A), AppTheme.bgDark],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          colors: [Color(0xFFE53E3E), Color(0xFF6B1818)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentRed.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.favorite, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Health Band',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        Text(
                          'Anemia Early Warning System',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textMuted,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildStatusBadge(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String label;
    IconData icon;

    if (_isLoading) {
      color = AppTheme.accentAmber;
      label = 'Syncing';
      icon = Icons.sync;
    } else if (_hasPermission && _hrResult?.success == true) {
      color = AppTheme.accentGreen;
      label = 'Connected';
      icon = Icons.bluetooth_connected;
    } else {
      color = AppTheme.textMuted;
      label = 'Offline';
      icon = Icons.bluetooth_disabled;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accentRed, size: 18),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondary,
                letterSpacing: 2.0,
                fontSize: 11,
              ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.borderColor, Colors.transparent],
              ),
            ),
          ),
        ),
        if (_hasPermission) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : _loadVitals,
            child: Icon(
              Icons.refresh_rounded,
              color: _isLoading ? AppTheme.textMuted : AppTheme.accentBlue,
              size: 18,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVitalsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      childAspectRatio: 1.3,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        VitalCard(
          label: 'Resting HR',
          value: _hrResult?.success == true
              ? '${_hrResult!.restingHeartRate}'
              : '--',
          unit: 'BPM',
          icon: Icons.favorite_rounded,
          gradient: AppTheme.heartGradient,
          isLoading: _isLoading,
          warningThreshold: 100,
          currentValue: _hrResult?.restingHeartRate?.toDouble(),
        ),
        VitalCard(
          label: 'Blood Oxygen',
          value: _spo2 != null ? '$_spo2' : '--',
          unit: 'SpO₂ %',
          icon: Icons.water_drop_rounded,
          gradient: const LinearGradient(
            colors: [AppTheme.accentBlue, AppTheme.accentPurple],
          ),
          isLoading: _isLoading,
          dangerThreshold: 95,
          currentValue: _spo2?.toDouble(),
          belowThresholdIsDanger: true,
        ),
        VitalCard(
          label: "Today's Steps",
          value: _steps > 0 ? _formatSteps(_steps) : '--',
          unit: 'steps',
          icon: Icons.directions_walk_rounded,
          gradient: const LinearGradient(
            colors: [AppTheme.accentGreen, Color(0xFF059669)],
          ),
          isLoading: _isLoading,
        ),
        VitalCard(
          label: 'HR Range',
          value: _hrResult?.success == true
              ? '${_hrResult!.minHeartRate}–${_hrResult!.maxHeartRate}'
              : '--',
          unit: 'BPM 24h',
          icon: Icons.show_chart_rounded,
          gradient: const LinearGradient(
            colors: [AppTheme.accentAmber, Color(0xFFD97706)],
          ),
          isLoading: _isLoading,
        ),
      ],
    );
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) return '${(steps / 1000).toStringAsFixed(1)}k';
    return '$steps';
  }

  Widget _buildConnectCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1200), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentAmber.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentAmber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.health_and_safety_rounded,
                    color: AppTheme.accentAmber, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connect to Health Connect',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Required to read smartwatch data',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _requestPermissionsAndLoad,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentAmber,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Grant Permission',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentRed.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.accentRedGlow, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _hrResult?.errorMessage ?? 'Unable to load health data.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.accentRedGlow,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    final bool canAnalyze = _hrResult?.success == true;
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: canAnalyze ? AppTheme.primaryGradient : null,
              color: canAnalyze ? null : AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              boxShadow: canAnalyze
                  ? [
                      BoxShadow(
                        color: AppTheme.accentRed.withOpacity(0.35),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : null,
            ),
            child: ElevatedButton.icon(
              onPressed: canAnalyze ? _goToQuestionnaire : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: canAnalyze
                      ? BorderSide.none
                      : const BorderSide(color: AppTheme.borderColor),
                ),
              ),
              icon: Icon(
                Icons.analytics_rounded,
                color: canAnalyze ? Colors.white : AppTheme.textMuted,
                size: 22,
              ),
              label: Text(
                'ANALYZE VITALS',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: canAnalyze ? Colors.white : AppTheme.textMuted,
                ),
              ),
            ),
          ),
        ),
        if (!canAnalyze && _hasPermission)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Load heart rate data to enable analysis',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final hr = _hrResult!;
    String hrLabel;
    Color hrColor;

    if (hr.restingHeartRate! >= 100) {
      hrLabel = 'Tachycardia — Anemia Indicator';
      hrColor = AppTheme.accentRed;
    } else if (hr.restingHeartRate! >= 90) {
      hrLabel = 'Elevated — Monitor Closely';
      hrColor = AppTheme.accentAmber;
    } else if (hr.restingHeartRate! >= 60) {
      hrLabel = 'Normal Range';
      hrColor = AppTheme.accentGreen;
    } else {
      hrLabel = 'Below Normal';
      hrColor = AppTheme.accentBlue;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HR ANALYSIS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textMuted,
                  letterSpacing: 2.0,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.circle, color: hrColor, size: 10),
              const SizedBox(width: 8),
              Text(
                hrLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: hrColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatRow('Resting HR', '${hr.restingHeartRate} BPM'),
          _buildStatRow('24h Min', '${hr.minHeartRate} BPM'),
          _buildStatRow('24h Max', '${hr.maxHeartRate} BPM'),
          _buildStatRow('Data Points', '${hr.dataPointCount} readings'),
          if (_spo2 != null)
            _buildStatRow('Blood Oxygen', '$_spo2% SpO₂'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPcosBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0A20), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentPink.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accentPink.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.female, color: AppTheme.accentPink, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PCOS Tracking',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.accentPink,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'Secondary tracking module — included in the symptom questionnaire.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              color: AppTheme.textMuted, size: 14),
        ],
      ),
    );
  }
}
