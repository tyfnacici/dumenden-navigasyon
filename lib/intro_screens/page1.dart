import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Center(
            child: Text("Dümenden Navigasyon Uygulamasına Hoşgeldin!",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade900),
                textAlign: TextAlign.center)),
      ),
    );
  }
}
