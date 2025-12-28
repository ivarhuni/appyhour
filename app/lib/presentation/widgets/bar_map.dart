import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// A map widget displaying a single bar location.
class BarMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String name;
  final double height;

  const BarMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.name,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = LatLng(latitude, longitude);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: location,
            initialZoom: 15,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'is.happyhour.happyhour_app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: location,
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.sports_bar,
                      color: theme.colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
