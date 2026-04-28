// Lead Developer: Sayantani Neminath Gidde
// Team: Innovator Techies
// Architecture Tier: 4 (Government / Ministry of Health Analytics)

import 'package:flutter/material.dart';

// ============================================================================
// --- GOVERNMENT COMMAND CENTER (DARK INDIGO THEME) ---
// ============================================================================
class GovDashboardScreen extends StatelessWidget {
  const GovDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We wrap this specific screen in its own Theme so it stays Dark Mode
    // even if the rest of the app uses a light theme!
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.indigoAccent,
          surface: Colors.indigo.shade900, 
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E21), // Deep terminal black/blue
        appBar: AppBar(
          title: const Text('MINISTRY COMMAND CENTER 🌐', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white)),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 10,
          iconTheme: const IconThemeData(color: Colors.white), // Makes the back arrow white
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- LIVE KPI HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildKpiBox('Active Scans', '14.5k', Colors.cyanAccent),
                  _buildKpiBox('Critical Zones', '3', Colors.redAccent),
                  _buildKpiBox('ASHA Agents', '420', Colors.greenAccent),
                ],
              ),
              const SizedBox(height: 24),

              // --- MODULE 1: EPIDEMIOLOGICAL HEATMAP ---
              const Text('📍 Real-Time Epidemiological Radar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              Card(
                color: const Color(0xFF1D1E33),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.warning, color: Colors.redAccent, size: 36),
                        title: const Text('CRITICAL SPIKE: Ward 4 (Pune)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        subtitle: const Text('+30% increase in Severe Anemia flags in the last 48 hours. Data verified via ASHA BLE Scanners.', style: TextStyle(color: Colors.white70)),
                      ),
                      const Divider(color: Colors.white24),
                      ListTile(
                        leading: const Icon(Icons.trending_up, color: Colors.orangeAccent, size: 36),
                        title: const Text('MONITORING: Ward 12', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        subtitle: const Text('Rising cluster of irregular cycles (PCOS Risk). Data sourced from Urban Smartwatch syncs.', style: TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- MODULE 2: AI SUPPLY CHAIN ROUTING ---
              const Text('📦 Predictive Resource Allocation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              Card(
                color: const Color(0xFF1D1E33),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.indigoAccent, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.local_shipping, color: Colors.indigoAccent),
                          SizedBox(width: 8),
                          Text('AI Logistics Recommendation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigoAccent)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Based on the Ward 4 Anemia spike, the AI recommends immediate dispatch of Iron Folic Acid (IFA) supplements to prevent hospitalizations.', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Target: Ward 4 PHC', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('Qty: 500 Units IFA', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.indigoAccent, foregroundColor: Colors.white),
                          icon: const Icon(Icons.check_circle),
                          label: const Text('AUTHORIZE DISPATCH', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Dispatch Authorized and Routed to Logistics!')));
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- MODULE 3: URBAN VS RURAL DEMOGRAPHICS ---
              const Text('📊 Hardware Tier Demographics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              Card(
                color: const Color(0xFF1D1E33),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Platform Data Ingestion Sources', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 16),
                      const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Urban (Premium Smartwatches)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), Text('45%', style: TextStyle(color: Colors.cyanAccent))]),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: 0.45, backgroundColor: Colors.white12, color: Colors.cyanAccent, minHeight: 8, borderRadius: BorderRadius.circular(4)),
                      const SizedBox(height: 20),
                      const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Rural (Generic BLE Bands)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), Text('55%', style: TextStyle(color: Colors.greenAccent))]),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: 0.55, backgroundColor: Colors.white12, color: Colors.greenAccent, minHeight: 8, borderRadius: BorderRadius.circular(4)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Center(child: Text('INNOVATOR TECHIES SECURE TERMINAL', style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 2))),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the top KPI boxes
  Widget _buildKpiBox(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}