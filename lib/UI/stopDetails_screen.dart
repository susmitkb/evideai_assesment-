// views/stop_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamevideai/controllers/favourites_controller.dart';
import 'package:teamevideai/models/busStop_models.dart';

class StopDetailScreen extends StatelessWidget {
  final BusStop stop;

  StopDetailScreen({Key? key, required this.stop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final FavoritesController favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // App Bar with Collapsing Effect
          SliverAppBar.large(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                stop.stopname,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimary,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.directions_bus_rounded,
                    size: 64,
                    color: colorScheme.onPrimary.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            actions: [
              // Use Obx to reactively update the favorite icon
              Obx(() {
                final isFavorite = favoritesController.isFavorite(stop.stopname);
                return IconButton(
                  icon: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      key: ValueKey(isFavorite),
                      color: isFavorite ? Colors.red : colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () => _showFavoriteConfirmation(context, isFavorite, favoritesController),
                );
              }),
            ],
          ),

          // Content Section
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Info Chips
                    _buildInfoChips(theme, colorScheme),
                    SizedBox(height: 24),

                    // Detailed Information Card
                    _buildDetailCard(theme, colorScheme),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              // ETA Section - Now covering full width
              _buildETASection(theme, colorScheme),
            ]),
          ),
        ],
      ),
    );
  }

  // Show confirmation dialog for adding/removing favorites
  void _showFavoriteConfirmation(BuildContext context, bool isCurrentlyFavorite, FavoritesController favoritesController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isCurrentlyFavorite ? 'Remove from Favorites?' : 'Add to Favorites?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          content: Text(
            isCurrentlyFavorite
                ? 'Are you sure you want to remove "${stop.stopname}" from your favorites?'
                : 'Do you want to add "${stop.stopname}" to your favorites for quick access?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                favoritesController.toggleFavorite(stop.stopname);
                Navigator.of(context).pop();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isCurrentlyFavorite
                          ? 'Removed from favorites'
                          : 'Added to favorites',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: Text(
                isCurrentlyFavorite ? 'Remove' : 'Add',
                style: TextStyle(
                  color: isCurrentlyFavorite
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        );
      },
    );
  }

  Widget _buildInfoChips(ThemeData theme, ColorScheme colorScheme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _InfoChip(
          icon: Icons.explore_rounded,
          label: 'Lat: ${stop.latitude.toStringAsFixed(6)}',
          color: colorScheme.primary,
        ),
        _InfoChip(
          icon: Icons.explore_rounded,
          label: 'Lng: ${stop.longitude.toStringAsFixed(6)}',
          color: colorScheme.primary,
        ),
        _InfoChip(
          icon: Icons.access_time_rounded,
          label: '${stop.timedifference} min diff',
          color: colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildDetailCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _DetailRow(
              icon: Icons.pin_drop_rounded,
              title: 'Coordinates',
              subtitle: '${stop.latitude.toStringAsFixed(6)}, ${stop.longitude.toStringAsFixed(6)}',
              color: colorScheme.primary,
            ),
            const Divider(height: 32),
            _DetailRow(
              icon: Icons.schedule_rounded,
              title: 'Time Difference',
              subtitle: '${stop.timedifference} minutes away from previous stop',
              color: colorScheme.secondary,
            ),
            const Divider(height: 32),
            _DetailRow(
              icon: Icons.info_rounded,
              title: 'Stop Name',
              subtitle: stop.stopname,
              color: colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildETASection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity, // This makes it cover full width
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 0), // Remove horizontal margins
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // ETA Icon with Pulse Animation
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Icon(
              Icons.directions_bus_rounded,
              size: 40,
              color: colorScheme.onPrimary,
            ),
          ),
          SizedBox(height: 20),

          // ETA Title
          Text(
            'Estimated Arrival',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8),

          // ETA Value
          Text(
            '${_calculateETA(stop)} minutes',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: 12),

          // Additional Info
          Text(
            'Based on current schedule patterns',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateETA(BusStop stop) {
    return (stop.timedifference * 2).toString();
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}