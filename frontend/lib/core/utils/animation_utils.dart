import 'package:flutter/material.dart';

class AnimationUtils {
  // Default animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  // Standard curve for animations
  static const Curve standardCurve = Curves.easeInOut;
  static const Curve decelerateCurve = Curves.decelerate;
  static const Curve accelerateCurve = Curves.accelerate;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve elasticCurve = Curves.elasticOut;

  // Create a fade in animation
  static Animation<double> fadeIn(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }

  // Create a fade out animation
  static Animation<double> fadeOut(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }

  // Create a slide up animation
  static Animation<Offset> slideUp(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }

  // Create a slide down animation
  static Animation<Offset> slideDown(AnimationController controller) {
    return Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }

  // Create a slide in from left animation
  static Animation<Offset> slideInFromLeft(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }

  // Create a slide out to right animation
  static Animation<Offset> slideOutToRight(AnimationController controller) {
    return Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }

  // Create a scale animation
  static Animation<double> scale(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: elasticCurve,
      ),
    );
  }

  // Create a rotation animation
  static Animation<double> rotate(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 2.0 * 3.14159, // 360 degrees in radians
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: standardCurve,
      ),
    );
  }

  // Create a bounce animation
  static Animation<double> bounce(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: bounceCurve,
      ),
    );
  }

  // Create a staggered animation
  static Animation<Offset> staggeredSlide(
    AnimationController controller, {
    double beginX = 0.0,
    double beginY = 0.0,
    double endX = 0.0,
    double endY = 0.0,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<Offset>(
      begin: Offset(beginX, beginY),
      end: Offset(endX, endY),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  // Create a color tween animation
  static Animation<Color?> colorTween(
    AnimationController controller, {
    required Color begin,
    required Color end,
    Curve curve = Curves.easeInOut,
  }) {
    return ColorTween(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    )!;
  }

  // Create a size animation
  static Animation<Size> sizeAnimation(
    AnimationController controller, {
    required Size begin,
    required Size end,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<Size>(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  // Create a padding animation
  static Animation<EdgeInsets> paddingAnimation(
    AnimationController controller, {
    required EdgeInsets begin,
    required EdgeInsets end,
    Curve curve = Curves.easeInOut,
  }) {
    return EdgeInsetsTween(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  // Create a border radius animation
  static Animation<BorderRadius> borderRadiusAnimation(
    AnimationController controller, {
    required BorderRadius begin,
    required BorderRadius end,
    Curve curve = Curves.easeInOut,
  }) {
    return BorderRadiusTween(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  // Create a text style animation
  static Animation<TextStyle> textStyleAnimation(
    AnimationController controller, {
    required TextStyle begin,
    required TextStyle end,
    Curve curve = Curves.easeInOut,
  }) {
    return TextStyleTween(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: curve,
      ),
    );
  }

  // Create a staggered animation for a list of widgets
  static List<Animation<Offset>> staggeredListAnimations(
    AnimationController controller, {
    required int itemCount,
    double offset = 50.0,
    Curve curve = Curves.easeOut,
  }) {
    return List<Animation<Offset>>.generate(
      itemCount,
      (index) => Tween<Offset>(
        begin: Offset(0, offset),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: CurvedAnimation(
            parent: controller,
            curve: Interval(
              (1 / itemCount) * index,
              1.0,
              curve: curve,
            ),
          ),
          curve: curve,
        ),
      ),
    );
  }

  // Create a shimmer effect animation
  static AnimationController shimmerController(AnimationController parent) {
    return AnimationController(
      vsync: parent,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  // Create a shimmer gradient
  static Shader shimmerGradient(AnimationController controller) {
    return LinearGradient(
      colors: const [
        Colors.black12,
        Colors.black26,
        Colors.black12,
      ],
      stops: const [0.1, 0.5, 0.9],
    ).createShader(
      Rect.fromLTWH(
        0.0,
        0.0,
        controller.value * 400.0, // Adjust width as needed
        100.0, // Adjust height as needed
      ),
    );
  }

  // Create a page route with custom transitions
  static PageRouteBuilder<T> createPageRoute<T>({
    required Widget page,
    RouteSettings? settings,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    bool fullscreenDialog = false,
    bool fadeTransition = false,
    bool slideTransition = true,
    bool scaleTransition = false,
    Offset beginOffset = const Offset(1.0, 0.0),
    Offset endOffset = Offset.zero,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      fullscreenDialog: fullscreenDialog,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curveTween = CurveTween(curve: curve);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curveTween.curve,
        );

        final List<Widget> transitions = [];

        if (fadeTransition) {
          transitions.add(
            FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
              child: child,
            ),
          );
        }

        if (slideTransition) {
          transitions.add(
            SlideTransition(
              position: Tween<Offset>(
                begin: beginOffset,
                end: endOffset,
              ).animate(curvedAnimation),
              child: fadeTransition ? child : child,
            ),
          );
        }

        if (scaleTransition) {
          transitions.add(
            ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(curvedAnimation),
              child: fadeTransition || slideTransition ? child : child,
            ),
          );
        }

        return transitions.isNotEmpty
            ? Stack(
                children: transitions,
              )
            : child;
      },
    );
  }

  // Create a staggered animation for a grid
  static List<Animation<Offset>> staggeredGridAnimations(
    AnimationController controller, {
    required int rowCount,
    required int columnCount,
    double offset = 50.0,
    Curve curve = Curves.easeOut,
  }) {
    final List<Animation<Offset>> animations = [];
    final totalItems = rowCount * columnCount;
    final maxDelay = 0.5; // Maximum delay as a fraction of the animation

    for (int i = 0; i < totalItems; i++) {
      final row = i ~/ columnCount;
      final col = i % columnCount;
      
      // Calculate delay based on position (diagonal effect)
      final delay = (row + col) / (rowCount + columnCount - 2) * maxDelay;
      
      animations.add(
        Tween<Offset>(
          begin: Offset(0, offset),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              delay,
              1.0,
              curve: curve,
            ),
          ),
        ),
      );
    }

    return animations;
  }
}
