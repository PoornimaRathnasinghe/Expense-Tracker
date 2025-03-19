import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class FirebaseService {
  final CollectionReference _incomeCollection =
  FirebaseFirestore.instance.collection('incomeTransactions');
  final CollectionReference _expenseCollection =
  FirebaseFirestore.instance.collection('expenseTransactions');

  Future<void> addTransaction(TransactionModel transaction) async {
    if (transaction.isIncome) {
      await _incomeCollection.doc(transaction.id).set(transaction.toMap());
    } else {
      await _expenseCollection.doc(transaction.id).set(transaction.toMap());
    }
  }

  Stream<List<TransactionModel>> getIncomeTransactions() {
    return _incomeCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) =>
            TransactionModel.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  Stream<List<TransactionModel>> getExpenseTransactions() {
    return _expenseCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) =>
            TransactionModel.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<double> getTotalIncome() async {
    double totalIncome = 0.0;
    QuerySnapshot snapshot = await _incomeCollection.get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      totalIncome += (data['amount'] ?? 0).toDouble();
    }
    return totalIncome;
  }

  Future<double> getTotalExpenses() async {
    double totalExpenses = 0.0;
    QuerySnapshot snapshot = await _expenseCollection.get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      totalExpenses += (data['amount'] ?? 0).toDouble();
    }
    return totalExpenses;
  }
  Future<List<TransactionModel>> getHighestExpenseTransaction() async {
    final snapshot = await _expenseCollection.orderBy('amount', descending: true).limit(1).get();
    return snapshot.docs.map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Stream<Map<String, double>> getCategoryWiseExpenseStream() {
    return _expenseCollection.snapshots().map((snapshot) {
      Map<String, double> categoryExpenseMap = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String category = data['category'] ?? 'Unknown';
        double amount = (data['amount'] ?? 0.0).toDouble();
        categoryExpenseMap[category] = (categoryExpenseMap[category] ?? 0) + amount;
      }
      return categoryExpenseMap;
    });
  }

  Stream<double> getIncomeStream() {
    return _incomeCollection.snapshots().map((snapshot) {
      return snapshot.docs.fold<double>(0.0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>;  // Cast to Map<String, dynamic>
        return sum + (data['amount'] ?? 0.0).toDouble();
      });
    });
  }

  Stream<double> getExpenseStream() {
    return _expenseCollection.snapshots().map((snapshot) {
      return snapshot.docs.fold<double>(0.0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>;  // Cast to Map<String, dynamic>
        return sum + (data['amount'] ?? 0.0).toDouble();
      });
    });
  }
}
