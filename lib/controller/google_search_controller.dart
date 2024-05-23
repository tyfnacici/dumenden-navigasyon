import "dart:convert";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:DumendenNav/utils/constants.dart";
import "package:http/http.dart" as http;
import "package:uuid/uuid.dart";

class GoogleSearchController extends GetxController {
  TextEditingController addressSearch = TextEditingController();

  final uuid = const Uuid();
  String sessionToken = "";

  RxBool isLoading = false.obs;
  RxString selectedAddress = ''.obs;
  RxString selectedAddress1 = ''.obs;

  @override
  void onInit() {
    addressSearch.addListener(() {
      autoCompleteApi();
    });
    super.onInit();
  }

  Future<void> getPlaceDetails(placeId) async {
    try {
      final detailUrl = "$DETAIL_URL?placeid=$placeId&key=$PLACE_API_KEY";

      final detailResponse = await http.get(Uri.parse(detailUrl));

      if (detailResponse.statusCode == 200) {
        Map<String, dynamic> detailJsonData = json.decode(detailResponse.body);
        debugPrint("asd - ${detailJsonData.toString()}");

        Map<String, dynamic> location =
            detailJsonData['result']['geometry']['location'];
        double lat = location['lat'];
        double lng = location['lng'];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> autoCompleteApi() async {
    isLoading.value = true;
    final url =
        "$BASE_URL?input=${addressSearch.text}&inputtype=textquery&key=$PLACE_API_KEY";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        isLoading.value = false;
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> candidates = jsonData['candidates'];
        Map<String, dynamic> firstCandidate = candidates[0];
        String placeId = firstCandidate['place_id'];
        getPlaceDetails(placeId);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
