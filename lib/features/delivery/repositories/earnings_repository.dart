import '../models/earnings_model.dart';

class EarningsRepository {
  // Mock data for now
  Future<EarningsModel> fetchEarnings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return EarningsModel(
      daily: 642000,
      weekly: 3200000,
      monthly: 12500000,
      totalBalance: 487000,
      transactions: [
        TransactionModel(
          id: '1',
          amount: 45000,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          description: 'Баянзүрх дүүрэг хүргэлт',
          type: 'earning',
        ),
        TransactionModel(
          id: '2',
          amount: 52000,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          description: 'Сухбаатар дүүрэг хүргэлт',
          type: 'earning',
        ),
        TransactionModel(
          id: '3',
          amount: -450000,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          description: 'Картруу шилжүүлэг',
          type: 'withdrawal',
        ),
      ],
    );
  }

  Future<List<TransactionModel>> fetchTransactionHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final earnings = await fetchEarnings();
    return earnings.transactions;
  }

  Future<void> requestWithdrawal(double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, would make API call
  }
}
