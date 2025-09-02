// views/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamevideai/controllers/busStop_controllers.dart';
import 'package:teamevideai/controllers/favourites_controller.dart';
import 'package:teamevideai/UI/widgets/stopsCard.dart';

class FavoritesScreen extends StatelessWidget {
  final BusStopController busStopController = Get.find();
  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Get only the favorite stops
    final favoriteStops = busStopController.allStops.where((stop) {
      return favoritesController.isFavorite(stop.stopname);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[600],
        title: Text('Favorite Stops'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: favoriteStops.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorite stops yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart icon on any stop to add it to favorites',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: favoriteStops.length,
        itemBuilder: (context, index) {
          final stop = favoriteStops[index];
          return StopCard(stop: stop);
        },
      ),
    );
  }
}