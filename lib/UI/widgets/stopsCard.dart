// widgets/stops_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamevideai/UI/stopDetails_screen.dart';
import 'package:teamevideai/controllers/favourites_controller.dart';
import 'package:teamevideai/models/busStop_models.dart';

class StopCard extends StatelessWidget {
  final BusStop stop;

  const StopCard({Key? key, required this.stop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final favoritesController = Get.find<FavoritesController>();
      final isFav = favoritesController.isFavorite(stop.stopname);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Material(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          elevation: 1,
          shadowColor: Colors.black.withOpacity(0.1),
          child: InkWell(
            onTap: () => _navigateToDetail(stop, context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Icon
                  _buildLocationIcon(theme),
                  SizedBox(width: 16),

                  // Stop Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStopName(stop.stopname, theme),
                        SizedBox(height: 8),
                        _buildCoordinates(stop, theme),
                        SizedBox(height: 8),
                        _buildETAInfo(stop, theme),
                      ],
                    ),
                  ),

                  // Favorite Button
                  _buildFavoriteButton(favoritesController, stop, isFav, theme),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLocationIcon(ThemeData theme) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.directions_bus_outlined,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildStopName(String name, ThemeData theme) {
    return Text(
      name,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCoordinates(BusStop stop, ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.explore_rounded, size: 14, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          '${stop.latitude.toStringAsFixed(4)}, ${stop.longitude.toStringAsFixed(4)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildETAInfo(BusStop stop, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, size: 14, color: theme.colorScheme.primary),
          SizedBox(width: 4),
          Text(
            'ETA: ${_calculateETA(stop)} min',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(FavoritesController controller, BusStop stop, bool isFav, ThemeData theme) {
    return GestureDetector(
      onTap: () => _handleFavoriteToggle(controller, stop),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isFav ? theme.colorScheme.error.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: Icon(
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(isFav),
            color: isFav ? theme.colorScheme.error : theme.colorScheme.onSurface.withOpacity(0.5),
            size: 24,
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BusStop stop, BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => StopDetailScreen(stop: stop),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 400),
      ),
    );
  }

  void _handleFavoriteToggle(FavoritesController controller, BusStop stop) {
    controller.toggleFavorite(stop.stopname);

    // Show quick feedback snackbar
    final isNowFavorite = controller.isFavorite(stop.stopname);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          isNowFavorite ? 'Added to favorites' : 'Removed from favorites',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: isNowFavorite ? Colors.green : Colors.grey[700],
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  String _calculateETA(BusStop stop) {
    return (stop.timedifference * 2).toString();
  }
}