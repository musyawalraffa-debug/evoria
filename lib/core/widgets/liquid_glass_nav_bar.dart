import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import '../theme/evoria_colors.dart';

/// Item definition for the Liquid Glass Navbar.
class LiquidNavItem {
  final IconData icon;
  final String label;

  const LiquidNavItem({
    required this.icon,
    required this.label,
  });
}

/// Standalone Reusable Liquid Glass Navigation Bar.
/// Features genuine optical depth, backdrop blur, active glass capsule (not a circle),
/// velocity-driven squash & stretch, dynamic chromatic aberration on drag,
/// magnetic spring snap on release, press-and-hold elevation, and haptic feedback.
class LiquidGlassNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final List<LiquidNavItem> items;
  final bool isDark;
  final bool forceReducedMotion;

  const LiquidGlassNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    this.isDark = false,
    this.forceReducedMotion = false,
  }) : assert(items.length >= 2, 'At least 2 items required');

  @override
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar>
    with TickerProviderStateMixin {
  // Spring animation controller for magnetic snap on release
  late AnimationController _springController;
  Animation<double>? _springAnimation;

  // Press-and-hold elevation & expansion controller
  late AnimationController _holdController;
  late Animation<double> _holdScaleAnimation;
  late Animation<double> _holdLiftAnimation;

  // Horizontal position tracking (0.0 to (itemCount - 1).toDouble())
  double _fractionalIndex = 0.0;
  bool _isDragging = false;
  bool _isHolding = false;
  int _lastHapticCenterIndex = 0;

  // Velocity tracking for dynamic squash/stretch & chromatic aberration
  double _velocity = 0.0;
  DateTime? _lastDragTime;
  double _lastDragPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _fractionalIndex = widget.selectedIndex.toDouble();
    _lastHapticCenterIndex = widget.selectedIndex;

    _springController = AnimationController.unbounded(vsync: this);
    _springController.addListener(() {
      if (_springAnimation != null) {
        setState(() {
          _fractionalIndex = _springAnimation!.value;
        });
      }
    });

    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _holdScaleAnimation = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _holdController, curve: Curves.easeOutCubic),
    );

    _holdLiftAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _holdController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(covariant LiquidGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex && !_isDragging) {
      _animateToTab(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _springController.dispose();
    _holdController.dispose();
    super.dispose();
  }

  void _triggerHaptic() {
    HapticFeedback.selectionClick();
  }

  void _triggerHoldHaptic() {
    HapticFeedback.lightImpact();
  }

  void _animateToTab(int targetIndex, {double initialVelocity = 0.0}) {
    final bool reducedMotion =
        widget.forceReducedMotion || MediaQuery.of(context).disableAnimations;

    if (reducedMotion) {
      _springController.stop();
      setState(() {
        _fractionalIndex = targetIndex.toDouble();
        _velocity = 0.0;
      });
      return;
    }

    final double start = _fractionalIndex;
    final double end = targetIndex.toDouble();

    // Damped spring simulation (zeta ~ 0.78 for gentle settle without harsh oscillation)
    const SpringDescription spring = SpringDescription(
      mass: 1.0,
      stiffness: 280.0,
      damping: 24.0,
    );

    final SpringSimulation simulation = SpringSimulation(
      spring,
      start,
      end,
      initialVelocity,
    );

    _springAnimation = _springController.drive(
      Tween<double>(begin: start, end: end),
    );

    _springController.animateWith(simulation).then((_) {
      if (mounted) {
        setState(() {
          _fractionalIndex = targetIndex.toDouble();
          _velocity = 0.0;
        });
      }
    });
  }

  void _onHorizontalDragDown(DragDownDetails details, double totalWidth) {
    _springController.stop();
    setState(() {
      _isHolding = true;
    });
    _holdController.forward();
    _triggerHoldHaptic();
    _lastDragTime = DateTime.now();
    _lastDragPosition = details.localPosition.dx;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double totalWidth) {
    final double itemWidth = totalWidth / widget.items.length;
    final double newFractional =
        (details.localPosition.dx - (itemWidth / 2)) / itemWidth;
    final double clamped =
        newFractional.clamp(0.0, (widget.items.length - 1).toDouble());

    // Calculate instantaneous velocity (units: tabs per second)
    final now = DateTime.now();
    if (_lastDragTime != null) {
      final double dt =
          (now.difference(_lastDragTime!).inMicroseconds) / 1000000.0;
      if (dt > 0.005) {
        final double dx = details.localPosition.dx - _lastDragPosition;
        _velocity = (dx / itemWidth) / dt;
        _lastDragTime = now;
        _lastDragPosition = details.localPosition.dx;
      }
    }

    // Check center crossing for subtle haptic
    final int nearestCenter = clamped.round();
    if (nearestCenter != _lastHapticCenterIndex) {
      _triggerHaptic();
      _lastHapticCenterIndex = nearestCenter;
    }

    setState(() {
      _isDragging = true;
      _fractionalIndex = clamped;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details, double totalWidth) {
    final double itemWidth = totalWidth / widget.items.length;
    final double tabVelocity =
        details.primaryVelocity != null ? (details.primaryVelocity! / itemWidth) : 0.0;

    // Projected landing with velocity inertia
    final double target = (_fractionalIndex + (tabVelocity * 0.15)).roundToDouble();
    final int targetIndex =
        target.round().clamp(0, widget.items.length - 1);

    setState(() {
      _isDragging = false;
      _isHolding = false;
    });
    _holdController.reverse();

    _animateToTab(targetIndex, initialVelocity: tabVelocity);
    if (targetIndex != widget.selectedIndex) {
      widget.onItemSelected(targetIndex);
    }
  }

  void _onHorizontalDragCancel() {
    setState(() {
      _isDragging = false;
      _isHolding = false;
    });
    _holdController.reverse();
    _animateToTab(widget.selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: math.max(bottomPadding + 10, 20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double itemWidth = totalWidth / widget.items.length;
          const double barHeight = 68.0;

          return Container(
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              boxShadow: isDark
                  ? EvoriaShadows.liquidNavbarDark
                  : EvoriaShadows.liquidNavbarLight,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: GestureDetector(
                  onHorizontalDragDown: (d) => _onHorizontalDragDown(d, totalWidth),
                  onHorizontalDragUpdate: (d) =>
                      _onHorizontalDragUpdate(d, totalWidth),
                  onHorizontalDragEnd: (d) => _onHorizontalDragEnd(d, totalWidth),
                  onHorizontalDragCancel: _onHorizontalDragCancel,
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    children: [
                      // Base frosted glass background tint & border
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34),
                            color: isDark
                                ? const Color(0x35272323)
                                : const Color(0x35F5F0E8),
                            border: Border.all(
                              color: isDark
                                  ? EvoriaColors.glassBorderDark
                                  : EvoriaColors.glassBorderLight,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),

                      // Outer specular rim highlights (top light reflect, bottom ambient shadow)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _NavBarSpecularRimPainter(isDark: isDark),
                        ),
                      ),

                      // Active Liquid Glass Capsule (Elongated Lozenge with Optical Refraction)
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _springController,
                          _holdController,
                        ]),
                        builder: (context, child) {
                          final double capsuleScale = _holdScaleAnimation.value;
                          final double lift = _holdLiftAnimation.value;

                          // Squash-and-stretch computation along direction of velocity
                          final double speed = _velocity.abs();
                          final double stretchFactor = math.min(0.20, speed * 0.04);
                          final double widthStretch = 1.0 + stretchFactor;
                          final double heightSquash = 1.0 / math.sqrt(widthStretch);

                          // Capsule dimensions
                          final double baseWidth = itemWidth * 0.82;
                          final double baseHeight = 48.0;
                          final double currentWidth =
                              baseWidth * capsuleScale * widthStretch;
                          final double currentHeight =
                              baseHeight * capsuleScale * heightSquash;

                          final double capsuleLeft =
                              (_fractionalIndex * itemWidth) +
                                  (itemWidth - currentWidth) / 2;
                          final double capsuleTop =
                              ((barHeight - currentHeight) / 2) - lift;

                          return Positioned(
                            left: capsuleLeft,
                            top: capsuleTop,
                            width: currentWidth,
                            height: currentHeight,
                            child: CustomPaint(
                              painter: _ActiveGlassCapsulePainter(
                                isDark: isDark,
                                velocity: _velocity,
                                isHolding: _isHolding,
                                lift: lift,
                              ),
                            ),
                          );
                        },
                      ),

                      // Tab icons & text labels
                      Positioned.fill(
                        child: Row(
                          children: List.generate(widget.items.length, (index) {
                            final item = widget.items[index];
                            final double distance =
                                (_fractionalIndex - index).abs();
                            final double selectionFactor =
                                (1.0 - distance.clamp(0.0, 1.0));

                            final Color unselectedColor = isDark
                                ? EvoriaColors.darkMuted
                                : EvoriaColors.lightMuted;
                            final Color selectedColor = isDark
                                ? EvoriaColors.darkText
                                : EvoriaColors.lightTerracotta;

                            final Color iconColor = Color.lerp(
                              unselectedColor,
                              selectedColor,
                              selectionFactor,
                            )!;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _triggerHaptic();
                                  _animateToTab(index);
                                  widget.onItemSelected(index);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 1.0 + (selectionFactor * 0.12),
                                      child: Icon(
                                        item.icon,
                                        size: 22,
                                        color: iconColor,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10.5,
                                        fontWeight: selectionFactor > 0.5
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: iconColor,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for the outer navbar's specular rim reflection.
class _NavBarSpecularRimPainter extends CustomPainter {
  final bool isDark;

  const _NavBarSpecularRimPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );

    // Subtle top specular gradient (simulates overhead celestial light)
    final Paint topGleamPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height * 0.35),
        [
          isDark ? const Color(0x35FFFFFF) : const Color(0x65FFFFFF),
          Colors.transparent,
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(rrect, topGleamPaint);
  }

  @override
  bool shouldRepaint(covariant _NavBarSpecularRimPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

/// Custom painter for the active glass capsule:
/// - Elongated lozenge shape
/// - Specular highlight rim
/// - Dynamic chromatic aberration fringes on high velocity drag
/// - Internal warm glow
class _ActiveGlassCapsulePainter extends CustomPainter {
  final bool isDark;
  final double velocity;
  final bool isHolding;
  final double lift;

  const _ActiveGlassCapsulePainter({
    required this.isDark,
    required this.velocity,
    required this.isHolding,
    required this.lift,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.height / 2;
    final RRect capsuleRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    // 1. Dynamic Chromatic Aberration Dispersion Rims (if moving fast)
    final double speed = velocity.abs();
    if (speed > 0.4) {
      final double offsetPx = (velocity.clamp(-4.0, 4.0) * 0.8);

      // Cyan trailing shift
      final RRect cyanRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(-offsetPx, 0, size.width, size.height),
        Radius.circular(radius),
      );
      final Paint cyanPaint = Paint()
        ..color = EvoriaColors.chromaticCyan.withOpacity(math.min(0.35, speed * 0.08))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(cyanRRect, cyanPaint);

      // Amber / Red leading shift
      final RRect amberRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(offsetPx, 0, size.width, size.height),
        Radius.circular(radius),
      );
      final Paint amberPaint = Paint()
        ..color = (isDark ? EvoriaColors.chromaticViolet : EvoriaColors.chromaticAmber)
            .withOpacity(math.min(0.35, speed * 0.08))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(amberRRect, amberPaint);
    }

    // 2. Active Capsule Ambient Fill & Internal Glass Luster
    final Paint bodyPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        isDark
            ? [
                const Color(0x55C58D73),
                const Color(0x351B1716),
              ]
            : [
                const Color(0x60FFFFFF),
                const Color(0x35EAE0D3),
              ],
      );
    canvas.drawRRect(capsuleRRect, bodyPaint);

    // 3. Warm Peach / Terracotta Internal Glow
    final Paint glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.5, size.height * 0.4),
        size.width * 0.6,
        isDark
            ? [
                const Color(0x40C58D73),
                Colors.transparent,
              ]
            : [
                const Color(0x45E9B99E),
                Colors.transparent,
              ],
      );
    canvas.drawRRect(capsuleRRect, glowPaint);

    // 4. Specular Edge Highlight Border (Beveled Glass Rim)
    final Paint specularBorderPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(size.width, size.height),
        isDark
            ? [
                const Color(0x80FFFFFF),
                const Color(0x20C58D73),
                const Color(0x50FFFFFF),
              ]
            : [
                const Color(0x95FFFFFF),
                const Color(0x30A46B55),
                const Color(0x65FFFFFF),
              ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHolding ? 1.6 : 1.2;
    canvas.drawRRect(capsuleRRect, specularBorderPaint);
  }

  @override
  bool shouldRepaint(covariant _ActiveGlassCapsulePainter oldDelegate) {
    return oldDelegate.isDark != isDark ||
        oldDelegate.velocity != velocity ||
        oldDelegate.isHolding != isHolding ||
        oldDelegate.lift != lift;
  }
}
