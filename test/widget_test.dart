import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartfarm_iot1/views/main_screen.dart'; // <- corriger ici ton import

void main() {
  testWidgets('Navigation bar changes screens', (WidgetTester tester) async {
    // Build MainScreen and trigger a frame
    await tester.pumpWidget(const MaterialApp(
      home: MainScreen(),
    ));

    // Vérifie que le premier écran (Dashboard) est affiché
    expect(find.text('Dashboard'), findsOneWidget);

    // Tape sur l'icône "Analytics"
    await tester.tap(find.byIcon(Icons.auto_graph));
    await tester.pumpAndSettle();

    // Tape sur l'icône "Settings"
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Ici tu peux ajouter plus de vérifications selon ce qui apparaît sur ton écran Settings
  });
}
