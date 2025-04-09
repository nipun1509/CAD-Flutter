import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:animations/animations.dart';
import 'package:lottie/lottie.dart';
import 'splash_screen.dart'; // Already importing SplashScreen

void main() {
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
      home: const SplashScreen(), // Use SplashScreen as the entry point
    );
  }
}

// Rest of your main.dart code (CoronaryDetectionScreen, DashboardScreen, etc.) remains unchanged

// Screen for coronary artery detection
class CoronaryDetectionScreen extends StatefulWidget {
  const CoronaryDetectionScreen({super.key});

  @override
  _CoronaryDetectionScreenState createState() =>
      _CoronaryDetectionScreenState();
}

// State class for CoronaryDetectionScreen
class _CoronaryDetectionScreenState extends State<CoronaryDetectionScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false; // Loading state
  File? _file; // Selected file
  String _result = ""; // Result from the API
  late AnimationController _controller; // Animation controller
  late Animation<Color?> _colorAnimation; // Color animation

  @override
  void initState() {
    super.initState();
    // Initialize animation controller and color animation
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
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  // Function to pick a file using FilePicker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      String? filePath = result.files.single.path;

      // Check if the file is of type .nii.gz
      if (filePath != null && filePath.endsWith(".nii.gz")) {
        setState(() {
          _file = File(filePath);
        });
      } else {
        // Show error if the file type is incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a .nii.gz file only!")),
        );
      }
    }
  }

  // Function to upload the selected file to the server
  Future<void> _uploadFile() async {
    if (_file == null) return;

    setState(() {
      isLoading = true; // Start loading
    });

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://your-ec2-ip:5000/predict"), // API endpoint
    );

    request.files.add(await http.MultipartFile.fromPath('file', _file!.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(await response.stream.bytesToString());
      setState(() {
        _result = jsonResponse["segmentation_mask"].toString(); // Set result
      });

      // Show success animation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Lottie.asset(
                'assets/success.json',
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Text("File uploaded successfully!"),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Update the dashboard state with the new scan and report
      DashboardState? dashboardState = DashboardScreen.of(context);
      if (dashboardState != null) {
        dashboardState.incrementTotalScans();
        dashboardState.addReportHistory(_result);
      }
    } else {
      setState(() {
        _result = "Error: ${response.statusCode}"; // Set error message
      });

      // Show error animation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Lottie.asset(
                'assets/error.json',
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Text("File upload failed. Please try again."),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false; // Stop loading
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
              "Coronary Artery Detection",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                "Upload your cardiac imaging for instant analysis.",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedBuilder: (context, action) => GestureDetector(
                  onTap: () async {
                    await _pickFile();
                    if (_file != null) {
                      await _uploadFile();
                    }
                    action();
                  },
                  child: uploadCard(context),
                ),
                openBuilder: (context, action) => const AnalysisScreen(),
              ),
              const SizedBox(height: 20),
              _file == null
                  ? const Text("No file selected")
                  : Text("Selected file: ${_file!.path}"),
              if (isLoading)
                Lottie.asset(
                  'assets/loading.json',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              if (_result.isNotEmpty)
                Text(
                  "Result: $_result",
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for the upload card with animation
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
                  if (isLoading)
                    Lottie.asset(
                      'assets/loading.json',
                      height: 100,
                      fit: BoxFit.contain,
                    )
                  else
                    Lottie.asset(
                      'assets/upload.json',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    "Tap to Upload",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

// Screen to display analysis results
class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Analysis Results"),
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
                        "🟡 Detection Result",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Potential coronary artery stenosis detected in LAD (Left Anterior Descending) artery with 70% occlusion.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 5),
                          Text("Image quality: Excellent"),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 5),
                          Text("Analysis confidence: 94%"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Download Detailed Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dashboard screen to show overall statistics
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardState createState() => DashboardState();

  // Method to access the DashboardState from other widgets
  static DashboardState? of(BuildContext context) {
    return context.findAncestorStateOfType<DashboardState>();
  }
}

// State class for DashboardScreen
class DashboardState extends State<DashboardScreen> {
  int totalScans = 0; // Total number of scans
  List<String> reportHistory = []; // List to store report history

  // Method to increment total scans
  void incrementTotalScans() {
    setState(() {
      totalScans++;
    });
  }

  // Method to add a new report to the history
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
              "Coronary Artery Detection",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dashboard",
              style: TextStyle(
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
                      // Navigate to ReportHistoryScreen with a custom transition
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ReportHistoryScreen(
                            reportHistory: reportHistory,
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to CoronaryDetectionScreen with a custom transition
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

// Widget for a dashboard card
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
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
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

// Screen to display the report history
class ReportHistoryScreen extends StatelessWidget {
  final List<String> reportHistory;

  const ReportHistoryScreen({super.key, required this.reportHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report History"),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: reportHistory.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text("Report ${index + 1}"),
              subtitle: Text(reportHistory[index]),
            ),
          );
        },
      ),
    );
  }
}
