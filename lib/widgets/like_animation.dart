import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  // The widget that will be animated
  final Widget child;
  // If is animating or not
  final bool isAnimating;
  // The duration of the like animation
  final Duration duration;
  // When the animation ends do something
  final VoidCallback? onEnd;
  // Can either be the small icon btn or in the post image big button
  final bool smallLike;

  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike = false,
  }) : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  // Create animation controller
  late AnimationController _animationController;

  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // Controls the animation
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));

    // Value that will make the animation happen
    _scale = Tween<double>(begin: 1, end: 1.2).animate(_animationController);
  }

  startAnimation() async {
    // if the widget is liked, or if the widget is a small like
    if (widget.isAnimating || widget.smallLike) {
      // Start the controller animation
      await _animationController.forward();
      // Reverse it
      await _animationController.reverse();

      // Add some delay
      await Future.delayed(const Duration(
        milliseconds: 200,
      ));

      // Check if its ended
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // This function is called whenever this Widget is re-built with the same key

    // If this new widget is not animating and the old one is, then start the animation
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: widget.child,
    );
  }
}
