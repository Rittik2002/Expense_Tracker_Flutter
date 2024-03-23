import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { $01, $02, $03, $04 }
//enum allow us to create custom type {combination of predefined allowed value}

const categoryIcons = {
  Category.$01: Icons.bus_alert_rounded,
  Category.$02: Icons.bus_alert_rounded,
  Category.$03: Icons.bus_alert_rounded,
  Category.$04: Icons.bus_alert_rounded,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4(); //v4 will generate a unique string id

  final String id;
  final String title;
  final double amount;
  final DateTime date; //Datetime - predefined
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}
//to build unique id dynamically such that whenever new expanse is added it have unique id

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
