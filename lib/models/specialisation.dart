class Specialisation {
  late int id;
  late String name;

  Specialisation.fromJson(data) {
    id = data['id'];
    name = data['name'];
  }
}
