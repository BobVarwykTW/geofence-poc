import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class Geofencing extends StatefulWidget {
  const Geofencing({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Geofencing> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Geofencing> {
  String currentLocationTitle = 'None';
  bg.GeofenceEvent? currentEvent;

  @override
  void initState() {
    super.initState();

    // First, we initialize the event. For now we only use `onGeofence`.
    bg.BackgroundGeolocation.onGeofence((event) {
      final location = event.extras?['title'] ?? 'None';

      setState(() {
        currentLocationTitle = event.action == 'EXIT' ? 'None' : location;
        currentEvent = event;
      });
    });

    // Third, we configure the Geofencing Instance.
    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10.0,
      // Ensures background service.
      stopOnTerminate: false,
      // Ensures that the background service is continued, even after a
      // device reboot.
      startOnBoot: true,
      enableHeadless: true,
      // `debug` and `logLevel` ensure maximum debug logging during development.
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    )).then((state) {
      if (!state.enabled) {
        // Fourth, we start the BackgroundGeoLocation service.
        bg.BackgroundGeolocation.start()
            .then((value) => // First, we add the Geofences.
                bg.BackgroundGeolocation.addGeofences(_geofences));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SafeArea(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'In which Geofence am I?'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                currentLocationTitle.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 50),
              Text(
                'Geofence Status'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                currentEvent != null
                    ? currentEvent!.action.toString()
                    : 'Idle'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<bg.Geofence> get _geofences => [
        bg.Geofence(
          identifier: 'FontysR10',
          latitude: 51.451550,
          longitude: 5.481820,
          radius: 50,
          notifyOnEntry: true,
          notifyOnDwell: true,
          notifyOnExit: true,
          loiteringDelay: 25000,
          extras: <String, dynamic>{'title': 'Fontys R10'},
        ),
        bg.Geofence(
          identifier: 'FontysTQ',
          latitude: 51.450340,
          longitude: 5.452850,
          radius: 50,
          notifyOnDwell: true,
          notifyOnEntry: true,
          notifyOnExit: true,
          loiteringDelay: 25000,
          extras: <String, dynamic>{'title': 'Fontys TQ'},
        ),
      ];
}
