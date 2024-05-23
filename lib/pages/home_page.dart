import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:DumendenNav/pages/navigation_page.dart';
import 'package:DumendenNav/pages/navigation_page_2.dart';
import 'package:DumendenNav/pages/places.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import "package:DumendenNav/utils/constants.dart";
import "package:http/http.dart" as http;
import "dart:convert";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();

  var text = "Konuşmak için basılı tutun";
  bool isListening = false;
  final _myBox = Hive.box('box');

  Future<void> getPlaceDetails(placeId) async {
    try {
      final detailUrl = "$DETAIL_URL?placeid=$placeId&key=$PLACE_API_KEY";

      final detailResponse = await http.get(Uri.parse(detailUrl));

      if (detailResponse.statusCode == 200) {
        Map<String, dynamic> detailJsonData = json.decode(detailResponse.body);
        Map<String, dynamic> location =
            detailJsonData['result']['geometry']['location'];
        _myBox.put('lat', location['lat']);
        _myBox.put('lng', location['lng']);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage2(),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> findPlace() async {
    final url =
        "$BASE_URL?input=${text}&inputtype=textquery&key=$PLACE_API_KEY";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        duration: Duration(milliseconds: 2000),
        glowColor: Color.fromARGB(255, 0, 128, 255),
        repeat: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
            findPlace();
          },
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 0, 128, 255),
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.black87,
              size: 35,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: EdgeInsets.only(bottom: 150),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 24,
                color: isListening ? Colors.black87 : Colors.black54,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
