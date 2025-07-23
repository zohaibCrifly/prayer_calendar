import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/widget_config_provider.dart';
import 'prayer_widget.dart';

class AnimatedPrayerWidget extends StatefulWidget {
  final bool isHomeScreenWidget;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AnimatedPrayerWidget({
    super.key,
    this.isHomeScreenWidget = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<AnimatedPrayerWidget> createState() => _AnimatedPrayerWidgetState();
}

class _AnimatedPrayerWidgetState extends State<AnimatedPrayerWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
  }

  // void _restartAnimations() {
  //   _fadeController.reset();
  //   _scaleController.reset();
  //   _slideController.reset();
  //   _startAnimations();
  // }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrayerTimesProvider, WidgetConfigProvider>(
      builder: (context, prayerProvider, configProvider, child) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            _fadeAnimation,
            _scaleAnimation,
            _slideAnimation,
          ]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildAnimatedContent(prayerProvider, configProvider),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedContent(
    PrayerTimesProvider prayerProvider,
    WidgetConfigProvider configProvider,
  ) {
    return GestureDetector(
      onTap: () {
        _triggerTapAnimation();
        widget.onTap?.call();
      },
      onLongPress: () {
        _triggerLongPressAnimation();
        widget.onLongPress?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: PrayerWidget(isHomeScreenWidget: widget.isHomeScreenWidget),
      ),
    );
  }

  void _triggerTapAnimation() {
    _scaleController.reverse().then((_) {
      _scaleController.forward();
    });
  }

  void _triggerLongPressAnimation() {
    _fadeController.reverse().then((_) {
      _fadeController.forward();
    });
  }
}

class AnimatedCountdown extends StatefulWidget {
  final Duration duration;
  final TextStyle? textStyle;
  final Color? color;

  const AnimatedCountdown({
    super.key,
    required this.duration,
    this.textStyle,
    this.color,
  });

  @override
  State<AnimatedCountdown> createState() => _AnimatedCountdownState();
}

class _AnimatedCountdownState extends State<AnimatedCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Text(
            _formatDuration(widget.duration),
            style: widget.textStyle?.copyWith(color: widget.color),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class AnimatedPrayerIndicator extends StatefulWidget {
  final bool isActive;
  final Color color;
  final double size;

  const AnimatedPrayerIndicator({
    super.key,
    required this.isActive,
    required this.color,
    this.size = 8.0,
  });

  @override
  State<AnimatedPrayerIndicator> createState() =>
      _AnimatedPrayerIndicatorState();
}

class _AnimatedPrayerIndicatorState extends State<AnimatedPrayerIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedPrayerIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
