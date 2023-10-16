class Service {
  late int id;
  late int? addOnServiceId;
  late String uuid;
  late String name;
  late double price;
  late double reviewPrice = 0;
  late bool isPrimary;
  late bool isFixed;
  late List<Service> additionalServices = <Service>[];

  Service(String uuid, int? addOnServiceId, String name, double price, double reviewPrice, bool isPrimary, bool isFixed, List<Service> additionalServices) {
    this.uuid = uuid;
    this.addOnServiceId = addOnServiceId;
    this.name = name;
    this.price = price;
    this.reviewPrice = reviewPrice;
    this.isPrimary = isPrimary;
    this.isFixed = isFixed;
    this.additionalServices = additionalServices;
  }

  Service.init() {
    id = 0;
  }

  Service.fromJson(Map data) {
    id = data['id'];
    uuid = data['uuid'];
    name = data['name'];
    price = double.parse(data['price']);
    reviewPrice = (data.containsKey('reviewPrice') && data['reviewPrice'] != null) ? double.parse(data['reviewPrice']) : 0;
    addOnServiceId = data['addOnServiceId'] != null ? data['addOnServiceId'] : null;
    isPrimary = data['isPrimary'] == 1 ? true : false;
    isFixed = data['isFixed'] == 1 ? true : false;

    if (data.containsKey('additionalServices') && data['additionalServices'] != null) {
      List<dynamic> additional = data['additionalServices'];
      additional.forEach((element) {
        additionalServices.add(Service.fromJson(element));
      });
    }
  }
}
