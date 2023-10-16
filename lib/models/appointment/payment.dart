class Payment {
  late int id;
  late String status;
  late double amount;
  late String method;
  late String? pollUrl;
  late String? redirectUrl;

  Payment.fromJson(data) {
    if (data.containsKey('paymentId')) id = data['paymentId'];
    if (data.containsKey('status')) status = data['status'];
    if (data.containsKey('amount'))
      amount = double.parse(data['amount'].toString());
    if (data.containsKey('method')) method = data['method'];
    if (data.containsKey('pollUrl')) pollUrl = data['pollUrl'];
    if (data.containsKey('redirectUrl')) redirectUrl = data['redirectUrl'];
  }
}
