// Lead Developer: Sayantani Neminath Gidde
// Team: Innovator Techies
// Architecture Tier: 1 (Urban Patient / Smartphone Portal)

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; 
import 'package:health/health.dart';
// ============================================================================
// --- MAIN PATIENT DASHBOARD (TEAL THEME) ---
// ============================================================================
class PatientDashboardScreen extends StatelessWidget {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Innovator Techies 💖', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 32),
            tooltip: 'User Profile',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Personalized Greeting
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.teal.shade200, child: const Icon(Icons.person, color: Colors.white)),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello, Sayantani 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
                          Text('Your health metrics are looking good today.', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Text('Select a Module 👇', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black87)),
              const SizedBox(height: 24),

              // Module 1: Anemia
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 22), backgroundColor: Colors.red.shade50, foregroundColor: Colors.red.shade900, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.red.shade200))),
                onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const AnemiaScreen())); },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bloodtype, size: 28, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Anemia Scanner AI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Module 2: Period Tracker
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 22), backgroundColor: Colors.pink.shade50, foregroundColor: Colors.pink.shade900, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.pink.shade200))),
                onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const PeriodTrackerScreen())); },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 28, color: Colors.pink),
                    SizedBox(width: 12),
                    Text('Period Tracker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Module 3: PCOS Risk
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 22), backgroundColor: Colors.purple.shade50, foregroundColor: Colors.purple.shade900, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.purple.shade200))),
                onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const PCOSScreen())); },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fact_check, size: 28, color: Colors.purple),
                    SizedBox(width: 12),
                    Text('PCOS Risk Test', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              
              const Spacer(),
              const Text('Developed by Sayantani Neminath Gidde\nUrban Patient Tier', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// --- USER PROFILE (URBAN TIER INTEGRATION) ---
// ============================================================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController(text: "Atharv Ravikant Joshi");
  final ageController = TextEditingController(text: "20");
  final heightController = TextEditingController(text: "175");
  final weightController = TextEditingController(text: "70");
  String bloodType = 'O+';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile ⚙️'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundColor: Colors.teal.shade100, child: Icon(Icons.person, size: 60, color: Colors.teal.shade800)),
                  const SizedBox(height: 16),
                  const Text('Health Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text('Personal Medical Constants 📋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 16),
            
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.badge, color: Colors.teal))),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: TextField(controller: ageController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Age', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.calendar_today, color: Colors.teal)))),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: bloodType,
                    decoration: InputDecoration(labelText: 'Blood Type', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.water_drop, color: Colors.red)),
                    items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map((String value) { return DropdownMenuItem<String>(value: value, child: Text(value)); }).toList(),
                    onChanged: (newValue) { setState(() { bloodType = newValue!; }); },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: TextField(controller: heightController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.height, color: Colors.teal)))),
                const SizedBox(width: 16),
                Expanded(child: TextField(controller: weightController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.fitness_center, color: Colors.teal)))),
              ],
            ),
            const SizedBox(height: 32),

            // HARDWARE STRATEGY IDENTIFIER
            const Text('Hardware Integration (Urban Tier) ⌚', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.watch, color: Colors.blueGrey, size: 36),
                title: const Text('Premium Smartwatch (Noise/Apple)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Syncing via Google Fit / HealthKit API'),
                trailing: Switch(value: true, activeThumbColor: Colors.teal, onChanged: (val) {}),
              ),
            ),
            
            const SizedBox(height: 40),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Profile Data Saved Successfully!')));
                Navigator.pop(context); 
              },
              child: const Text('Save Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// --- MODULE 1: CLINICAL ANEMIA PREDICTION (RED THEME) ---
// ============================================================================
class AnemiaScreen extends StatefulWidget {
  const AnemiaScreen({super.key});
  @override
  State<AnemiaScreen> createState() => _AnemiaScreenState();
}

class _AnemiaScreenState extends State<AnemiaScreen> {
  final ageController = TextEditingController();
  final hbController = TextEditingController();
  final bpmController = TextEditingController();
  final tempController = TextEditingController();
  bool recentHeavyPeriod = false;
  bool isPregnant = false;

  void calculateRisk() {
    double hb = double.tryParse(hbController.text) ?? 0.0;
    int bpm = int.tryParse(bpmController.text) ?? 0;
    int age = int.tryParse(ageController.text) ?? 0;
    
    String riskLevel = "";
    String advice = "";
    double normalHbThreshold = isPregnant ? 11.0 : 12.0;
    double severeHbThreshold = isPregnant ? 7.0 : 8.0;

    if (hb == 0.0 || age == 0) { riskLevel = "⚠️ Invalid Input"; advice = "Please enter valid Age and Hb values."; } 
    else if (hb < severeHbThreshold) { riskLevel = "🔴 SEVERE ANEMIA RISK"; advice = "Critical low hemoglobin. See a doctor. 🚑"; } 
    else if (hb >= severeHbThreshold && hb < normalHbThreshold) {
      if (recentHeavyPeriod || bpm > 100) { riskLevel = "🟠 HIGH RISK (Symptomatic)"; advice = "Below normal Hb + high heart rate/heavy cycle indicates iron deficiency. 💊"; } 
      else { riskLevel = "🟡 MODERATE RISK"; advice = "Hb is slightly below normal ($normalHbThreshold). Monitor diet. 🥬"; }
    } else {
      if (recentHeavyPeriod && bpm > 100) { riskLevel = "🟢 LOW RISK (Watchful)"; advice = "Hb is normal, but recent blood loss and high BPM means eat iron-rich foods. 🥩"; } 
      else { riskLevel = "🟢 NORMAL"; advice = "Vitals are optimal. 💪"; }
    }

    showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text("🩺 Clinical Analysis", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        content: Text("Calculated Status:\n$riskLevel\n\nNotes:\n$advice", style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.red.shade50,
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Acknowledge ✔️", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red.shade700)))]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(title: const Text('Anemia Prediction AI 🩸'), backgroundColor: Colors.red.shade600, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Patient Vitals 📊', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            TextField(controller: ageController, keyboardType: TextInputType.number, decoration: InputDecoration(filled: true, fillColor: Colors.white, labelText: 'Age (Years)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueGrey))),
            const SizedBox(height: 16),
            TextField(controller: hbController, keyboardType: TextInputType.number, decoration: InputDecoration(filled: true, fillColor: Colors.white, labelText: 'Hemoglobin (Hb) g/dL', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.bloodtype, color: Colors.red))),
            const SizedBox(height: 16),
            TextField(controller: bpmController, keyboardType: TextInputType.number, decoration: InputDecoration(filled: true, fillColor: Colors.white, labelText: 'Heart Rate (BPM)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.monitor_heart, color: Colors.pink))),
            const SizedBox(height: 16),
            TextField(controller: tempController, keyboardType: TextInputType.number, decoration: InputDecoration(filled: true, fillColor: Colors.white, labelText: 'Body Temp (°C)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), prefixIcon: const Icon(Icons.thermostat, color: Colors.orange))),
            const SizedBox(height: 24),
            
            Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.shade200)),
              child: Column(children: [
                  SwitchListTile(title: const Text("🤰 Currently Pregnant"), value: isPregnant, activeThumbColor: Colors.purple.shade400, onChanged: (bool val) { setState(() { isPregnant = val; }); }),
                  const Divider(height: 1),
                  SwitchListTile(title: const Text("🩸 Heavy Menstrual Cycle"), value: recentHeavyPeriod, activeThumbColor: Colors.red.shade600, onChanged: (bool val) { setState(() { recentHeavyPeriod = val; }); }),
                ])),
            const SizedBox(height: 24),
            ElevatedButton(style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), backgroundColor: Colors.red.shade700, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4), onPressed: calculateRisk, child: const Text('Run Diagnostic AI 🧠✨', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// --- MODULE 2: PERIOD TRACKER (PINK THEME) ---
// ============================================================================
class PeriodTrackerScreen extends StatefulWidget {
  const PeriodTrackerScreen({super.key});
  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(title: const Text('Period Tracker 🌸', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.pink.shade400, foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(16.0), child: Column(children: [
            const Text('Log your cycle dates below 🗓️', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 15)]),
              child: Padding(padding: const EdgeInsets.all(8.0), child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1), lastDay: DateTime.utc(2030, 12, 31), focusedDay: _focusedDay, selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (sDay, fDay) { setState(() { _selectedDay = sDay; _focusedDay = fDay; }); },
                  calendarStyle: CalendarStyle(selectedDecoration: BoxDecoration(color: Colors.pink.shade500, shape: BoxShape.circle), todayDecoration: BoxDecoration(color: Colors.pink.shade200, shape: BoxShape.circle)),
                  headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                ))),
            const Spacer(),
            ElevatedButton.icon(style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32), backgroundColor: Colors.red.shade600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 4), icon: const Icon(Icons.water_drop, size: 28), label: const Text('Mark as Heavy Flow Day 💧', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (_selectedDay != null) { showDialog(context: context, builder: (context) => AlertDialog(title: const Text("Data Saved 💾", style: TextStyle(color: Colors.pink)), content: const Text("Date marked! This will sync with Anemia AI."), backgroundColor: Colors.pink.shade50, actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Got it 👍", style: TextStyle(color: Colors.pink.shade800, fontWeight: FontWeight.bold)))])); } 
                else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('👆 Please tap a date!'))); }
              }),
            const SizedBox(height: 24),
          ])),
    );
  }
}

