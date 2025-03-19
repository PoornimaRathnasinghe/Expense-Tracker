import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/firebase_service.dart';
import 'transaction.dart';

class AddTransactionPage extends StatefulWidget {
  final bool isDarkMode;
  
  const AddTransactionPage({super.key, required this.isDarkMode});
  
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _isIncome = ValueNotifier<bool>(true);
  final List<String> _expenseCategories = [
    'Groceries',
    'Transport',
    'Entertainment',
    'Utilities',
  ];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: _isIncome,
        builder: (context, isIncome, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTransactionTypeToggle(),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              isIncome ? 'Add Income' : 'Add Expense',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            _buildAmountField(),
                            if (!isIncome) _buildCategoryDropdown(),
                            _buildDateField(context),
                            _buildTimeField(context),
                            _buildDescriptionField(),
                            const SizedBox(height: 16),
                            _buildActionButtons(context, isIncome),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Row _buildTransactionTypeToggle() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _isIncome.value = true,
            icon: const Icon(Icons.attach_money),
            label: const Text('Income'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isIncome.value ? Colors.teal : Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _isIncome.value = false,
            icon: const Icon(Icons.money_off),
            label: const Text('Expense'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isIncome.value ? Colors.white : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  TextFormField _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(labelText: 'Amount'),
      keyboardType: TextInputType.number,
      validator: (value) => value!.isEmpty ? 'Enter an amount' : null,
    );
  }

  DropdownButtonFormField<String> _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Category'),
      value: _selectedCategory,
      items: _expenseCategories
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ))
          .toList(),
      onChanged: (value) => _selectedCategory = value,
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  TextFormField _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      decoration: const InputDecoration(labelText: 'Date'),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          _dateController.text = date.toIso8601String().split('T').first;
        }
      },
      readOnly: true,
    );
  }

  TextFormField _buildTimeField(BuildContext context) {
    return TextFormField(
      controller: _timeController,
      decoration: const InputDecoration(labelText: 'Time'),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          _timeController.text = time.format(context);
        }
      },
      readOnly: true,
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(labelText: 'Description'),
    );
  }

  Row _buildActionButtons(BuildContext context, bool isIncome) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => _handleSaveTransaction(context, isIncome),
          child: Text(isIncome ? 'Save Income' : 'Save Expense'),
        ),
        OutlinedButton(
          onPressed: () {
            clearFields();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void _handleSaveTransaction(BuildContext context, bool isIncome) {
    if (_formKey.currentState!.validate()) {
      try {
        final transactionId = DateTime.now().millisecondsSinceEpoch.toString();
        final date = DateTime.tryParse(_dateController.text);
        if (date == null) {
          throw Exception('Invalid date format.');
        }
        final timeParts = _timeController.text.split(':');
        if (timeParts.length != 2) {
          throw Exception('Invalid time format.');
        }
        final hour = int.tryParse(timeParts[0]);
        final minute = int.tryParse(timeParts[1].split(' ')[0]);
        if (hour == null || minute == null) {
          throw Exception('Invalid time format.');
        }

        final transaction = TransactionModel(
          id: transactionId,
          amount: double.parse(_amountController.text),
          category: isIncome ? 'Income' : _selectedCategory!,
          date: date,
          time: TimeOfDay(hour: hour, minute: minute),
          description: _descriptionController.text,
          isIncome: isIncome,
        );

        FirebaseService().addTransaction(transaction);

        clearFields();

        // Navigate to the TransactionPage after saving the transaction
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionsPage(isDarkMode: widget.isDarkMode),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving transaction:\n${error.toString()}')),
        );
      }
    }
  }

  void clearFields() {
    _amountController.clear();
    _dateController.clear();
    _timeController.clear();
    _descriptionController.clear();
    _selectedCategory = null;
    _isIncome.value = true;
  }
}