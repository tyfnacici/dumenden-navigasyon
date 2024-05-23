import 'package:flutter/material.dart';
import 'package:DumendenNav/intro_screens/page1.dart';
import 'package:DumendenNav/intro_screens/page2.dart';
import 'package:DumendenNav/intro_screens/page3.dart';
import 'package:DumendenNav/nav_menu.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  PageController _controller = PageController();

  bool onLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          children: [IntroPage1(), IntroPage2()],
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLast = (index == 1);
            });
          },
        ),
        Container(
            alignment: Alignment(0, 0.90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                !onLast
                    ? MaterialButton(
                        color: Colors.blue.shade900,
                        child:
                            Text('Atla', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _controller.jumpToPage(2);
                        })
                    : MaterialButton(
                        color: Colors.blue.shade900,
                        child:
                            Text('Geri dön', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _controller.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        }),
                SmoothPageIndicator(controller: _controller, count: 2),
                onLast
                    ? MaterialButton(
                        color: Colors.blue.shade900,
                        child: Text('Bitti',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return NavigationMenu();
                          }));
                        })
                    : MaterialButton(
                        color: Colors.blue.shade900,
                        child: Text('Sonraki',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        })
              ],
            ))
      ]),
    );
  }
}