// ============================================================================
// --- MODULE 3: PCOS RISK TEST (PURPLE THEME) ---
// ============================================================================
class PCOSScreen extends StatefulWidget {
  const PCOSScreen({super.key});
  @override
  State<PCOSScreen> createState() => _PCOSScreenState();
}

class _PCOSScreenState extends State<PCOSScreen> {
  bool hasAcneOrHair = false;
  bool hasWeightGain = false;
  bool hasDarkSkin = false;
  bool autoPulledIrregularCycles = true; 
String resultText = "Awaiting input...";
  Color alertColor = Colors.grey;
  int questionnaireScore = 0;

  void calculatePCOSRisk() {
    int riskScore = 0;
    if (autoPulledIrregularCycles) riskScore += 2;
    if (hasAcneOrHair) riskScore += 2;
    if (hasWeightGain) riskScore += 1;
    if (hasDarkSkin) riskScore += 1;

    String riskLevel = "";
    String advice = "";

    if (riskScore >= 4) { riskLevel = "🔴 HIGH RISK of PCOS"; advice = "Your combined symptoms strongly match the clinical criteria for Polycystic Ovary Syndrome."; } 
    else if (riskScore >= 2) { riskLevel = "🟡 MODERATE RISK"; advice = "You have some overlapping symptoms of hormonal imbalance. Keep monitoring your weight and cycle regularity."; } 
    else { riskLevel = "🟢 LOW RISK"; advice = "Your current symptoms do not indicate a high likelihood of PCOS. Keep up the great tracking!"; }

    showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text("📋 PCOS Analysis", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
        content: Text("Calculated Status:\n$riskLevel\n\nNotes:\n$advice", style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.purple.shade50,
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Understand", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple.shade800)))]
      ),
    );
  }

  
 // Replace with your actual form score variable
// ... your other UI code ...

