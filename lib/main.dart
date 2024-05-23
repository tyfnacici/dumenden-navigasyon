import 'package:flutter/material.dart';
import 'package:DumendenNav/pages/onboard.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box box;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  box = await Hive.openBox('box');
  runApp(const MyApp(homeScreen: OnboardPage()));
}

class MyApp extends StatefulWidget {
  final Widget? homeScreen;
  const MyApp({super.key, this.homeScreen});

  @override
  State<MyApp> createState() => _MyAppState();
}

// TODO sesli komut ile sesi dinledikten sonra yeni bir pencereye yönlendirilecek google places api dan aradığı yer çekilecek, iki adet kordinal (biri kendisi diğeri de gitmek istediği yer) google haritalara veya flutter_mapbox_navigation yardımı ile bir navigasyon ortamına koyulup navigasyon sistemi tamamlanacak

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: this.widget.homeScreen,
    );
  }
}
