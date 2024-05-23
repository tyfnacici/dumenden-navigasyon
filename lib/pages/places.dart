import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:DumendenNav/components/text_from_field.dart';
import 'package:DumendenNav/controller/google_search_controller.dart';
class Places extends StatelessWidget {
  Places({super.key});

  final GoogleSearchController searchController =
      Get.put(GoogleSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arama sonuçları"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(child: Text("Google complete address example")),
              SizedBox(
                height: 40,
              ),
              textFromField(
                controller: searchController.addressSearch,
                onChanged: (String value) {
                  searchController.selectedAddress1.value = value;
                  debugPrint(value.toString());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
