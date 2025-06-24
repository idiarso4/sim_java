import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A utility class to handle responsive layouts and screen sizing
class ResponsiveUtils {
  // Screen size breakpoints (in logical pixels)
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  static const double largeDesktopBreakpoint = 1600.0;

  // Singleton instance
  static final ResponsiveUtils _instance = ResponsiveUtils._internal();
  factory ResponsiveUtils() => _instance;
  ResponsiveUtils._internal();

  // Screen size information
  static late MediaQueryData _mediaQueryData;
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double _safeBlockHorizontal;
  static late double _safeBlockVertical;
  static late Orientation _orientation;

  // Initialize the responsive utils
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    _orientation = _mediaQueryData.orientation;
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    final padding = _mediaQueryData.padding;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = padding.top + padding.bottom;
    _safeBlockHorizontal = (_screenWidth - _safeAreaHorizontal) / 100;
    _safeBlockVertical = (_screenHeight - _safeAreaVertical) / 100;
  }

  // Getters
  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
  static double get blockSizeHorizontal => _blockSizeHorizontal;
  static double get blockSizeVertical => _blockSizeVertical;
  static double get safeBlockHorizontal => _safeBlockHorizontal;
  static double get safeBlockVertical => _safeBlockVertical;
  static Orientation get orientation => _orientation;
  static bool get isPortrait => _orientation == Orientation.portrait;
  static bool get isLandscape => _orientation == Orientation.landscape;

  // Device type detection
  static bool get isMobile => _screenWidth < mobileBreakpoint;
  static bool get isTablet =>
      _screenWidth >= mobileBreakpoint && _screenWidth < desktopBreakpoint;
  static bool get isDesktop => _screenWidth >= desktopBreakpoint;
  static bool get isSmallDesktop =>
      _screenWidth >= desktopBreakpoint && _screenWidth < largeDesktopBreakpoint;
  static bool get isLargeDesktop => _screenWidth >= largeDesktopBreakpoint;

  // Responsive sizing methods
  static double width(double size) => size.w;
  static double height(double size) => size.h;
  static double fontSize(double size) => size.sp;
  static double radius(double size) => size.r;

  // Responsive padding/margin
  static EdgeInsetsGeometry responsivePadding({
    double mobile = 16.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
    bool safeArea = false,
  }) {
    if (isLargeDesktop && largeDesktop != null) {
      return EdgeInsets.all(largeDesktop);
    } else if (isDesktop && desktop != null) {
      return EdgeInsets.all(desktop);
    } else if (isTablet && tablet != null) {
      return EdgeInsets.all(tablet);
    }
    return EdgeInsets.all(mobile);
  }

  // Responsive width
  static double responsiveWidth({
    double mobile = double.infinity,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    if (isLargeDesktop && largeDesktop != null) return largeDesktop.w;
    if (isDesktop && desktop != null) return desktop.w;
    if (isTablet && tablet != null) return tablet.w;
    return mobile == double.infinity ? mobile : mobile.w;
  }

  // Responsive height
  static double responsiveHeight({
    double mobile = double.infinity,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    if (isLargeDesktop && largeDesktop != null) return largeDesktop.h;
    if (isDesktop && desktop != null) return desktop.h;
    if (isTablet && tablet != null) return tablet.h;
    return mobile == double.infinity ? mobile : mobile.h;
  }

  // Responsive font size
  static double responsiveFontSize({
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    if (isLargeDesktop && largeDesktop != null) return largeDesktop.sp;
    if (isDesktop && desktop != null) return desktop.sp;
    if (isTablet && tablet != null) return tablet.sp;
    return mobile.sp;
  }

  // Responsive border radius
  static BorderRadius responsiveBorderRadius({
    double mobile = 8.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    double radius = mobile;
    if (isLargeDesktop && largeDesktop != null) {
      radius = largeDesktop;
    } else if (isDesktop && desktop != null) {
      radius = desktop;
    } else if (isTablet && tablet != null) {
      radius = tablet;
    }
    return BorderRadius.circular(radius.r);
  }

  // Aspect ratio calculation
  static double getAspectRatio({
    required double width,
    required double height,
  }) {
    return width / height;
  }

  // Orientation based sizing
  static double getOrientationValue({
    required double portrait,
    required double landscape,
  }) {
    return isPortrait ? portrait : landscape;
  }

  // Safe area padding
  static EdgeInsets get safeAreaPadding => EdgeInsets.only(
        top: _mediaQueryData.padding.top,
        bottom: _mediaQueryData.padding.bottom,
        left: _mediaQueryData.padding.left,
        right: _mediaQueryData.padding.right,
      );

  // View insets (keyboard, status bar, etc.)
  static EdgeInsets get viewInsets => _mediaQueryData.viewInsets;
  static EdgeInsets get viewPadding => _mediaQueryData.padding;
  static double get statusBarHeight => _mediaQueryData.padding.top;
  static double get bottomInset => _mediaQueryData.viewInsets.bottom;
  static double get keyboardHeight => _mediaQueryData.viewInsets.bottom;

  // Screen size helpers
  static double get safeAreaWidth => _screenWidth - _safeAreaHorizontal;
  static double get safeAreaHeight => _screenHeight - _safeAreaVertical;

  // Grid layout helpers
  static int getGridCrossAxisCount({
    int mobile = 1,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    if (isLargeDesktop && largeDesktop != null) return largeDesktop;
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // Responsive spacing
  static SizedBox verticalSpacing(double height) => SizedBox(height: height.h);
  static SizedBox horizontalSpacing(double width) => SizedBox(width: width.w);

  // Device pixel ratio
  static double get pixelRatio => _mediaQueryData.devicePixelRatio;

  // Text scale factor
  static double get textScaleFactor => _mediaQueryData.textScaleFactor;

  // Platform brightness
  static Brightness get platformBrightness => _mediaQueryData.platformBrightness;

  // Check if device is in dark mode
  static bool get isDarkMode => platformBrightness == Brightness.dark;

  // Check if device is in light mode
  static bool get isLightMode => platformBrightness == Brightness.light;

  // Check if keyboard is visible
  static bool get isKeyboardVisible => _mediaQueryData.viewInsets.bottom > 0;

  // Get keyboard height
  static double get keyboardVisibleHeight => _mediaQueryData.viewInsets.bottom;
}

// Extension for BuildContext to easily access responsive utils
extension ResponsiveExtension on BuildContext {
  // Screen size
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  // Responsive sizing
  double width(double size) => size.w;
  double height(double size) => size.h;
  double fontSize(double size) => size.sp;
  double radius(double size) => size.r;
  
  // Media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  // Text theme
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  // Theme
  ThemeData get theme => Theme.of(this);
  
  // Safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;
  
  // Orientation
  Orientation get orientation => MediaQuery.of(this).orientation;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
  
  // Device type
  bool get isMobile => screenWidth < ResponsiveUtils.mobileBreakpoint;
  bool get isTablet => 
      screenWidth >= ResponsiveUtils.mobileBreakpoint && 
      screenWidth < ResponsiveUtils.desktopBreakpoint;
  bool get isDesktop => screenWidth >= ResponsiveUtils.desktopBreakpoint;
}

// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    bool isLargeDesktop,
  ) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        final isMobile = width < ResponsiveUtils.mobileBreakpoint;
        final isTablet = 
            width >= ResponsiveUtils.mobileBreakpoint && 
            width < ResponsiveUtils.desktopBreakpoint;
        final isLargeDesktop = width >= ResponsiveUtils.largeDesktopBreakpoint;
        final isDesktop = 
            width >= ResponsiveUtils.desktopBreakpoint && 
            !isLargeDesktop;
        
        return builder(
          context, 
          isMobile, 
          isTablet, 
          isDesktop,
          isLargeDesktop,
        );
      },
    );
  }
}

// Responsive layout widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        if (width >= ResponsiveUtils.largeDesktopBreakpoint) {
          return largeDesktop ?? desktop ?? tablet ?? mobile;
        } else if (width >= ResponsiveUtils.desktopBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (width >= ResponsiveUtils.mobileBreakpoint) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
