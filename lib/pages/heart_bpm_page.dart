import 'package:flutter/material.dart';

class HeartBPMPage extends StatefulWidget {
  const HeartBPMPage({super.key});

  @override
  _HeartBPMPageState createState() => _HeartBPMPageState();
}

class _HeartBPMPageState extends State<HeartBPMPage> {
  int age = 30;
  int hrMax = 190; // Will calculate dynamically
  int tapCount = 0;
  List<int> bpmList = [];
  int averageBPM = 0;
  int lastBPM = 0; // To store the last instantaneous BPM

  void calculateHRMax() {
    setState(() {
      hrMax = 220 - age;
    });
  }

  void addHeartbeat() {
    setState(() {
      tapCount++;
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      if (bpmList.isNotEmpty) {
        int timeDiff = currentTime - bpmList.last;
        int bpm =
            60000 ~/ timeDiff; // Beats per minute based on time between taps
        lastBPM = bpm; // Store the last BPM value
        bpmList.add(currentTime);
        if (bpmList.length > 10) bpmList.removeAt(0); // Limit to last 10 taps
        averageBPM = bpmList.length > 1
            ? (bpmList.length * 60000 ~/ (currentTime - bpmList.first)).round()
            : 0;
      } else {
        bpmList.add(currentTime);
        averageBPM = 0;
        lastBPM = 0;
      }
    });
  }

  void resetBPM() {
    setState(() {
      tapCount = 0;
      bpmList.clear();
      averageBPM = 0;
      lastBPM = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heart BPM Monitor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Age'),
                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        age = int.tryParse(value) ?? 30;
                        calculateHRMax();
                      });
                    },
                    decoration: const InputDecoration(hintText: '30'),
                  ),
                ),
                const SizedBox(width: 20),
                const Text('HRMax'),
                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  child: Text('$hrMax', style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: addHeartbeat,
              child: const Icon(Icons.favorite, size: 100, color: Colors.red),
            ),
            const SizedBox(height: 20),
            const Text('Your average BPM is'),
            Container(
              width: 100,
              height: 50,
              color: Colors.blue,
              child: Center(
                  child: Text('$averageBPM',
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white))),
            ),
            const SizedBox(height: 10),
            const Text('Last BPM'),
            Container(
              width: 100,
              height: 50,
              color: Colors.green,
              child: Center(
                  child: Text('$lastBPM',
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetBPM,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
