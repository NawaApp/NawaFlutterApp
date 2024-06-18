// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nawa_flutter_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // بناء الـwidget وإدخاله في الـWidget tree.
    await tester.pumpWidget(const MainApp());

    // التحقق من أن هناك نص "0" في الشجرة.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // البحث عن زر الأيقونة.
    final Finder fab = find.byIcon(Icons.add);

    // الضغط على الزر.
    await tester.tap(fab);

    // إعادة بناء الـWidget tree.
    await tester.pump();

    // التحقق من أن هناك نص "1" في الشجرة بعد الضغط على الزر.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  }, skip: true);
}
