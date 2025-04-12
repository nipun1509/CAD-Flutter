import 'dart:io';
import 'package:flutter/material.dart';
import 'package:learningdart/firebase_options.dart';
import 'package:learningdart/pages/login_page.dart';
import 'package:learningdart/controllers/user_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'splash_screen.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CoronaryDetectionApp());
}

class CoronaryDetectionApp extends StatelessWidget {
  const CoronaryDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}

// Mock Report Data Model
class CACReport {
  final int index;
  final int totalLesionArea;
  final int numberOfLesionSpots;
  final int averageLesionSize;
  final int cacScore;
  final String riskLevel;
  final String recommendation;

  CACReport({
    required this.index,
    required this.totalLesionArea,
    required this.numberOfLesionSpots,
    required this.averageLesionSize,
    required this.cacScore,
    required this.riskLevel,
    required this.recommendation,
  });
}

// Mock API with 10 predefined reports
class MockCACApi {
  static final List<CACReport> _reports = [
    CACReport(
        index: 1,
        totalLesionArea: 2456,
        numberOfLesionSpots: 7,
        averageLesionSize: 351,
        cacScore: 245,
        riskLevel: "Moderate",
        recommendation: "Medical consultation advised"),
    CACReport(
        index: 2,
        totalLesionArea: 1832,
        numberOfLesionSpots: 5,
        averageLesionSize: 366,
        cacScore: 180,
        riskLevel: "Low",
        recommendation: "Monitor regularly"),
    CACReport(
        index: 3,
        totalLesionArea: 3987,
        numberOfLesionSpots: 12,
        averageLesionSize: 332,
        cacScore: 400,
        riskLevel: "High",
        recommendation: "Urgent medical attention"),
    CACReport(
        index: 4,
        totalLesionArea: 1276,
        numberOfLesionSpots: 3,
        averageLesionSize: 425,
        cacScore: 90,
        riskLevel: "Low",
        recommendation: "Routine checkup"),
    CACReport(
        index: 5,
        totalLesionArea: 2678,
        numberOfLesionSpots: 8,
        averageLesionSize: 335,
        cacScore: 300,
        riskLevel: "Moderate",
        recommendation: "Consult cardiologist"),
    CACReport(
        index: 6,
        totalLesionArea: 3421,
        numberOfLesionSpots: 10,
        averageLesionSize: 342,
        cacScore: 350,
        riskLevel: "High",
        recommendation: "Immediate consultation"),
    CACReport(
        index: 7,
        totalLesionArea: 1567,
        numberOfLesionSpots: 4,
        averageLesionSize: 392,
        cacScore: 120,
        riskLevel: "Low",
        recommendation: "Maintain healthy lifestyle"),
    CACReport(
        index: 8,
        totalLesionArea: 2890,
        numberOfLesionSpots: 9,
        averageLesionSize: 321,
        cacScore: 270,
        riskLevel: "Moderate",
        recommendation: "Medical review advised"),
    CACReport(
        index: 9,
        totalLesionArea: 2103,
        numberOfLesionSpots: 6,
        averageLesionSize: 350,
        cacScore: 200,
        riskLevel: "Moderate",
        recommendation: "Schedule follow-up"),
    CACReport(
        index: 10,
        totalLesionArea: 3750,
        numberOfLesionSpots: 11,
        averageLesionSize: 341,
        cacScore: 380,
        riskLevel: "High",
        recommendation: "Seek specialist care"),
  ];

  static CACReport getRandomReport() {
    return _reports[Random().nextInt(_reports.length)];
  }
}

class CoronaryDetectionScreen extends StatefulWidget {
  const CoronaryDetectionScreen({super.key});

  @override
  _CoronaryDetectionScreenState createState() =>
      _CoronaryDetectionScreenState();
}

