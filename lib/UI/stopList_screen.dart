// views/stop_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamevideai/UI/favourites_screen.dart';
import 'package:teamevideai/UI/widgets/searchBar.dart';
import 'package:teamevideai/UI/widgets/stopsCard.dart';
import 'package:teamevideai/controllers/busStop_controllers.dart';
import 'package:teamevideai/controllers/favourites_controller.dart';

class StopListScreen extends StatelessWidget {
  final BusStopController busStopController = Get.find();
  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        title: Text(
          'Bus Stops',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_rounded),
            tooltip: 'View Favorites',
            onPressed: () {
              Get.to(() => FavoritesScreen(),
                transition: Transition.cupertino,
                duration: Duration(milliseconds: 300),
              );
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar with subtle shadow
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SearchBarWidget(),
          ),

          // Status indicator
          Obx(() {
            if (busStopController.isLoading.value) {
              return _buildLoadingState();
            } else if (busStopController.errorMessage.value.isNotEmpty) {
              return _buildErrorState(busStopController.errorMessage.value);
            } else if (busStopController.filteredStops.isEmpty) {
              return _buildEmptyState();
            }
            return SizedBox.shrink();
          }),

          // Results count
          Obx(() {
            if (busStopController.filteredStops.isNotEmpty &&
                busStopController.searchQuery.value.isNotEmpty) {
              return _buildResultsCount();
            }
            return SizedBox.shrink();
          }),

          // Stops list
          Expanded(
            child: Obx(() {
              if (busStopController.filteredStops.isNotEmpty) {
                return _buildStopsList();
              }
              return SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          CircularProgressIndicator.adaptive(),
          SizedBox(height: 16),
          Text(
            'Loading bus stops...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'Unable to load stops',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.refresh_rounded),
            label: Text('Try Again'),
            onPressed: () => busStopController.loadStops(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No stops found',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or check your connection',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            '${busStopController.filteredStops.length} stops found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopsList() {
    return ListView.builder(
      itemCount: busStopController.filteredStops.length,
      itemBuilder: (context, index) {
        final stop = busStopController.filteredStops[index];
        return StopCard(stop: stop);
      },
    );
  }
}