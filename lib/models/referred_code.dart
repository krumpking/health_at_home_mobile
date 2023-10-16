class ReferredCode {
  late int id;
  late bool isUsed;

  ReferredCode.fromJson(data) {
    id = data['id'];
    isUsed = data['isUsed'] == 1 ? true : false;
  }
}
