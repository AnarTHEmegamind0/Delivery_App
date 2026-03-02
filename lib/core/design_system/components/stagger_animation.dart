import 'package:flutter/material.dart';
import '../tokens/animations.dart';

enum StaggerDirection { up, down, left, right }

/// Staggered animation wrapper for list items
/// Creates a cascade effect as items enter the viewport
class StaggeredItem extends StatefulWidget {
  const StaggeredItem({
    super.key,
    required this.index,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
    this.direction = StaggerDirection.up,
    this.enabled = true,
  });

  final int index;
  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final Curve? curve;
  final StaggerDirection direction;
  final bool enabled;

  @override
  State<StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<StaggeredItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final duration = widget.duration ?? AppAnimations.normal;
    final delay = widget.delay ?? AppAnimations.staggerDelayFor(widget.index);
    final curve = widget.curve ?? AppAnimations.pinterestEaseOut;

    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: curve),
    );

    Offset beginOffset;
    switch (widget.direction) {
      case StaggerDirection.up:
        beginOffset = const Offset(0, 0.1);
        break;
      case StaggerDirection.down:
        beginOffset = const Offset(0, -0.1);
        break;
      case StaggerDirection.left:
        beginOffset = const Offset(0.1, 0);
        break;
      case StaggerDirection.right:
        beginOffset = const Offset(-0.1, 0);
        break;
    }

    _slideAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: curve),
    );

    if (widget.enabled) {
      Future.delayed(delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Staggered list builder
/// Automatically applies stagger animation to list items
class StaggeredListView extends StatelessWidget {
  const StaggeredListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.direction = StaggerDirection.up,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.separatorBuilder,
    this.animationEnabled = true,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final StaggerDirection direction;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final bool animationEnabled;

  @override
  Widget build(BuildContext context) {
    if (separatorBuilder != null) {
      return ListView.separated(
        padding: padding,
        physics: physics,
        controller: controller,
        shrinkWrap: shrinkWrap,
        itemCount: itemCount,
        separatorBuilder: separatorBuilder!,
        itemBuilder: (context, index) {
          return StaggeredItem(
            index: index,
            direction: direction,
            enabled: animationEnabled,
            child: itemBuilder(context, index),
          );
        },
      );
    }

    return ListView.builder(
      padding: padding,
      physics: physics,
      controller: controller,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return StaggeredItem(
          index: index,
          direction: direction,
          enabled: animationEnabled,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Staggered column for non-scrollable staggered content
class StaggeredColumn extends StatelessWidget {
  const StaggeredColumn({
    super.key,
    required this.children,
    this.direction = StaggerDirection.up,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.animationEnabled = true,
  });

  final List<Widget> children;
  final StaggerDirection direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool animationEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.asMap().entries.map((entry) {
        return StaggeredItem(
          index: entry.key,
          direction: direction,
          enabled: animationEnabled,
          child: entry.value,
        );
      }).toList(),
    );
  }
}

/// Staggered grid for Pinterest-style masonry layouts
class StaggeredGrid extends StatelessWidget {
  const StaggeredGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.animationEnabled = true,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool animationEnabled;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: physics,
      controller: controller,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return StaggeredItem(
          index: index,
          enabled: animationEnabled,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Animated content reveal on scroll
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.duration,
    this.curve,
    this.offset = 50,
    this.direction = AxisDirection.up,
  });

  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final double offset;
  final AxisDirection direction;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isVisible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.duration ?? AppAnimations.medium;
    final curve = widget.curve ?? AppAnimations.pinterestEaseOut;

    double dx = 0;
    double dy = 0;

    switch (widget.direction) {
      case AxisDirection.up:
        dy = widget.offset;
        break;
      case AxisDirection.down:
        dy = -widget.offset;
        break;
      case AxisDirection.left:
        dx = widget.offset;
        break;
      case AxisDirection.right:
        dx = -widget.offset;
        break;
    }

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: duration,
      curve: curve,
      child: AnimatedSlide(
        offset: _isVisible ? Offset.zero : Offset(dx / 100, dy / 100),
        duration: duration,
        curve: curve,
        child: widget.child,
      ),
    );
  }
}

/// Shimmer effect for loading with stagger
class StaggeredShimmer extends StatelessWidget {
  const StaggeredShimmer({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
  });

  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return StaggeredItem(
          index: index,
          duration: AppAnimations.fast,
          child: itemBuilder(index),
        );
      },
    );
  }
}
