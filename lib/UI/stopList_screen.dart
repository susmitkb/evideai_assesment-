// views/stop_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamevideai/UI/widgets/searchBar.dart';
import 'package:teamevideai/UI/widgets/stopsCard.dart';
import 'package:teamevideai/controllers/busStop_controllers.dart';
import 'package:teamevideai/controllers/favourites_controller.dart';

class StopListScreen extends StatelessWidget {
  final BusStopController busStopController = Get.find();
  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Stops'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Navigate to favorites screen if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(),
          Expanded(
            child: Obx(() {
              if (busStopController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (busStopController.filteredStops.isEmpty) {
                return Center(child: Text('No bus stops found'));
              } else {
                return ListView.builder(
                  itemCount: busStopController.filteredStops.length,
                  itemBuilder: (context, index) {
                    final stop = busStopController.filteredStops[index];
                    return StopCard(stop: stop);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}