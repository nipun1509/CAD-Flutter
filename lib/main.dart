import 'dart:io';
import 'package:flutter/material.dart';
import 'package:learningdart/firebase_options.dart';
import 'package:learningdart/pages/login_page.dart'; // Confirmed existing
import 'package:learningdart/pages/home_page.dart'; // Confirmed existing
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'splash_screen.dart'; // Confirmed existing
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:learningdart/pages/heart_bpm_page.dart'; // Confirmed existing
import 'package:learningdart/pages/profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:learningdart/controllers/user_controller.dart';

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) =>
            const LoginPage(), // Non-const due to VideoPlayerController
        '/home': (context) => const HomePage(),
        '/heart_bpm': (context) => const HeartBPMPage(),
        '/dashboard': (context) => const DashboardScreen(), // Placeholder
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

// Mock Report Data Model (keeping for future use, though not currently needed)
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

// Mock API with 10 predefined reports (keeping for future use)
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
// Rest of your code (CoronaryDetectionScreen, AnalysisScreen, DashboardScreen, DashboardCard, ReportHistoryScreen) remains unchanged
// ... (include the rest of the file as provided earlier)

// Rest of your code (CoronaryDetectionScreen, AnalysisScreen, DashboardScreen, DashboardCard, ReportHistoryScreen) remains unchanged
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
  String? errorMessage;

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

  Future<void> _uploadAndAnalyze() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Show file picker UI (optional, no file required)
      try {
        await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.any,
        );
      } catch (e) {
        setState(() {
          errorMessage = 'File picker: ${e.toString()} (continuing)';
        });
      }

      // Simulate processing delay (5-6 seconds)
      await Future.delayed(const Duration(seconds: 5));

      // Make API call
      final response = await http.post(
        Uri.parse('https://cac-api.onrender.com/predict'),
        headers: {'Content-Type': 'multipart/form-data'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final score = data['score'] ?? 0;
        final risk = data['risk'] ?? 'Unknown';

        final report = CACReport(
          index: DateTime.now().millisecondsSinceEpoch % 1000,
          totalLesionArea: score * 10,
          numberOfLesionSpots: (score / 50).ceil(),
          averageLesionSize: score * 2,
          cacScore: score,
          riskLevel: risk.split(',').first.trim(),
          recommendation: risk.contains('consider')
              ? 'Consult a specialist'
              : 'Monitor health',
        );

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
      } else {
        setState(() {
          errorMessage = 'API error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Optional background image (uncomment if added)
          // Opacity(
          //   opacity: 0.1,
          //   child: Image.asset(
          //     'assets/background.jpg',
          //     fit: BoxFit.cover,
          //     width: double.infinity,
          //     height: double.infinity,
          //   ),
          // ),
          // Gradient fallback
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.red.withOpacity(0.1), Colors.white],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload,
                                color: Colors.red,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Coronary Artery Detection",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Tap the card below to upload and analyze a CAC scan.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedBuilder(
                            animation: _colorAnimation,
                            builder: (context, child) {
                              return GestureDetector(
                                onTap: isLoading ? null : _uploadAndAnalyze,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: SweepGradient(
                                      colors: [
                                        _colorAnimation.value!,
                                        Colors.white,
                                        _colorAnimation.value!
                                      ],
                                      stops: const [0.25, 0.5, 0.75],
                                      startAngle: -pi / 2,
                                      endAngle: 3 * pi / 2,
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
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      width: double.infinity,
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Lottie.asset(
                                            'assets/upload.json',
                                            height: 100,
                                            fit: BoxFit.contain,
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            "Tap to Upload",
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
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLoading)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/loading.json',
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Processing...",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: isLoading
                                    ? () {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.cancel,
                                    color: Colors.white),
                                label: const Text(
                                  "Cancel Upload",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey.shade200],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 40,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    errorMessage = null;
                                  });
                                  _uploadAndAnalyze();
                                },
                                icon: const Icon(Icons.refresh,
                                    color: Colors.white),
                                label: const Text(
                                  "Retry",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  // Information Card
                  if (!isLoading && errorMessage == null)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey.shade100],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "About CAC Scans",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "A Coronary Artery Calcium (CAC) scan is a non-invasive test that uses a CT scan to detect calcium deposits in the coronary arteries, indicating potential heart disease risk. Early detection can guide preventive measures.",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  const url =
                                      'https://www.mayoclinic.org/tests-procedures/heart-scan/about/pac-20384686';
                                  print("Attempting to launch URL: $url");
                                  if (await canLaunch(url)) {
                                    print("Launching URL...");
                                    await launch(url);
                                  } else {
                                    print("Failed to launch URL");
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Could not open link. Please check your internet or browser settings."),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.open_in_new,
                                    color: Colors.white),
                                label: const Text(
                                  "Learn More",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: isLoading ? null : _uploadAndAnalyze,
          child: Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  _colorAnimation.value!,
                  Colors.white,
                  _colorAnimation.value!
                ],
                stops: const [0.25, 0.5, 0.75],
                startAngle: -pi / 2,
                endAngle: 3 * pi / 2,
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
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                height: 200,
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
                      "Tap to Upload",
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

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.yellow.shade700;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Analysis Results",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 4,
      ),
      body: Stack(
        children: [
          // Optional background image (uncomment if added to assets)
          // Opacity(
          //   opacity: 0.1,
          //   child: Image.asset(
          //     'assets/background.jpg',
          //     fit: BoxFit.cover,
          //     width: double.infinity,
          //     height: double.infinity,
          //   ),
          // ),
          // Gradient fallback
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.red.withOpacity(0.1), Colors.white],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Lottie animation
                  Hero(
                    tag: 'analysis',
                    child: Lottie.asset(
                      'assets/analysis.json',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Results card
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Coronary Artery Calcium Report",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildResultRow(
                              icon: Icons.area_chart,
                              label: "Total Lesion Area",
                              value: "${report.totalLesionArea} pixels",
                            ),
                            _buildResultRow(
                              icon: Icons.bubble_chart,
                              label: "Lesion Spots",
                              value: "${report.numberOfLesionSpots}",
                            ),
                            _buildResultRow(
                              icon: Icons.show_chart,
                              label: "Avg Lesion Size",
                              value: "${report.averageLesionSize} pixels",
                            ),
                            _buildResultRow(
                              icon: Icons.score,
                              label: "CAC Score",
                              value: "${report.cacScore}",
                              isHighlighted: true,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber,
                                  color: Colors.orange,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Risk Level: ",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRiskColor(report.riskLevel),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    report.riskLevel,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildResultRow(
                              icon: Icons.recommend,
                              label: "Recommendation",
                              value: report.recommendation,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            final pdfPath = await _copyPdfFromAssets(context);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Report downloaded successfully!",
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error: $e",
                                    style:
                                        const TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text(
                          "Download Report",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await Share.share(
                              "CAC Report: Score: ${report.cacScore}, "
                              "Risk: ${report.riskLevel}, "
                              "Recommendation: ${report.recommendation}",
                              subject: "Coronary Artery Calcium Report",
                            );
                          } catch (e) {
                            print("Share error: $e");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Share failed: $e",
                                    style:
                                        const TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: const Text(
                          "Share Report",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          const url =
                              'https://www.mayoclinic.org/tests-procedures/coronary-calcium-scan/about/pac-20384686';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Could not open link",
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.info, color: Colors.white),
                        label: const Text(
                          "Learn More",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.home, color: Colors.white),
                        label: const Text(
                          "Back to Dashboard",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: isHighlighted ? Colors.red : Colors.grey.shade600,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: ",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static DashboardState? of(BuildContext context) {
    return context.findAncestorStateOfType<DashboardState>();
  }

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int totalScans = 0;
  List<String> reportHistory = [];
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

  void incrementTotalScans() {
    setState(() {
      totalScans++;
    });
  }

  void addReportHistory(String report) {
    setState(() {
      reportHistory.add(report);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Gradient background (consistent with upload and analysis pages)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.red.withOpacity(0.1), Colors.white],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Coronary Artery Dashboard",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Level 1: Total Scans (Full Box)
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Side: Title and Number
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Scans",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "$totalScans",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Right Side: View History Button
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("History feature coming soon!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "View History",
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
                const SizedBox(height: 20),
                // Level 2: Two Half Boxes (Quick Stats and Upload)
                Row(
                  children: [
                    // Quick Stats (Left Half)
                    Expanded(
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey.shade100],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          height: 200,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Quick Stats",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: CircularProgressIndicator(
                                  value: 0.75, // 75% progress
                                  strokeWidth: 8,
                                  color: Colors.red,
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "75% of scans normal",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Upload (Right Half)
                    Expanded(
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey.shade100],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          height: 200,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ready to scan?",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CoronaryDetectionScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.upload,
                                    color: Colors.white),
                                label: const Text(
                                  "Upload",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Level 3: Latest Scan (Full Box)
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Side: Title and Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Latest Scan",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                reportHistory.isNotEmpty
                                    ? reportHistory.last
                                    : "No scans yet",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        // Right Side: View Details Button
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Analysis feature coming soon!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            "View Details",
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
                const SizedBox(height: 20),
                // Notification/Tip Card
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notification_important,
                          color: Colors.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Tip: Stay hydrated before your next scan for better results.",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              // Remove the tip (can be re-added later with a timer)
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom CanvasPanel for simple chart visualization
class CanvasPanel extends StatelessWidget {
  final String code;

  const CanvasPanel({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CanvasPainter(code),
      child: Container(),
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final String code;

  _CanvasPainter(this.code);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawArc(Rect.fromCircle(center: center, radius: 40), 0,
        2 * 3.14 * 0.75, false, paint); // 75% filled circle
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