class _CoronaryDetectionScreenState extends State<CoronaryDetectionScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: Colors.red[100],
      end: Colors.red[300],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _simulateUpload() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 10));
    final report = MockCACApi.getRandomReport();
    setState(() {
      isLoading = false;
    });

    DashboardState? dashboardState = DashboardScreen.of(context);
    if (dashboardState != null) {
      dashboardState.incrementTotalScans();
      dashboardState.addReportHistory(
          "CAC Score: ${report.cacScore}, Risk: ${report.riskLevel}");
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisScreen(report: report),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 8),
            Text(
              "Coronary Artery Detection",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Tap to generate a simulated CAC report.",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: isLoading ? null : _simulateUpload,
                child: uploadCard(context),
              ),
              if (isLoading)
                Lottie.asset(
                  'assets/loading.json',
                  height: 100,
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return MouseRegion(
          onEnter: (_) => setState(() {}),
          onExit: (_) => setState(() {}),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  _colorAnimation.value!,
                  Colors.white,
                  _colorAnimation.value!
                ],
                stops: const [0.0, 0.5, 1.0],
                startAngle: 0.0,
                endAngle: 2 * 3.14,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/upload.json',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Tap to Analyze",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnalysisScreen extends StatelessWidget {
  final CACReport report;

  const AnalysisScreen({super.key, required this.report});

  Future<String> _copyPdfFromAssets(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/report_${report.index}.pdf';
      final file = File(filePath);

      if (!await file.exists()) {
        final data = await DefaultAssetBundle.of(context)
            .load('assets/pdfs/report_${report.index}.pdf');
        await file.writeAsBytes(data.buffer.asUint8List());
      }
      return filePath;
    } catch (e) {
      throw Exception('Failed to copy PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Analysis Results",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'analysis',
                child: Lottie.asset(
                  'assets/analysis.json',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🧠 Coronary Artery Calcium Report",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Total Lesion Area: ${report.totalLesionArea} pixels",
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      Text(
                        "Number of Lesion Spots: ${report.numberOfLesionSpots}",
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      Text(
                        "Average Lesion Size: ${report.averageLesionSize} pixels",
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      Text(
                        "Simulated CAC Score: ${report.cacScore}",
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      Text(
                        "Risk Level: ${report.riskLevel}",
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      Text(
                        "Recommendation: ${report.recommendation}",
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final pdfPath = await _copyPdfFromAssets(context);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Report saved to $pdfPath')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Download Detailed Report",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardState createState() => DashboardState();

  static DashboardState? of(BuildContext context) {
    return context.findAncestorStateOfType<DashboardState>();
  }
}

class DashboardState extends State<DashboardScreen> {
  int totalScans = 0;
  List<String> reportHistory = [];

  void incrementTotalScans() {
    setState(() {
      totalScans++;
    });
  }

  void addReportHistory(String result) {
    setState(() {
      reportHistory.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 8),
            Text(
              "HeartVision",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await UserController.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              }
            },
          ),
        ],
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          UserController.user?.photoURL ?? '',
                        ),
                        backgroundColor: Colors.grey.shade200,
                        child: UserController.user?.photoURL == null
                            ? const Icon(Icons.person, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserController.user?.displayName ?? 'Guest',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            UserController.user?.email ?? '',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Dashboard",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: "Detection Accuracy",
                      value: "94%",
                      icon: Icons.verified,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DashboardCard(
                      title: "Pending Analysis",
                      value: "3",
                      icon: Icons.hourglass_empty,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ReportHistoryScreen(
                              reportHistory: reportHistory,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: DashboardCard(
                        title: "Recent Reports",
                        value: reportHistory.length.toString(),
                        icon: Icons.description,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DashboardCard(
                      title: "Total Scans",
                      value: totalScans.toString(),
                      icon: Icons.assessment,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const CoronaryDetectionScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportHistoryScreen extends StatelessWidget {
  final List<String> reportHistory;

  const ReportHistoryScreen({super.key, required this.reportHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report History",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: reportHistory.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                "Report ${index + 1}",
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              subtitle: Text(
                reportHistory[index],
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          );
        },
      ),
    );
  }
}
