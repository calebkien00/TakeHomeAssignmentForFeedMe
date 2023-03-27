import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

enum OrderStatus {
  pending,
  completed,
}

enum OrderType {
  normal,
  vip,
}

class Order {
  final int id;
  final String foodName;
  final DateTime orderTime;
  final OrderType type;
  OrderStatus status;

  Order({
    required this.id,
    required this.foodName,
    required this.orderTime,
    required this.type,
    this.status = OrderStatus.pending,
  });
}

class OrderScheduleApp extends StatefulWidget {
  @override
  _OrderScheduleAppState createState() => _OrderScheduleAppState();
}

class _OrderScheduleAppState extends State<OrderScheduleApp> {
  int _orderIdCounter = 0;
  List<Order> _orderList = [];
  List<Timer> _botList = [];

  void _addOrder(String foodName, DateTime orderTime, OrderType type) {
    setState(() {
      _orderList.insert(
        0,
        Order(
          id: _orderIdCounter++,
          foodName: foodName,
          orderTime: orderTime,
          type: type,
        ),
      );
    });
  }

  void _completeOrder(int index) {
    setState(() {
      _orderList[index].status = OrderStatus.completed;
    });
  }

  void _addBot() {
    if (_orderList.any((order) => order.status == OrderStatus.pending)) {
      _botList.add(
        Timer.periodic(Duration(seconds: 10), (timer) {
          int index = _orderList.indexWhere((order) => order.status == OrderStatus.pending);
          if (index >= 0) {
            _completeOrder(index);
          } else {
            timer.cancel();
            _botList.remove(timer);
          }
        }),
      );
    }
  }

  void _removeBot() {
    if (_botList.isNotEmpty) {
      _botList.last.cancel();
      _botList.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Order List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Food Order List'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Pending Order'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Completed Order'),
                ),
                ElevatedButton(
                  onPressed: _addBot,
                  child: Text('+ Bot'),
                ),
                ElevatedButton(
                  onPressed: _removeBot,
                  child: Text('- Bot'),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Order ID')),
                DataColumn(label: Text('Food Name')),
                DataColumn(label: Text('Order Time')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Status')),
              ],
rows: _orderList.map((order) {
  return DataRow(
    cells: [
      DataCell(Text(order.id.toString())),
      DataCell(Text(order.foodName)),
      DataCell(Text(DateFormat('MMM dd, yyyy hh:mm a').format(order.orderTime))),
      DataCell(Text(order.type.toString())),
      DataCell(
        order.status == OrderStatus.pending
            ? ElevatedButton(
                onPressed: () {
                  _completeOrder(_orderList.indexOf(order));
                },
                child: Text('Complete'),
              )
         
        : Text('Completed'),
      ),
    ],
  );
}).toList(),  //toList() method at the end, the map function returns a list of DataRow widgets
          