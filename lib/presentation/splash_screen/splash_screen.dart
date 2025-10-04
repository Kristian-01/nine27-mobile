import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../routes/app_routes.dart';
import '../welcome_screen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _logoRotation;
  late Animation<double> _logoScale;
  
  // Text animations
  late AnimationController _textController;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  
  // Progress indicator
  double _progress = 0.0;
  bool _navigated = false;
  Timer? _progressTimer;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize main animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Background pulse animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // Logo rotation animation
    _logoRotation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );
    
    // Logo scale animation
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    
    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Text fade animation
    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );
    
    // Text slide animation
    _textSlide = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutQuad,
      ),
    );
    
    // Start animations
    _controller.forward();
    
    // Delay text animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _textController.forward();
      }
    });
    
    // Smooth progress animation
    _startProgressAnimation();
    
    // Navigate after delay
    _scheduleNavigation();
  }
  
  void _startProgressAnimation() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
        }
      });
    });
  }
  
  void _scheduleNavigation() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted || _navigated) return;
      _navigateToNextScreen();
    });
  }
  
  void _navigateToNextScreen() {
    if (_navigated || !mounted) return;
    
    setState(() {
      _navigated = true;
    });
    
    // Use pushReplacement instead of pushReplacementNamed for more reliability
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }
  
  @override
  void dispose() {
    _progressTimer?.cancel();
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value * 0.5,
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF00E676),
                                  Color(0xFF00C853),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00C853).withAlpha(77),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                  spreadRadius: 2 + _backgroundAnimation.value * 3,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Nine27Logo(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              // Animated Text
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _textSlide.value),
                    child: Opacity(
                      opacity: _textFade.value,
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF00E676),
                                Color(0xFF00C853),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'Nine27-Pharmacy',
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Your Trusted Healthcare Partner',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress indicator
                      SizedBox(
                        width: 60.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF00C853),
                            ),
                            minHeight: 1.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF00C853),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Nine27 Logo Widget
class Nine27Logo extends StatelessWidget {
  const Nine27Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Heart base
        Positioned.fill(
          child: CustomPaint(
            painter: HeartPainter(),
          ),
        ),
        // Medicine capsule
        Positioned(
          top: 25,
          left: 30,
          child: Transform.rotate(
            angle: 0.785398, // 45 degrees
            child: Container(
              width: 45,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create heart shape path
    final width = size.width;
    final height = size.height;
    
    // Start from bottom point
    path.moveTo(width * 0.5, height * 0.85);
    
    // Left curve
    path.cubicTo(
      width * 0.15, height * 0.6,
      width * 0.15, height * 0.25,
      width * 0.35, height * 0.25,
    );
    
    // Top left curve
    path.cubicTo(
      width * 0.45, height * 0.15,
      width * 0.55, height * 0.15,
      width * 0.65, height * 0.25,
    );
    
    // Right curve
    path.cubicTo(
      width * 0.85, height * 0.25,
      width * 0.85, height * 0.6,
      width * 0.5, height * 0.85,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}