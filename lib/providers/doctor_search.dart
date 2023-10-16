import 'package:google_maps_flutter/google_maps_flutter.dart';

class DoctorSearch {
  List<int> serviceIds = <int>[];
  Rating rating = Rating.all;
  Gender gender = Gender.all;
  LatLng? location;
}

enum Rating { threeStarsPlus, fourStarsPlus, all }
enum Gender { male, female, other, all }
