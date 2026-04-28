/// Anemia Risk Score Calculator
///
/// Scoring system based on:
/// 1. Resting Heart Rate (compensatory tachycardia is key anemia indicator)
/// 2. Blood Oxygen (SpO2) if available
/// 3. Symptom Questionnaire responses
///
/// Total score → Risk Level (Safe / Borderline / Moderate Risk / High Risk)

class RiskCalculator {
  // === HR Scoring (max 40 points) ===
  static int _heartRateScore(int bpm) {
    if (bpm >= 100) return 40; // Tachycardia — strong indicator
    if (bpm >= 90) return 28;  // Elevated
    if (bpm >= 80) return 15;  // Slightly elevated
    if (bpm >= 60) return 0;   // Normal
    if (bpm < 60) return 5;    // Bradycardia — not typical for anemia
    return 0;
  }

  // === SpO2 Scoring (max 20 points) ===
  static int _spo2Score(int? spo2) {
    if (spo2 == null) return 0;
    if (spo2 < 90) return 20;
    if (spo2 < 93) return 15;
    if (spo2 < 95) return 10;
    if (spo2 < 97) return 5;
    return 0;
  }

  // === Symptom Scoring (max 40 points) ===
  // Each symptom has a weighted score
  static const Map<String, int> symptomWeights = {
    'fatigue': 8,
    'pallor': 10,       // Pale skin/nails — most specific
    'dizziness': 8,
    'shortness_of_breath': 9,
    'cold_extremities': 6,
    'headache': 5,
    'palpitations': 7,
    'brittle_nails': 5, // Koilonychia
    'hair_loss': 4,
    'difficulty_concentrating': 4,
    'pica': 8,          // Pica cravings — highly specific for iron-deficiency
    'heavy_periods': 6, // Major cause of iron-deficiency anemia in women
  };

  static int _symptomScore(Map<String, bool> symptoms) {
    int score = 0;
    for (final entry in symptoms.entries) {
      if (entry.value && symptomWeights.containsKey(entry.key)) {
        score += symptomWeights[entry.key]!;
      }
    }
    return score.clamp(0, 40);
  }

  static AnemiaRiskResult calculate({
    required int restingHR,
    int? spo2,
    required Map<String, bool> symptoms,
  }) {
    final hrScore = _heartRateScore(restingHR);
    final spo2Score = _spo2Score(spo2);
    final sympScore = _symptomScore(symptoms);
    final total = hrScore + spo2Score + sympScore;

    RiskLevel level;
    String title;
    String description;
    List<String> recommendations;

    if (total >= 65) {
      level = RiskLevel.high;
      title = 'HIGH RISK';
      description = 'Multiple strong indicators of anemia detected. '
          'Immediate medical evaluation is strongly advised.';
      recommendations = [
        'Consult a doctor immediately for a Complete Blood Count (CBC) test',
        'Do not self-medicate with iron supplements without guidance',
        'Monitor symptoms closely — seek emergency care if breathing worsens',
        'Inform your doctor about your heart rate pattern',
      ];
    } else if (total >= 45) {
      level = RiskLevel.moderate;
      title = 'MODERATE RISK';
      description = 'Several anemia indicators are present. '
          'A medical check-up is recommended within the week.';
      recommendations = [
        'Schedule a CBC blood test at your nearest clinic',
        'Increase iron-rich foods: red meat, lentils, spinach, fortified cereals',
        'Pair iron-rich foods with Vitamin C for better absorption',
        'Avoid tea/coffee immediately after meals (reduces iron absorption)',
      ];
    } else if (total >= 25) {
      level = RiskLevel.borderline;
      title = 'BORDERLINE';
      description = 'Some early indicators noted. Monitor your symptoms '
          'and maintain a balanced, iron-rich diet.';
      recommendations = [
        'Track your symptoms daily using this app',
        'Increase dietary iron intake (lentils, beans, green leafy vegetables)',
        'Ensure adequate hydration throughout the day',
        'Re-assess in 7–10 days',
      ];
    } else {
      level = RiskLevel.safe;
      title = 'LOW RISK';
      description = 'No significant anemia indicators detected. '
          'Your vitals look healthy!';
      recommendations = [
        'Continue maintaining a balanced, iron-rich diet',
        'Stay hydrated and exercise regularly',
        'Re-assess monthly or if symptoms develop',
      ];
    }

    return AnemiaRiskResult(
      totalScore: total,
      heartRateScore: hrScore,
      spo2Score: spo2Score,
      symptomScore: sympScore,
      riskLevel: level,
      title: title,
      description: description,
      recommendations: recommendations,
      restingHR: restingHR,
      spo2: spo2,
    );
  }
}

enum RiskLevel { safe, borderline, moderate, high }

class AnemiaRiskResult {
  final int totalScore;
  final int heartRateScore;
  final int spo2Score;
  final int symptomScore;
  final RiskLevel riskLevel;
  final String title;
  final String description;
  final List<String> recommendations;
  final int restingHR;
  final int? spo2;

  const AnemiaRiskResult({
    required this.totalScore,
    required this.heartRateScore,
    required this.spo2Score,
    required this.symptomScore,
    required this.riskLevel,
    required this.title,
    required this.description,
    required this.recommendations,
    required this.restingHR,
    this.spo2,
  });

  double get scorePercentage => totalScore / 100.0;

  bool get isHighRisk => riskLevel == RiskLevel.high;
  bool get isSafe => riskLevel == RiskLevel.safe;
}
