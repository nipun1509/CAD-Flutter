import 'package:flutter_test/flutter_test.dart';

import 'package:learningdart/main.dart'; // Adjust this based on your project name

void main() {
  testWidgets('Coronary Detection app test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const CoronaryDetectionApp());

    // Verify that the initial screen contains the "Upload your cardiac imaging for instant analysis" text.
    expect(find.text('Upload your cardiac imaging for instant analysis.'),
        findsOneWidget);
  });
}
