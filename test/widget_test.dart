import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx_cine/core/di/injection.dart';
import 'package:mobx_cine/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App inicia com a splash', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await setupDependencies();

    await tester.pumpWidget(const CineApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    // Deixa os timers da splash terminarem
    await tester.pump(const Duration(seconds: 5));
  });
}
