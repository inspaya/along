import 'package:geocoding/geocoding.dart';

class AddressToLocation {
  static late double lat;
  static late double lng;

  Future getAddress(String address) async {
    List<Location> locations =
        await locationFromAddress("Gronausestraat 710, Enschede");
    for (var items in locations) {
      var lat = items.latitude;
      var lng = items.longitude;
    }
  }
}
