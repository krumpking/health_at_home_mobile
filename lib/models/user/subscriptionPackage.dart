class SubscriptionPackage {
  late int id;
  late String name;
  late int visits;
  late String description;
  late double price;

  SubscriptionPackage.init();

  SubscriptionPackage.fromJson(data) {
    if (data.containsKey('id')) id = data['id'];
    if (data.containsKey('name')) name = data['name'];
    if (data.containsKey('visits')) visits = data['visits'];
    if (data.containsKey('description')) description = data['description'];
    if (data.containsKey('price'))
      price = double.parse(data['price'].toString());
  }
}
