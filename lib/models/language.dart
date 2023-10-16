class Language {
  late int id;
  late String name;

  Language.fromJson(data) {
    id = data['id'];
    name = data['name'];
  }
}
