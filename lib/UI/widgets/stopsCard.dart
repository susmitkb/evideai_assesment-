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
    final favoritesController = Get.find<FavoritesController>();
    final theme = Theme.of(context);
    final isFav = favoritesController.isFavorite(stop.stopname);

    return Card(
      clipBehavior: Clip.antiAlias, // ensures ripple clips to rounded shape
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.25),
          width: 0.8,
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          // Soft vertical gradient; works well with dark and light themes
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.9),
              theme.colorScheme.surfaceContainerHigh.withOpacity(0.9),
            ],
          ),
        ),
        child: InkWell(
          onTap: () => Get.to(() => StopDetailScreen(stop: stop)),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.bus_alert_rounded,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                stop.stopname,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 6,
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
              ),
              trailing: IconButton(
                tooltip: isFav ? 'Remove favorite' : 'Add to favorites',
                onPressed: () => favoritesController.toggleFavorite(stop.stopname),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isFav),
                    color: isFav ? theme.colorScheme.error : theme.colorScheme.outline,
                  ),
                ),
              ),
            ),
          ),
        ),
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
        borderRadius: BorderRadius.circular(8),
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
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
