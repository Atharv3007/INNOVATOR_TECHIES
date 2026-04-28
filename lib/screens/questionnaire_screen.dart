import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/risk_calculator.dart';
import 'result_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  final int restingHR;
  final int? spo2;

  const QuestionnaireScreen({
    super.key,
    required this.restingHR,
    this.spo2,
  });

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  late AnimationController _progressController;

  final Map<String, bool> _symptoms = {
    'fatigue': false,
    'pallor': false,
    'dizziness': false,
    'shortness_of_breath': false,
    'cold_extremities': false,
    'headache': false,
    'palpitations': false,
    'brittle_nails': false,
    'hair_loss': false,
    'difficulty_concentrating': false,
    'pica': false,
    'heavy_periods': false,
  };

  // PCOS-related
  final Map<String, bool> _pcosSymptoms = {
    'irregular_periods': false,
    'acne': false,
    'excess_hair_growth': false,
    'weight_gain': false,
    'mood_changes': false,
  };

  final List<_QuestionPage> _pages = const [
    _QuestionPage(
      title: 'Energy & Fatigue',
      subtitle: 'Select all that apply to you',
      icon: Icons.battery_alert_rounded,
      color: AppTheme.accentRed,
      questions: [
        _Question(
          key: 'fatigue',
          label: 'Persistent Fatigue',
          description: 'Feeling tired or exhausted even after adequate sleep',
          icon: Icons.bedtime_rounded,
        ),
        _Question(
          key: 'difficulty_concentrating',
          label: 'Brain Fog / Poor Focus',
          description: 'Difficulty concentrating or thinking clearly',
          icon: Icons.psychology_alt_rounded,
        ),
        _Question(
          key: 'dizziness',
          label: 'Dizziness / Lightheadedness',
          description: 'Feeling faint or unsteady, especially when standing up',
          icon: Icons.rotate_right_rounded,
        ),
      ],
    ),
    _QuestionPage(
      title: 'Physical Signs',
      subtitle: 'Observable symptoms on your body',
      icon: Icons.accessibility_new_rounded,
      color: AppTheme.accentBlue,
      questions: [
        _Question(
          key: 'pallor',
          label: 'Pale Skin / Pale Nails',
          description: 'Unusually pale complexion, nail beds, or inner eyelids',
          icon: Icons.back_hand_rounded,
        ),
        _Question(
          key: 'brittle_nails',
          label: 'Brittle or Spoon-shaped Nails',
          description: 'Nails that break easily or curve inward (Koilonychia)',
          icon: Icons.back_hand_outlined,
        ),
        _Question(
          key: 'hair_loss',
          label: 'Excessive Hair Loss',
          description: 'Noticeable hair thinning or hair falling out in clumps',
          icon: Icons.face_6_rounded,
        ),
        _Question(
          key: 'cold_extremities',
          label: 'Cold Hands & Feet',
          description: 'Persistently cold or numb hands and feet',
          icon: Icons.ac_unit_rounded,
        ),
      ],
    ),
    _QuestionPage(
      title: 'Breathing & Heart',
      subtitle: 'Cardiovascular and respiratory symptoms',
      icon: Icons.favorite_rounded,
      color: AppTheme.accentAmber,
      questions: [
        _Question(
          key: 'shortness_of_breath',
          label: 'Shortness of Breath',
          description: 'Feeling breathless during normal activities or at rest',
          icon: Icons.air_rounded,
        ),
        _Question(
          key: 'palpitations',
          label: 'Heart Palpitations',
          description: 'Noticeable racing, fluttering, or pounding heartbeat',
          icon: Icons.monitor_heart_rounded,
        ),
        _Question(
          key: 'headache',
          label: 'Frequent Headaches',
          description: 'Regular headaches that are not typical for you',
          icon: Icons.sick_rounded,
        ),
      ],
    ),
    _QuestionPage(
      title: 'Specific Indicators',
      subtitle: 'Highly specific anemia & deficiency signs',
      icon: Icons.science_rounded,
      color: AppTheme.accentGreen,
      questions: [
        _Question(
          key: 'pica',
          label: 'Pica Cravings',
          description: 'Cravings for non-food items: ice, dirt, chalk, or clay',
          icon: Icons.icecream_rounded,
        ),
        _Question(
          key: 'heavy_periods',
          label: 'Heavy Menstrual Periods',
          description: 'Unusually heavy or prolonged menstrual bleeding (if applicable)',
          icon: Icons.water_drop_rounded,
        ),
      ],
    ),
  ];

  final List<_QuestionPage> _pcosPages = const [
    _QuestionPage(
      title: 'PCOS Screening',
      subtitle: 'Polycystic Ovary Syndrome indicators',
      icon: Icons.female_rounded,
      color: AppTheme.accentPink,
      questions: [
        _Question(
          key: 'irregular_periods',
          label: 'Irregular or Absent Periods',
          description: 'Menstrual cycles that are unpredictable, infrequent, or absent',
          icon: Icons.calendar_month_rounded,
        ),
        _Question(
          key: 'acne',
          label: 'Persistent Acne',
          description: 'Acne on face, chest, or back that does not respond to treatment',
          icon: Icons.face_rounded,
        ),
        _Question(
          key: 'excess_hair_growth',
          label: 'Excess Hair Growth (Hirsutism)',
          description: 'Unwanted hair on face, chest, back, or stomach',
          icon: Icons.face_4_rounded,
        ),
        _Question(
          key: 'weight_gain',
          label: 'Unexplained Weight Gain',
          description: 'Weight gain especially around the abdomen without clear cause',
          icon: Icons.monitor_weight_rounded,
        ),
        _Question(
          key: 'mood_changes',
          label: 'Mood Changes / Anxiety',
          description: 'Increased anxiety, depression, or mood swings',
          icon: Icons.mood_bad_rounded,
        ),
      ],
    ),
  ];

  List<_QuestionPage> get _allPages => [..._pages, ..._pcosPages];
  int get _totalPages => _allPages.length;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1 / _totalPages,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _progressController.animateTo((_currentPage + 1) / _totalPages);
    } else {
      _calculateAndNavigate();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _progressController.animateTo((_currentPage + 1) / _totalPages);
    }
  }

  void _toggleSymptom(String key, bool value, bool isPcos) {
    setState(() {
      if (isPcos) {
        _pcosSymptoms[key] = value;
      } else {
        _symptoms[key] = value;
      }
    });
  }

  void _calculateAndNavigate() {
    final result = RiskCalculator.calculate(
      restingHR: widget.restingHR,
      spo2: widget.spo2,
      symptoms: _symptoms,
    );

    final pcosScore = _pcosSymptoms.values.where((v) => v).length;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ResultScreen(
          result: result,
          pcosSymptomCount: pcosScore,
          symptoms: _symptoms,
          pcosSymptoms: _pcosSymptoms,
        ),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  final page = _allPages[index];
                  final isPcos = index >= _pages.length;
                  final pageSymptoms = isPcos ? _pcosSymptoms : _symptoms;
                  return _buildQuestionPage(page, pageSymptoms, isPcos);
                },
              ),
            ),
            _buildNavButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final page = _allPages[_currentPage];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: _currentPage > 0 ? _prevPage : () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.textPrimary, size: 16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${_currentPage + 1} of $_totalPages',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                ),
                Text(
                  page.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(page.icon, color: page.color, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(_totalPages, (i) {
              final isCompleted = i < _currentPage;
              final isCurrent = i == _currentPage;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: isCurrent
                        ? AppTheme.primaryGradient
                        : isCompleted
                            ? const LinearGradient(
                                colors: [AppTheme.accentGreen, AppTheme.accentGreen],
                              )
                            : null,
                    color: (!isCurrent && !isCompleted) ? AppTheme.borderColor : null,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(
      _QuestionPage page, Map<String, bool> symptoms, bool isPcos) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            page.subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 20),
          ...page.questions.map((q) {
            final isSelected = symptoms[q.key] ?? false;
            return _buildQuestionCard(q, isSelected, page.color, isPcos);
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
      _Question q, bool isSelected, Color color, bool isPcos) {
    return GestureDetector(
      onTap: () => _toggleSymptom(q.key, !isSelected, isPcos),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.6) : AppTheme.borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 0,
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.2)
                    : AppTheme.bgDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                q.icon,
                color: isSelected ? color : AppTheme.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    q.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected ? AppTheme.primaryGradient : null,
                color: isSelected ? null : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppTheme.borderGlow,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButtons() {
    final isLast = _currentPage == _totalPages - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.borderColor, width: 0.5)),
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _prevPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppTheme.borderGlow),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: AppTheme.textSecondary),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentRed.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: Icon(
                  isLast ? Icons.analytics_rounded : Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  isLast ? 'CALCULATE RISK' : 'NEXT',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<_Question> questions;

  const _QuestionPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.questions,
  });
}

class _Question {
  final String key;
  final String label;
  final String description;
  final IconData icon;

  const _Question({
    required this.key,
    required this.label,
    required this.description,
    required this.icon,
  });
}
