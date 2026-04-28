// Lead Developer: Sayantani Neminath Gidde
// Team: Innovator Techies
// Architecture Tier: 3 (Doctor's Unified Clinical Portal)

import 'package:flutter/material.dart';

// ============================================================================
// --- DOCTOR DASHBOARD (CLINICAL NAVY BLUE THEME) ---
// ============================================================================
class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text('Clinical Triage Engine 🩺', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- DOCTOR HEADER ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(15), 
              border: Border.all(color: Colors.blue.shade200, width: 2),
              boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10)]
            ),
            child: Row(
              children: [
                CircleAvatar(radius: 35, backgroundColor: Colors.blue.shade50, child: Icon(Icons.medical_services, color: Colors.blue.shade900, size: 40)),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dr. Smith • Chief Medical Officer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      SizedBox(height: 4),
                      Text('District Hospital (Pune)', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('System Status: 2 Critical Alerts Active', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text('Unified Patient Roster (AI Triage) 🚨', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 12),

          // --- PATIENT 1 (URBAN FUNNEL) ---
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.redAccent, width: 2)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(backgroundColor: Colors.redAccent, radius: 25, child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30)),
              title: const Text('Sayantani Neminath Gidde', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text('🔴 HIGH RISK: PCOS / Anemia Alert', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.smartphone, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Source: Direct App Sync (Urban)', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientDetailScreen())); },
            ),
          ),
          
          // --- PATIENT 2 (RURAL ASHA FUNNEL) ---
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.redAccent, width: 2)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(backgroundColor: Colors.red.shade900, radius: 25, child: const Icon(Icons.pregnant_woman, color: Colors.white, size: 30)),
              title: const Text('Sunita Devi (Age: 26)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const Text('🔴 SEVERE: Pregnant Hb 8.5', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.support_agent, size: 14, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text('Source: ASHA Referral (Ward 4)', style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
              onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening ASHA Referral File...'))); },
            ),
          ),

          // --- PATIENT 3 (NORMAL/STABLE) ---
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(backgroundColor: Colors.green.shade400, radius: 25, child: const Icon(Icons.check, color: Colors.white, size: 30)),
              title: const Text('Emily Chen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: const Text('🟢 NORMAL: Vitals Stable\nLast Check: 4 hrs ago'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Routine File...'))); },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// --- DOCTOR'S DETAILED PATIENT VIEW ---
// ============================================================================
class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Patient File: WHB-9021'), 
        backgroundColor: Colors.blue.shade900, 
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- PATIENT HEADER ---
            Row(
              children: [
                CircleAvatar(radius: 40, backgroundColor: Colors.blue.shade100, child: Icon(Icons.person, size: 50, color: Colors.blue.shade900)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sayantani Neminath Gidde', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const Text('Age: 20 • Blood Type: A+', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.teal)),
                        child: const Text('Data Source: Urban Patient App', style: TextStyle(fontSize: 12, color: Colors.teal, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- AI DIAGNOSTIC REPORT ---
            const Text('AI Diagnostic Flags 🚨', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.shade200, width: 2)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fact_check, color: Colors.red),
                      SizedBox(width: 8),
                      Text('PCOS Test: HIGH RISK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Algorithm triggered by combination of synced Calendar irregularity and self-reported symptoms.'),
                  Divider(height: 24),
                  Row(
                    children: [
                      Icon(Icons.bloodtype, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Anemia Monitor: MODERATE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Hb level (11.5) borderline. High resting heart rate detected via Smartwatch telemetry.'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- RAW TELEMETRY DATA ---
            const Text('Raw Telemetry (Last 24h) 📊', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(leading: Icon(Icons.monitor_heart, color: Colors.pink.shade400, size: 32), title: const Text('Resting Heart Rate'), trailing: const Text('105 BPM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  const Divider(height: 1),
                  ListTile(leading: Icon(Icons.bloodtype, color: Colors.red.shade400, size: 32), title: const Text('Estimated Hemoglobin'), trailing: const Text('11.5 g/dL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  const Divider(height: 1),
                  ListTile(leading: Icon(Icons.water_drop, color: Colors.red.shade900, size: 32), title: const Text('Cycle Status'), trailing: const Text('Heavy Flow Logged', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- CLINICAL ACTION BUTTONS ---
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), backgroundColor: Colors.blue.shade50, foregroundColor: Colors.blue.shade900, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    icon: const Icon(Icons.message), label: const Text('Message Patient', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening secure chat portal...'))); },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), backgroundColor: Colors.blue.shade900, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    icon: const Icon(Icons.medical_information), label: const Text('Prescribe E-Rx', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening pharmacy routing system...'))); },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}