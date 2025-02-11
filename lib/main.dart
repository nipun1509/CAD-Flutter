import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Import FilePicker
import 'package:http/http.dart' as http;
import 'package:animations/animations.dart';
import 'package:lottie/lottie.dart';

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
      home: const DashboardScreen(),
    );
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
  File? _file;
  String _result = "";
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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // ✅ Allow all file types
    );

    if (result != null) {
      String? filePath = result.files.single.path;

      // ✅ Ensure the selected file is `.nii.gz`
      if (filePath != null && filePath.endsWith(".nii.gz")) {
        setState(() {
          _file = File(filePath);
        });
      } else {
        // Show an error if the wrong file is selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a .nii.gz file only!")),
        );
      }
    }
  }

  // ✅ Function to upload the `.nii.gz` file to AWS
  Future<void> _uploadFile() async {
    if (_file == null) return;

    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://your-ec2-ip:5000/predict"), // Replace with your EC2 IP
    );

    request.files.add(await http.MultipartFile.fromPath('file', _file!.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(await response.stream.bytesToString());
      setState(() {
        _result = jsonResponse["segmentation_mask"].toString();
      });
    } else {
      setState(() {
        _result = "Error: ${response.statusCode}";
      });
    }

    setState(() {
      isLoading = false;
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
                    await _pickFile(); // Pick the `.nii.gz` file
                    if (_file != null) {
                      await _uploadFile(); // Upload the `.nii.gz` file
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
                  'assets/loading.json', // Ensure this file exists
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
              gradient: LinearGradient(
                colors: [_colorAnimation.value!, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                    "Tap to Upload .nii.gz File",
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

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                    title: "Total Scans",
                    value: "124",
                    icon: Icons.assessment,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DashboardCard(
                    title: "Detection Accuracy",
                    value: "94%",
                    icon: Icons.verified,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Recent Reports",
                    value: "12",
                    icon: Icons.description,
                    color: Colors.orange,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CoronaryDetectionScreen(),
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