 Future<void> calculateFinalResult() async {
    Health health = Health();
    
    // THE SAFETY NET STARTS HERE
    try {
      bool access = await health.requestAuthorization([HealthDataType.HEART_RATE]);

      if (access) {
        var now = DateTime.now();
        List<HealthDataPoint> watchData = await health.getHealthDataFromTypes(
          types: [HealthDataType.HEART_RATE],
          startTime: now.subtract(const Duration(hours: 3)),
          endTime: now,
        );

        if (watchData.isNotEmpty) {
          watchData.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
          int realHeartRate = (watchData.first.value as num).toInt();

          if (realHeartRate > 100 && questionnaireScore > 4) {
            setState(() {
              resultText = "High Risk! HR: $realHeartRate BPM.";
              alertColor = Colors.red;
            });
          } else {
            setState(() {
              resultText = "Normal. HR: $realHeartRate BPM.";
              alertColor = Colors.green;
            });
          }
        } else {
          setState(() {
            resultText = "No watch data. Open NoiseFit to sync.";
          });
        }
      } else {
        setState(() {
           resultText = "Permission denied by user.";
        });
      }
    } catch (error) {
      // IF IT FAILS, IT WILL PRINT THIS INSTEAD OF CRASHING
      print("CRITICAL HEALTH ERROR: $error");
      setState(() {
        resultText = "System Error: $error";
      });
    }
  }
 // <--- THIS IS YOUR LINE 422 CLOSING BRACKET




@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PCOS Risk Test 📋'), backgroundColor: Colors.purple.shade600, foregroundColor: Colors.white),
      backgroundColor: Colors.purple.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.purple.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purple.shade300, width: 2)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('🔗 Auto-Synced Health Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                  const SizedBox(height: 8),
                  const Text('✅ Age & Vitals: Synced from User Profile'),
                  const SizedBox(height: 4),
                  Text(autoPulledIrregularCycles ? '⚠️ Irregular Cycles: Detected from Calendar!' : '✅ Regular Cycles: Synced from Calendar', style: const TextStyle(fontWeight: FontWeight.bold)),
                ])),
            const SizedBox(height: 24),
            Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purple.shade200)),
              child: Column(children: [
                  SwitchListTile(title: const Text("⚖️ Unexplained Weight Gain", style: TextStyle(fontWeight: FontWeight.w600)), subtitle: const Text("Difficulty losing weight"), value: hasWeightGain, activeThumbColor: Colors.purple.shade600, onChanged: (bool val) { setState(() { hasWeightGain = val; }); }),
                  const Divider(height: 1),
                  SwitchListTile(title: const Text("✨ Excess Hair or Severe Acne", style: TextStyle(fontWeight: FontWeight.w600)), subtitle: const Text("Noticeable facial hair or breakouts"), value: hasAcneOrHair, activeThumbColor: Colors.purple.shade600, onChanged: (bool val) { setState(() { hasAcneOrHair = val; }); }),
                  const Divider(height: 1),
                  SwitchListTile(title: const Text("🟤 Darkening of Skin", style: TextStyle(fontWeight: FontWeight.w600)), subtitle: const Text("Around neck or armpits"), value: hasDarkSkin, activeThumbColor: Colors.purple.shade600, onChanged: (bool val) { setState(() { hasDarkSkin = val; }); }),
                ])),
            const SizedBox(height: 32),
            ElevatedButton(style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20), backgroundColor: Colors.purple.shade700, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4), onPressed: calculatePCOSRisk, child: const Text('Calculate PCOS Risk Profile 🔍', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  
  
  
  
  }
}