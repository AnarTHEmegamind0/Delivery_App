class TransactionModel {
  final String id;
  final double amount;
  final DateTime timestamp;
  final String description;
  final String type; // 'earning' or 'withdrawal'

  TransactionModel({
    required this.id,
    required this.amount,
    required this.timestamp,
    required this.description,
    required this.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      description: json['description'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'type': type,
    };
  }
}

class EarningsModel {
  final double daily;
  final double weekly;
  final double monthly;
  final double totalBalance;
  final List<TransactionModel> transactions;

  EarningsModel({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.totalBalance,
    this.transactions = const [],
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      daily: (json['daily'] as num).toDouble(),
      weekly: (json['weekly'] as num).toDouble(),
      monthly: (json['monthly'] as num).toDouble(),
      totalBalance: (json['totalBalance'] as num).toDouble(),
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily': daily,
      'weekly': weekly,
      'monthly': monthly,
      'totalBalance': totalBalance,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }

  EarningsModel copyWith({
    double? daily,
    double? weekly,
    double? monthly,
    double? totalBalance,
    List<TransactionModel>? transactions,
  }) {
    return EarningsModel(
      daily: daily ?? this.daily,
      weekly: weekly ?? this.weekly,
      monthly: monthly ?? this.monthly,
      totalBalance: totalBalance ?? this.totalBalance,
      transactions: transactions ?? this.transactions,
    );
  }
}
