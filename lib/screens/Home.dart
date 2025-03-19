import 'package:flutter/material.dart';
import '/services/firebase_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart'; // Add this for date formatting
import 'package:expense_tracker/models/transaction_model.dart';
import 'transaction.dart'; // Import your TransactionPage

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

class HomePage extends StatelessWidget {
  final bool isDarkMode;

  HomePage({super.key, required this.isDarkMode});

  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: 'Total Balance', isDarkMode: isDarkMode),
              const SizedBox(height: 10),
              _buildBalanceCard(),
              const SizedBox(height: 30),
              SectionTitle(title: 'Recent Transactions', isDarkMode: isDarkMode),
              const SizedBox(height: 10),
              _buildRecentTransactions(),
              const SizedBox(height: 10),
              // Add the link here
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => TransactionsPage(
                      isDarkMode: isDarkMode, // Add the missing parameter
                    )),
                  );
                },
                child: Text(
                  "See all transactions",
                  style: TextStyle(
                    color: isDarkMode ? Colors.tealAccent : Colors.teal,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the card for displaying balance
  Widget _buildBalanceCard() {
    return StreamBuilder<double>(
      stream: _getBalanceStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingCard();
        } else if (snapshot.hasError) {
          return _errorCard(snapshot.error.toString());
        } else if (snapshot.hasData) {
          double totalBalance = snapshot.data ?? 0.0;
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rs.${totalBalance.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: isDarkMode ? Colors.tealAccent.withOpacity(0.2) : Colors.teal.withOpacity(0.2),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: isDarkMode ? Colors.tealAccent : Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return _errorCard("Unexpected error");
        }
      },
    );
  }

  // Rest of the code remains the same...
  // Stream to get the balance
  Stream<double> _getBalanceStream() {
    return Rx.combineLatest2(
      firebaseService.getIncomeStream(),
      firebaseService.getExpenseStream(),
          (double income, double expenses) => income - expenses,
    );
  }

  // Card for loading state
  Widget _loadingCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Loading...",
          style: TextStyle(
            fontSize: 32,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Card for error state
  Widget _errorCard(String message) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Error: $message",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  // Build the list of recent transactions
  Widget _buildRecentTransactions() {
    return StreamBuilder<List<TransactionModel>>(
      stream: Rx.combineLatest2(
        firebaseService.getIncomeTransactions(),
        firebaseService.getExpenseTransactions(),
            (List<TransactionModel> incomes, List<TransactionModel> expenses) =>
        [...incomes, ...expenses]..sort((a, b) {
          // Combine date and time for both transactions
          DateTime aDateTime = DateTime(a.date.year, a.date.month, a.date.day, a.time.hour, a.time.minute);
          DateTime bDateTime = DateTime(b.date.year, b.date.month, b.date.day, b.time.hour, b.time.minute);

          // Compare both date and time
          return bDateTime.compareTo(aDateTime);  // b first for descending order
        }),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingCard();
        } else if (snapshot.hasError) {
          return _errorCard(snapshot.error.toString());
        } else if (snapshot.hasData) {
          var transactions = snapshot.data ?? [];
          // Take only the latest 5 transactions
          transactions = transactions.take(5).toList();

          if (transactions.isEmpty) {
            return _errorCard("No recent transactions found");
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Prevent scroll conflict with parent
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction = transactions[index];
              return _buildTransactionCard(transaction);
            },
          );
        } else {
          return _errorCard("No transactions found");
        }
      },
    );
  }

  // Build a card for each individual transaction
  Widget _buildTransactionCard(TransactionModel transaction) {
    IconData icon = Icons.money_off; // Default icon for other categories

    // Choose an icon based on the category
    switch (transaction.category) {
      case 'Food':
        icon = Icons.food_bank;
        break;
      case 'Transport':
        icon = Icons.directions_car;
        break;
      case 'Entertainment':
        icon = Icons.movie_creation;
        break;
    // Add more cases as needed
    }

    // Format the date and time
    String formattedDate = DateFormat.yMMMd().format(transaction.date);
    String formattedTime = '${transaction.time.hour.toString().padLeft(2, '0')}:${transaction.time.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '$formattedDate at $formattedTime',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "Rs.${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: transaction.isIncome
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}