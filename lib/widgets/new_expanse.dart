import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/annotations.dart';

class NewExpanse extends StatefulWidget {
  const NewExpanse({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpanse> createState() {
    return _NewExpanseState();
  }
}
final List<String> cities1 = [
    "New York",
    "Los Angeles",
    "Chicago",
    "Houston",
    "Miami",
    "San Francisco",
    "Seattle",
    "Boston",
    "Atlanta",
  ];

  final List<String> cities2 = [
    "New York",
    "Los Angeles",
    "Chicago",
    "Houston",
    "Miami",
    "San Francisco",
    "Seattle",
    "Boston",
    "Atlanta",
  ];
  String ?selectedCity;
  String ?selectedCity2;
class _NewExpanseState extends State<NewExpanse> {
  //var _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  final _titleController = TextEditingController();
  final _amountcontroller = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.$01;

  void _pickdate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final pickedDate = await showDatePicker(
      //can use await in future value widget
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime(now.year+1, now.month, now.day),
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpense() {
    final enteredAmount = double.tryParse(_amountcontroller.text);
    //double.tryParse->it will return double value if able to convert string to number else null
    //tryParse('Hello') => null

    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    //.trim will temove excess white space at the beginning or end
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, date and category was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okey'),
            )
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Column(children: [
        Row(
          children: [
            DropdownButton<String>(
              value: selectedCity, // Initially selected city.
              onChanged: (String ?newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
              items: cities1.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            DropdownButton<String>(
              value: selectedCity2, // Initially selected city.
              onChanged: (String ?newValue2) {
                setState(() {
                  selectedCity2 = newValue2;
                });
              },
              items: cities2.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                //Textfield->will display text input element
                controller: _amountcontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  label: Text('Amount'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Not Selected Yet'
                        : formatter.format(
                            _selectedDate!), //!->force dart to assume that selecteddate can't be null
                  ),
                  IconButton(
                    onPressed: _pickdate,
                    icon: const Icon(
                      Icons.calendar_month,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            DropdownButton(
              value: _selectedCategory,
              items: Category.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _submitExpense,
              child: const Text('Save Ticket'),
            ),
          ],
        )
      ]),
    );
  }
}
