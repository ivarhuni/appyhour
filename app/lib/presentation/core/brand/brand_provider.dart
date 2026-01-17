import 'package:flutter/widgets.dart';
import 'package:happyhour_app/presentation/core/brand/brand_config.dart';

/// InheritedWidget that provides brand configuration to the widget tree.
///
/// Wrap your MaterialApp with this widget to make brand configuration
/// available throughout the app via [BrandProvider.of(context)].
class BrandProvider extends InheritedWidget {
  /// The brand configuration for this subtree
  final BrandConfig config;

  const BrandProvider({
    super.key,
    required this.config,
    required super.child,
  });

  /// Retrieves the [BrandConfig] from the nearest ancestor [BrandProvider].
  ///
  /// Throws if no [BrandProvider] is found in the widget tree.
  static BrandConfig of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<BrandProvider>();
    assert(provider != null, 'No BrandProvider found in widget tree');
    return provider!.config;
  }

  /// Retrieves the [BrandConfig] from the nearest ancestor [BrandProvider],
  /// or returns null if no provider is found.
  static BrandConfig? maybeOf(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<BrandProvider>();
    return provider?.config;
  }

  @override
  bool updateShouldNotify(BrandProvider oldWidget) {
    // Brand config is immutable and set at app start, so never needs to notify
    return config.brand != oldWidget.config.brand;
  }
}
