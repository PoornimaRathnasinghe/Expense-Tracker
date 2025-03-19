import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'package:expense_tracker/models/transaction_model.dart';

class InsightsScreen extends StatefulWidget {
  final bool isDarkMode;
  
  const InsightsScreen({super.key, required this.isDarkMode});

  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }
  
  @override
  void didUpdateWidget(covariant InsightsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      setState(() {
        _isDarkMode = widget.isDarkMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: 'Monthly Insights', isDarkMode: _isDarkMode),
              const SizedBox(height: 20),

              FutureBuilder<double>(
                future: _firebaseService.getTotalExpenses(),
                builder: (context, snapshot) {
                  return _buildInsightCard(
                    'Total Expenses',
                    snapshot.hasData ? 'Rs.${snapshot.data!.toStringAsFixed(2)}' : 'Loading...',
                    icon: Icons.pie_chart,
                    color: Colors.blueAccent,
                  );
                },
              ),

              FutureBuilder<List<TransactionModel>>(
                future: _firebaseService.getHighestExpenseTransaction(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final highestExpense = snapshot.data![0];
                    return _buildInsightCard(
                      'Highest Expense',
                      'Rs.${highestExpense.amount} on ${highestExpense.category}',
                      icon: Icons.shopping_cart,
                      color: Colors.redAccent,
                    );
                  }
                  return _buildInsightCard(
                    'Highest Expense',
                    'Loading...',
                    icon: Icons.shopping_cart,
                    color: Colors.redAccent,
                  );
                },
              ),

              const SizedBox(height: 30),

              SectionTitle(title: 'Category Breakdown', isDarkMode: _isDarkMode),
              const SizedBox(height: 20),

              StreamBuilder<Map<String, double>>(
                stream: _firebaseService.getCategoryWiseExpenseStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final categoryExpenses = snapshot.data!;
                    return Column(
                      children: categoryExpenses.entries.map((entry) {
                        return _buildCategoryCard(
                          entry.key,
                          entry.value,
                          _getCategoryColor(entry.key),
                        );
                      }).toList(),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(String title, String value,
      {required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category, double amount, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(Icons.category, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                category,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              'Rs.$amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Groceries':
        return Colors.orange;
      case 'Transport':
        return Colors.blue;
      case 'Entertainment':
        return Colors.purple;
      case 'Utilities':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const SectionTitle({super.key, required this.title, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
