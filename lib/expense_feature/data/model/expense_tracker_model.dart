class ExpenseTrackerModel {
  String amount;
  String name;
  String history;
  String description;

  ExpenseTrackerModel({required this.name,
    required this.history,
    required this.amount,
    required this.description});

  factory ExpenseTrackerModel.fromJson(Map<String, dynamic> json) => ExpenseTrackerModel(
    amount: json["amount"],
    name: json["name"],
    history: json["history"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "name": name,
    "history": history,
    "description": description,
  };
}
