import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/risk_calculator.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final AnemiaRiskResult result;
  final int pcosSymptomCount;
  final Map<String, bool> symptoms;
  final Map<String, bool> pcosSymptoms;

  const ResultScreen({
    super.key,
    required this.result,
    required this.pcosSymptomCount,
    required this.symptoms,
    required this.pcosSymptoms,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _fadeController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.result.totalScore.toDouble(),
    ).animate(CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  LinearGradient get _riskGradient {
    switch (widget.result.riskLevel) {
      case RiskLevel.high:
        return AppTheme.dangerGradient;
      case RiskLevel.moderate:
        return AppTheme.warningGradient;
      case RiskLevel.borderline:
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
        );
      case RiskLevel.safe:
        return AppTheme.safeGradient;
    }
  }

  Color get _riskColor {
    switch (widget.result.riskLevel) {
      case RiskLevel.high:
        return AppTheme.accentRed;
      case RiskLevel.moderate:
        return AppTheme.accentAmber;
      case RiskLevel.borderline:
        return AppTheme.accentBlue;
      case RiskLevel.safe:
        return AppTheme.accentGreen;
    }
  }

  IconData get _riskIcon {
    switch (widget.result.riskLevel) {
      case RiskLevel.high:
        return Icons.warning_rounded;
      case RiskLevel.moderate:
        return Icons.warning_amber_rounded;
      case RiskLevel.borderline:
        return Icons.info_rounded;
      case RiskLevel.safe:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildScoreCard(),
                    const SizedBox(height: 24),
                    _buildScoreBreakdown(),
                    const SizedBox(height: 24),
                    _buildRecommendations(),
                    const SizedBox(height: 24),
                    if (widget.pcosSymptomCount > 0) _buildPcosPanel(),
                    if (widget.pcosSymptomCount > 0) const SizedBox(height: 24),
                    _buildSymptomSummary(),
                    const SizedBox(height: 24),
                    _buildDisclaimer(),
                    const SizedBox(height: 32),
                    _buildHomeButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.bgDark,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: const Icon(Icons.home_rounded,
              color: AppTheme.textPrimary, size: 18),
        ),
      ),
      title: Text(
        'Analysis Result',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _riskColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _riskColor.withOpacity(0.4)),
            ),
            child: Text(
              widget.result.title,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _riskColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _riskColor.withOpacity(0.15),
            AppTheme.bgCard,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _riskColor.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _riskColor.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(_riskIcon, color: _riskColor, size: 48),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _scoreAnimation,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) =>
                    _riskGradient.createShader(bounds),
                child: Text(
                  '${_scoreAnimation.value.round()}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 72,
                      ),
                ),
              );
            },
          ),
          Text(
            'out of 100',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMuted,
                ),
          ),
          const SizedBox(height: 8),
          // Score bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AnimatedBuilder(
              animation: _scoreAnimation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _scoreAnimation.value / 100,
                  minHeight: 8,
                  backgroundColor: AppTheme.bgDark,
                  valueColor: AlwaysStoppedAnimation<Color>(_riskColor),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.result.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SCORE BREAKDOWN',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textMuted,
                  letterSpacing: 2.0,
                ),
          ),
          const SizedBox(height: 20),
          _buildBreakdownItem(
            label: 'Resting Heart Rate',
            value: widget.result.heartRateScore,
            maxValue: 40,
            detail: '${widget.result.restingHR} BPM',
            color: AppTheme.accentRed,
            icon: Icons.favorite_rounded,
          ),
          const SizedBox(height: 14),
          _buildBreakdownItem(
            label: 'Blood Oxygen (SpO₂)',
            value: widget.result.spo2Score,
            maxValue: 20,
            detail: widget.result.spo2 != null
                ? '${widget.result.spo2}%'
                : 'No data',
            color: AppTheme.accentBlue,
            icon: Icons.water_drop_rounded,
          ),
          const SizedBox(height: 14),
          _buildBreakdownItem(
            label: 'Symptom Score',
            value: widget.result.symptomScore,
            maxValue: 40,
            detail: '${widget.symptoms.values.where((v) => v).length} symptoms',
            color: AppTheme.accentPurple,
            icon: Icons.checklist_rounded,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Container(
              height: 1,
              color: AppTheme.borderColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL RISK SCORE',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
              ),
              ShaderMask(
                shaderCallback: (bounds) =>
                    _riskGradient.createShader(bounds),
                child: Text(
                  '${widget.result.totalScore}/100',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem({
    required String label,
    required int value,
    required int maxValue,
    required String detail,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ),
            Text(
              detail,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
            ),
            const SizedBox(width: 12),
            Text(
              '$value/$maxValue',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / maxValue,
            minHeight: 6,
            backgroundColor: AppTheme.bgDark,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1628), AppTheme.bgCard],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_rounded,
                  color: AppTheme.accentBlue, size: 18),
              const SizedBox(width: 8),
              Text(
                'RECOMMENDATIONS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.accentBlue,
                      letterSpacing: 2.0,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.result.recommendations.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPcosPanel() {
    final positiveSymptoms = widget.pcosSymptoms.entries
        .where((e) => e.value)
        .map((e) => _pcosLabels[e.key] ?? e.key)
        .toList();

    String riskText;
    Color riskColor;
    if (widget.pcosSymptomCount >= 3) {
      riskText = 'Moderate PCOS Risk — consult a gynecologist';
      riskColor = AppTheme.accentAmber;
    } else if (widget.pcosSymptomCount >= 2) {
      riskText = 'Some PCOS indicators noted — monitor symptoms';
      riskColor = AppTheme.accentPink;
    } else {
      riskText = 'Low PCOS indicators';
      riskColor = AppTheme.accentGreen;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0820), AppTheme.bgCard],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentPink.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.female_rounded, color: AppTheme.accentPink, size: 18),
              const SizedBox(width: 8),
              Text(
                'PCOS SCREENING',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.accentPink,
                      letterSpacing: 2.0,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.circle, color: riskColor, size: 10),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  riskText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: riskColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          if (positiveSymptoms.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: positiveSymptoms
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPink.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppTheme.accentPink.withOpacity(0.3)),
                        ),
                        child: Text(
                          s,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.accentPink,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  static const Map<String, String> _pcosLabels = {
    'irregular_periods': 'Irregular Periods',
    'acne': 'Persistent Acne',
    'excess_hair_growth': 'Excess Hair Growth',
    'weight_gain': 'Weight Gain',
    'mood_changes': 'Mood Changes',
  };

  Widget _buildSymptomSummary() {
    final positiveSymptoms = widget.symptoms.entries
        .where((e) => e.value)
        .map((e) => _anemiaLabels[e.key] ?? e.key)
        .toList();

    if (positiveSymptoms.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REPORTED SYMPTOMS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textMuted,
                  letterSpacing: 2.0,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: positiveSymptoms
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppTheme.accentRed.withOpacity(0.3)),
                      ),
                      child: Text(
                        s,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.accentRedGlow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  static const Map<String, String> _anemiaLabels = {
    'fatigue': 'Fatigue',
    'pallor': 'Pale Skin/Nails',
    'dizziness': 'Dizziness',
    'shortness_of_breath': 'Shortness of Breath',
    'cold_extremities': 'Cold Hands & Feet',
    'headache': 'Headache',
    'palpitations': 'Palpitations',
    'brittle_nails': 'Brittle Nails',
    'hair_loss': 'Hair Loss',
    'difficulty_concentrating': 'Brain Fog',
    'pica': 'Pica Cravings',
    'heavy_periods': 'Heavy Periods',
  };

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppTheme.textMuted, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'DISCLAIMER: This app is an early-warning screening tool ONLY. '
              'It does NOT replace a clinical diagnosis. '
              'Always consult a qualified healthcare professional for any medical concerns.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppTheme.borderGlow),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.refresh_rounded, color: AppTheme.textSecondary),
        label: Text(
          'NEW ASSESSMENT',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
