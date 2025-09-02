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
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text('Stop Details'),
            actions: [
              Obx(() => IconButton(
                tooltip: favoritesController.isFavorite(stop.stopname)
                    ? 'Remove favorite'
                    : 'Add to favorites',
                icon: Icon(
                  favoritesController.isFavorite(stop.stopname)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favoritesController.isFavorite(stop.stopname)
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () =>
                    favoritesController.toggleFavorite(stop.stopname),
              )),
            ],
            pinned: true,
          ),

          // Header: Stop name and quick chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.stopname,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaChip(
                        icon: Icons.access_time,
                        label: 'ETA ${_calculateETA(stop)} min',
                        color: theme.colorScheme.primary,
                      ),
                      _MetaChip(
                        icon: Icons.pin_drop_rounded,
                        label: 'Lat ${stop.latitude.toStringAsFixed(6)}',
                        color: theme.colorScheme.tertiary,
                      ),
                      _MetaChip(
                        icon: Icons.pin_drop_rounded,
                        label: 'Lng ${stop.longitude.toStringAsFixed(6)}',
                        color: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Info card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.25),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.explore_rounded,
                          color: theme.colorScheme.primary),
                      title: const Text('Coordinates'),
                      subtitle: Text(
                        'Lat ${stop.latitude.toStringAsFixed(6)}, Lng ${stop.longitude.toStringAsFixed(6)}',
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.timer_outlined,
                          color: theme.colorScheme.secondary),
                      title: const Text('Time difference'),
                      subtitle: Text('${stop.timedifference} min'),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: Icon(Icons.directions_bus_filled_rounded,
                          color: theme.colorScheme.tertiary),
                      title: const Text('Estimated arrival'),
                      subtitle: Text('${_calculateETA(stop)} min'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Map block
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: _MapPlaceholder(),
            ),
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

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.surfaceContainerHigh,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map_rounded,
                  size: 56, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 8),
              Text(
                'Map View',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
