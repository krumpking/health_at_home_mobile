import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

// For storing our result
class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyAK1SfERuXGxSsYT4tWcVEyCrxLUb3VxnA';
  static final String iosKey = 'AIzaSyAK1SfERuXGxSsYT4tWcVEyCrxLUb3VxnA';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  static final String geocodeKey = 'AIzaSyCCZxzhBYYwhndfg-lif2KGJq6nEtWFu_U';

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=en&components=country:zw&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions'].map<Suggestion>((p) => Suggestion(p['place_id'], p['description'].toString().replaceAll(', Zimbabwe', ''))).toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Suggestion?> fetchAddress(String lat, String lng) async {
    final request = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$geocodeKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return Suggestion(result['results'][0]['place_id'].toString(), result['results'][0]['formatted_address'].toString());
      }
    } else {
      //
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components = result['result']['geometry']['location'];
        // build result
        final place = new Place();
        place.lat = components['lat'].toString();
        place.lng = components['lng'].toString();
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<DistanceMatrix> getDistance(LatLng start, LatLng stop) async {
    final request =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${start.latitude},${start.longitude}&destinations=${stop.latitude},${stop.longitude}&key=$apiKey';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        var matrix = DistanceMatrix();
        matrix.distance = Element.fromJson(result['rows'][0]['elements'][0]['distance']);
        matrix.time = Element.fromJson(result['rows'][0]['elements'][0]['duration']);
        return matrix;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}

class DistanceMatrix {
  late Element distance;
  late Element time;
}

class Element {
  final String text;
  final int value;

  Element.fromJson(dynamic json)
      : text = json['text'] as String,
        value = json['value'] as int;

  @override
  String toString() => 'text: $text\nvalue: $value';
}

class Place {
  late String? lat;
  late String? lng;

  @override
  String toString() {
    return 'Place(lat: $lat, lng: $lng)';
  }
}
