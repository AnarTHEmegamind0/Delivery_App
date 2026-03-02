import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/design_system/design_system.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';
import 'order_success_page.dart';

class OrderMapNavigationPage extends StatefulWidget {
  final OrderModel order;

  const OrderMapNavigationPage({
    super.key,
    required this.order,
  });

  @override
  State<OrderMapNavigationPage> createState() => _OrderMapNavigationPageState();
}

class _OrderMapNavigationPageState extends State<OrderMapNavigationPage>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  // Mock destination coordinates (replace with actual from order)
  final LatLng _destination = const LatLng(47.9184, 106.9177); // Ulaanbaatar
  double _distanceToDestination = 80; // meters
  int _estimatedMinutes = 3;

  late AnimationController _pulseController;
  bool _isBottomSheetExpanded = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorSnackBar('Байршлын үйлчилгээ идэвхгүй байна');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar('Байршлын зөвшөөрөл шаардлагатай');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar('Тохиргооноос байршлын зөвшөөрөл өгнө үү');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _updateMapElements();
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            16,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      _showErrorSnackBar('Байршил авахад алдаа гарлаа');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
        ),
      );
    }
  }

  void _updateMapElements() {
    if (_currentPosition == null) return;

    _markers.clear();
    _polylines.clear();

    final currentLatLng = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    // Add route polyline with gradient effect (using multiple polylines)
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [currentLatLng, _destination],
        color: AppColors.primaryGreen,
        width: 5,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    );
  }

  void _openInMapsApp() async {
    HapticFeedback.lightImpact();
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${_destination.latitude},${_destination.longitude}&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _completeDelivery() async {
    HapticFeedback.heavyImpact();
    await context.read<OrderProvider>().completeOrder(widget.order.id);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OrderSuccessPage(order: widget.order),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: AppAnimations.pinterestEaseOut,
                  ),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: AppAnimations.medium,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // Google Map
          _buildMap(isDark),

          // Top navigation bar
          _buildTopBar(isDark),

          // ETA badge
          _buildEtaBadge(isDark),

          // Bottom sheet with order info
          _buildBottomSheet(isDark),
        ],
      ),
    );
  }

  Widget _buildMap(bool isDark) {
    if (_currentPosition == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryGreen,
              strokeWidth: 3,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Байршил тодорхойлж байна...',
              style: AppTypography.body.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        zoom: 16,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        // Apply dark map style if needed
        if (isDark) {
          _mapController?.setMapStyle(_darkMapStyle);
        }
      },
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      compassEnabled: false,
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Back button
              GlassContainer(
                padding: EdgeInsets.zero,
                borderRadius: AppSpacing.borderRadiusFull,
                blur: 16,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Address card
              Expanded(
                child: GlassContainer(
                  blur: 16,
                  padding: AppSpacing.cardInset,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.order.customerName ?? 'Хэрэглэгч',
                        style: AppTypography.h4.copyWith(
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        widget.order.address,
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? Colors.white.withOpacity(0.8)
                              : AppColors.lightTextSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Zoom controls
              Column(
                children: [
                  GlassContainer(
                    padding: EdgeInsets.zero,
                    borderRadius: AppSpacing.borderRadiusFull,
                    blur: 16,
                    child: IconButton(
                      icon: Icon(
                        Icons.add_rounded,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                      onPressed: () {
                        _mapController?.animateCamera(CameraUpdate.zoomIn());
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  GlassContainer(
                    padding: EdgeInsets.zero,
                    borderRadius: AppSpacing.borderRadiusFull,
                    blur: 16,
                    child: IconButton(
                      icon: Icon(
                        Icons.remove_rounded,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                      onPressed: () {
                        _mapController?.animateCamera(CameraUpdate.zoomOut());
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEtaBadge(bool isDark) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 100,
      left: 0,
      right: 0,
      child: Center(
        child: GlassContainer(
          blur: 20,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated pulse dot
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGreen,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(
                            0.3 + (_pulseController.value * 0.4),
                          ),
                          blurRadius: 8 + (_pulseController.value * 8),
                          spreadRadius: _pulseController.value * 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_distanceToDestination.toInt()} м',
                    style: AppTypography.h3.copyWith(
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    '~$_estimatedMinutes мин',
                    style: AppTypography.caption.copyWith(
                      color: isDark
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(bool isDark) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GlassBottomSheet(
        blur: 24,
        child: Padding(
          padding: AppSpacing.sheetInset,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Order info row
              Row(
                children: [
                  // Restaurant image
                  if (widget.order.restaurantImageUrl != null)
                    ClipRRect(
                      borderRadius: AppSpacing.borderRadiusMd,
                      child: Image.network(
                        widget.order.restaurantImageUrl!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.lightBorder,
                          child: const Icon(
                            Icons.restaurant_outlined,
                            color: AppColors.darkTextTertiary,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(width: AppSpacing.md),

                  // Order details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.restaurantName ?? 'Захиалга',
                          style: AppTypography.h4.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Row(
                          children: [
                            StatusChip(
                              label: 'Хүргэж байна',
                              type: StatusType.info,
                              size: StatusChipSize.small,
                            ),
                            const Spacer(),
                            Text(
                              '₮${widget.order.price.toInt()}',
                              style: AppTypography.h4.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Action buttons
              Row(
                children: [
                  // Arrival button
                  Expanded(
                    child: AnimatedButton(
                      label: 'Би хаяг дээр ирлээ',
                      onPressed: _completeDelivery,
                      icon: Icons.check_circle_outline,
                      fullWidth: true,
                      size: AnimatedButtonSize.large,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Navigate button
                  GlassContainer(
                    padding: EdgeInsets.zero,
                    borderRadius: AppSpacing.borderRadiusFull,
                    child: IconButton(
                      icon: const Icon(
                        Icons.navigation_rounded,
                        color: AppColors.primaryGreen,
                      ),
                      onPressed: _openInMapsApp,
                      iconSize: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Help text
              Text(
                'Хаягт очсон үед "Би хаяг дээр ирлээ" товчийг дарна уу',
                style: AppTypography.caption.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Dark map style JSON
  static const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#1d2c4d"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#8ec3b9"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1a3646"}]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#4b6878"}]
  },
  {
    "featureType": "land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#64779e"}]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [{"color": "#283d6a"}]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#6f9ba5"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [{"color": "#023e58"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [{"color": "#304a7d"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#98a5be"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [{"color": "#2c6675"}]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#98a5be"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#0e1626"}]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#4e6d70"}]
  }
]
''';
}
