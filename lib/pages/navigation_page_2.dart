import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NavigationPage2 extends StatefulWidget {
  const NavigationPage2({super.key});

  @override
  State<NavigationPage2> createState() => _NavigationPage2State();
}

class _NavigationPage2State extends State<NavigationPage2> {
  String? _platformVersion;
  String? _instruction;
  final _myBox = Hive.box('box');

  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;
  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.enableRefresh = true;
    _navigationOption.alternatives = true;
    _navigationOption.voiceInstructionsEnabled = true;
    _navigationOption.bannerInstructionsEnabled = true;
    _navigationOption.allowsUTurnAtWayPoints = true;
    _navigationOption.mode = MapBoxNavigationMode.walking;
    _navigationOption.units = VoiceUnits.metric;
    _navigationOption.language = "tr-TUR";
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
     var wayPoints = <WayPoint>[];

     final _origin = WayPoint(
      name: "Başlangıç",
      latitude: position.latitude,
      longitude: position.longitude,
      isSilent: true);

        final _stop1 = WayPoint(
        name: "Hedef",
        latitude: _myBox.get('lat'),
        longitude: _myBox.get('lng'),
      isSilent: true);

      wayPoints.add(_origin);
      wayPoints.add(_stop1);

      MapBoxNavigation.instance.startNavigation(
        wayPoints: wayPoints,
        options: _navigationOption
      );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: 
          Column(
              children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Container(
                color: Colors.grey,
                child: MapBoxNavigationView(
                    options: _navigationOption,
                    onRouteEvent: _onEmbeddedRouteEvent,
                    onCreated:
                        (MapBoxNavigationViewController controller) async {
                      _controller = controller;
                      controller.initialize();
                    }),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
