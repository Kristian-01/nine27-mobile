// lib/routes/route_transition_helper.dart
import 'package:flutter/material.dart';

/// A helper class that provides route transitions without blank screens
class RouteTransitionHelper {
  /// Creates a route with a smooth slide transition
  static Route<dynamic> createRoute(Widget page, {Duration? transitionDuration}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutQuad;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        
        // Keep previous screen visible until new one slides in
        return Stack(
          children: [
            // Previous screen remains visible
            Opacity(
              opacity: 1.0,
              child: Container(color: Theme.of(context).scaffoldBackgroundColor),
            ),
            // New screen slides in
            SlideTransition(
              position: offsetAnimation,
              child: child,
            ),
          ],
        );
      },
      // Faster transition to prevent white screen perception
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 250),
      // Maintain previous route until new one is fully loaded
      maintainState: true,
      opaque: false,
    );
  }
  
  /// Creates a route with a fade transition
  static Route<dynamic> createFadeRoute(Widget page, {Duration? transitionDuration}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      // Faster transition to prevent white screen perception
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 200),
      // Maintain previous route until new one is fully loaded
      maintainState: true,
      opaque: false,
    );
  }
}