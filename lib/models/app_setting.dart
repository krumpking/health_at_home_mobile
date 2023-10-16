class AppSetting {
  late double shareDiscount;

  AppSetting.fromJson(data) {
    shareDiscount = double.parse(data['shareDiscount']);
  }
}
