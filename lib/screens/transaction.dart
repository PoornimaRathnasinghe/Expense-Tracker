import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:expense_tracker/models/transaction_model.dart';
import '/services/firebase_service.dart'; // Replace with your Firebase service import
import 'package:rxdart/rxdart.dart';

class TransactionsPage extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();
  final bool isDarkMode;

  TransactionsPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // This will pop the current screen off the stack
          },
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
      ),
      body: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<TransactionModel>>(
          stream: _getAllTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: \${snapshot.error}', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)));
            } else if (snapshot.hasData) {
              final transactions = snapshot.data ?? [];
              if (transactions.isEmpty) {
                return Center(child: Text('No transactions found', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)));
              }
              // Separate transactions into Income and Expense
              final incomeTransactions = transactions.where((t) => t.isIncome).toList();
              final expenseTransactions = transactions.where((t) => !t.isIncome).toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(title: 'Income Transactions', isDarkMode: isDarkMode),
                    const SizedBox(height: 10),
                    _buildTransactionList(incomeTransactions, isIncome: true),
                    const SizedBox(height: 20),
                    SectionTitle(title: 'Expense Transactions', isDarkMode: isDarkMode),
                    const SizedBox(height: 10),
                    _buildTransactionList(expenseTransactions, isIncome: false),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Unexpected error', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)));
            }
          },
        ),
      ),
    );
  }

  // Get all transactions from FirebaseService
  Stream<List<TransactionModel>> _getAllTransactions() {
    return Rx.combineLatest2<List<TransactionModel>, List<TransactionModel>, List<TransactionModel>>(
      firebaseService.getIncomeTransactions(),
      firebaseService.getExpenseTransactions(),
      (incomeTransactions, expenseTransactions) {
        // Combine both lists and sort by date (latest first)
        return [...incomeTransactions, ...expenseTransactions]
          ..sort((a, b) => b.date.compareTo(a.date));
      },
    );
  }

  // Build a list of transactions
  Widget _buildTransactionList(List<TransactionModel> transactions, {required bool isIncome}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Prevent scroll conflict
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return _buildTransactionCard(transactions[index], isIncome: isIncome);
      },
    );
  }

  // Build a card for a single transaction
  Widget _buildTransactionCard(TransactionModel transaction, {required bool isIncome}) {
    String formattedDate = DateFormat('yMMMd').format(transaction.date);
    String formattedTime = '${transaction.time.hour.toString().padLeft(2, '0')}:${transaction.time.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          transaction.category,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
        ),
        subtitle: Text(
          '$formattedDate at $formattedTime\n${transaction.description}',
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        trailing: Text(
          'Rs.\${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}

// A reusable section title widget
class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const SectionTitle({super.key, required this.title, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
