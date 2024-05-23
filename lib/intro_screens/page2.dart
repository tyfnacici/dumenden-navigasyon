import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Center(
            child: Text("Geliştiriciler:\nTayfun Açıcı",
                maxLines: 6,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade900,
                    height: 3),
                textAlign: TextAlign.center)),
      ),
    );
  }
}