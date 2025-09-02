// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamevideai/UI/stopList_screen.dart';
import 'package:teamevideai/controllers/busStop_controllers.dart';
import 'package:teamevideai/controllers/favourites_controller.dart';
import 'package:teamevideai/services/jsonLoader.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Stop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize services and controllers
    Get.put(JsonLoaderService()); // Register the service first
    Get.put(BusStopController()); // Then the controller
    Get.put(FavoritesController()); // And finally the favorites controller

    return StopListScreen();
  }
}