// views/stop_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamevideai/controllers/favourites_controller.dart';
import 'package:teamevideai/models/busStop_models.dart';

class StopDetailScreen extends StatelessWidget {
  final BusStop stop;
  final FavoritesController favoritesController = Get.find();

  StopDetailScreen({Key? key, required this.stop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stop Details'),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              favoritesController.isFavorite(stop.stopname)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              favoritesController.toggleFavorite(stop.stopname);
            },
          )),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with stop name
            Text(
              stop.stopname,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Info card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow('Latitude', stop.latitude.toStringAsFixed(6)),
                    _buildDetailRow('Longitude', stop.longitude.toStringAsFixed(6)),
                    _buildDetailRow('Time Difference', '${stop.timedifference} min'),
                    _buildDetailRow('ETA', '${_calculateETA(stop)} min'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Map placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Map View', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _calculateETA(BusStop stop) {
    // Simple ETA calculation based on timedifference
    return (stop.timedifference * 2).toString();
  }
}