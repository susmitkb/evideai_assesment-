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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        title: Text(
          'Favorite Stops',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Obx(() {
        final favoriteStops = busStopController.allStops.where((stop) {
          return favoritesController.isFavorite(stop.stopname);
        }).toList();

        return favoriteStops.isEmpty
            ? _buildEmptyState(theme)
            : _buildFavoritesList(favoriteStops);
      }),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'No favorite stops yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Tap the heart icon on any stop to add it to your favorites',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List favoriteStops) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: favoriteStops.length,
      itemBuilder: (context, index) {
        final stop = favoriteStops[index];
        return Dismissible(
          key: Key(stop.stopname),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          confirmDismiss: (direction) async {
            return await _showDeleteConfirmation(context, stop.stopname);
          },
          onDismissed: (direction) {
            favoritesController.toggleFavorite(stop.stopname);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed from favorites'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    favoritesController.toggleFavorite(stop.stopname);
                  },
                ),
                duration: Duration(seconds: 3),
              ),
            );
          },
          child: StopCard(stop: stop),
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context, String stopName) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            'Remove from Favorites?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to remove "$stopName" from your favorites?',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Remove',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: theme.colorScheme.surface,
        );
      },
    ) ?? false;
  }
}