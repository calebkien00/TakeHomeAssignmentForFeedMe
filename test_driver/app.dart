import 'package:flutter_driver/flutter_driver.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  group('Order Schedule App end-to-end test', () {
    FlutterDriver driver;

    final foodName = 'Pizza';
    final orderTime = DateTime.now().add(Duration(hours: 1));
    final orderType = 'normal';

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Add and complete order', () async {
      // Find and tap the add order button
      final addOrderButton = find.byValueKey('addOrderButton');
      await driver.waitFor(addOrderButton);
      await driver.tap(addOrderButton);

      // Enter the food name
      final foodNameField = find.byValueKey('foodNameField');
      await driver.waitFor(foodNameField);
      await driver.tap(foodNameField);
      await driver.enterText(foodName, timeout: Duration(seconds: 1));

      // Select the order time
      final orderTimeField = find.byValueKey('orderTimeField');
      await driver.waitFor(orderTimeField);
      await driver.tap(orderTimeField);

      final formattedOrderTime = DateFormat('MMM dd, yyyy hh:mm a').format(orderTime);
      final orderTimePicker = find.byValueKey(formattedOrderTime);
      await driver.waitFor(orderTimePicker);
      await driver.tap(orderTimePicker);

      // Select the order type
      final orderTypeDropdown = find.byValueKey('orderTypeDropdown');
      await driver.waitFor(orderTypeDropdown);
      await driver.tap(orderTypeDropdown);

      final orderTypeOption = find.text(orderType);
      await driver.waitFor(orderTypeOption);
      await driver.tap(orderTypeOption);

      // Save the order
      final saveOrderButton = find.byValueKey('saveOrderButton');
      await driver.waitFor(saveOrderButton);
      await driver.tap(saveOrderButton);

      // Verify the order is added to the list
      final foodNameFinder = find.text(foodName);
      await driver.waitFor(foodNameFinder);
      expect(await driver.getText(foodNameFinder), foodName);

      final orderTimeFinder = find.text(formattedOrderTime);
      await driver.waitFor(orderTimeFinder);
      expect(await driver.getText(orderTimeFinder), formattedOrderTime);

      final orderTypeFinder = find.text(orderType);
      await driver.waitFor(orderTypeFinder);
      expect(await driver.getText(orderTypeFinder), orderType);

      final orderStatusFinder = find.text('Pending');
      await driver.waitFor(orderStatusFinder);
      expect(await driver.getText(orderStatusFinder), 'Pending');

      // Complete the order
      final completeOrderButton = find.byValueKey('completeOrderButton');
      await driver.waitFor(completeOrderButton);
      await driver.tap(completeOrderButton);

      // Verify the order is marked as completed
      final completedStatusFinder = find.text('Completed');
      await driver.waitFor(completedStatusFinder);
      expect(await driver.getText(completedStatusFinder), 'Completed');
    });
  });
}
