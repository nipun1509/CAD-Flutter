import 'dart:async';
import 'package:flutter/material.dart';

class HeartBPMPage extends StatefulWidget {
  const HeartBPMPage({super.key});

  @override
  _HeartBPMPageState createState() => _HeartBPMPageState();
}

class _HeartBPMPageState extends State<HeartBPMPage>
    with SingleTickerProviderStateMixin {
  int age = 30;
  int hrMax = 190; // Will calculate dynamically
  int tapCount = 0;
  List<int> bpmList = [];
  int averageBPM = 0;
  int finalizedBPM = 0; // Stores the finalized averageBPM for lastBPM
  bool showAverageBPM = false; // Controls whether to show averageBPM
  bool isFirstSession = true; // Tracks if it's the first tapping session
  Timer? _inactivityTimer;
  bool _showGlow = false; // Controls glow effect
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    calculateHRMax();
    // Initialize heart bounce animation
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _heartAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void calculateHRMax() {
    setState(() {
      hrMax = 220 - age;
    });
  }

  void addHeartbeat() {
    setState(() {
      tapCount++;
      showAverageBPM = true; // Show averageBPM when tapping
      _showGlow = false; // Disable glow during taps
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      bpmList.add(currentTime);
      if (bpmList.length > 10) bpmList.removeAt(0); // Limit to last 10 taps
      if (bpmList.length > 1) {
        int timeDiff = currentTime - bpmList.first;
        averageBPM = (bpmList.length * 60000 ~/ timeDiff).round();
      } else {
        averageBPM = 0;
      }
    });
    // Trigger heart bounce
    _heartController.forward(from: 0.0);
    // Reset inactivity timer
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        if (averageBPM > 0) {
          finalizedBPM = averageBPM; // Move averageBPM to finalizedBPM
          _showGlow = true; // Trigger glow effect
          showAverageBPM = false; // Hide averageBPM
          isFirstSession = false; // No longer first session
          // Turn off glow after 500ms
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _showGlow = false;
              });
            }
          });
        }
      });
    });
  }

  void resetBPM() {
    setState(() {
      tapCount = 0;
      bpmList.clear();
      averageBPM = 0;
      finalizedBPM = 0;
      showAverageBPM = false;
      isFirstSession = true;
      _showGlow = false;
      _inactivityTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Heart BPM Monitor',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 2,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Age and HRMax Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            'Age',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  age = int.tryParse(value) ?? 30;
                                  calculateHRMax();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: '30',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            'HR Max',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$hrMax',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Heart Icon with Tap-Triggered Animation
              GestureDetector(
                onTap: addHeartbeat,
                child: ScaleTransition(
                  scale: _heartAnimation,
                  child: const Icon(
                    Icons.favorite,
                    size: 120,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tap the heart to measure BPM',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              // BPM Stats Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Your Average BPM',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _showGlow
                              ? [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 0),
                                  ),
                                ]
                              : [],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          showAverageBPM && averageBPM > 0
                              ? '$averageBPM'
                              : '--',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Last BPM',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isFirstSession && tapCount == 0 || finalizedBPM == 0
                            ? '--'
                            : '$finalizedBPM',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Taps: $tapCount',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Reset Button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: resetBPM,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.white,
                    ),
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
