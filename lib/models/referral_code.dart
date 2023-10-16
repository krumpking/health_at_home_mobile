class ReferralCode {
  late int id;
  late String code;
  late bool isUsed;
  late bool selfRedeemed;

  ReferralCode.fromJson(data) {
    id = data['id'];
    code = data['code'];
    isUsed = data['isUsed'] == 1 ? true : false;
    selfRedeemed = data['selfRedeemed'] == 1 ? true : false;
  }
}
