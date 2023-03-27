import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mcdapp/main.dart';


void main() {
  testWidgets('Order Schedule App integration test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Ensure the app title is correct
    expect(find.text('Food Order List'), findsOneWidget);

    // Add an order
    final foodName = 'Pizza';
    final orderTime = DateTime.now().add(Duration(hours: 1));
    final orderType = OrderType.normal;
    await _addOrder(tester, foodName, orderTime, orderType);

    // Ensure the order is added to the list
    expect(find.text(foodName), findsOneWidget);
    expect(find.text(DateFormat('MMM dd, yyyy hh:mm a').format(orderTime)), findsOneWidget);
    expect(find.text(orderType.toString()), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);

    // Complete the order
    await _completeOrder(tester);

    // Ensure the order is marked as completed
    expect(find.text('Completed'), findsOneWidget);
  });
}

Future<void> _addOrder(WidgetTester tester, String foodName, DateTime orderTime, OrderType orderType) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextFormField), foodName);
  await tester.tap(find.byType(TextFormField));
  await tester.pumpAndSettle();

  await tester.tap(find.byType(DateTimeField));
  await tester.pumpAndSettle();

  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();

  await tester.tap(find.text(orderType.toString()));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

Future<void> _completeOrder(WidgetTester tester) async {
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
}