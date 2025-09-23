import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
    _checkAuthStatus();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Text animations  
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Pulse animation for logo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo scale animation
    _logoScale = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo rotation animation
    _logoRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
    ));

    // Text fade animation
    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Text slide animation
    _textSlide = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() {
    // Start logo animation
    _logoController.forward();
    
    // Start text animation after delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _textController.forward();
      }
    });

    // Start pulse animation after logo animation
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    // Show splash for at least 3 seconds for better UX
    await Future.delayed(const Duration(seconds: 3));
    
    try {
      final authService = AuthService();
      await authService.initializeAuth();
      
      final token = await authService.getToken();
      final isRememberMeEnabled = await authService.isRememberMeEnabled();
      
      if (token != null && token.isNotEmpty && isRememberMeEnabled) {
        // Token exists and remember me is enabled, verify it's still valid
        final response = await authService.getProfile();
        
        if (response.success) {
          // Valid token, user is logged in
          _navigateToHome();
        } else {
          // Invalid token, go to login
          _navigateToLogin();
        }
      } else {
        // No token or remember me disabled, go to login
        _navigateToLogin();
      }
    } catch (e) {
      // Error occurred, go to login safely
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF00E676).withOpacity(0.1),
              Colors.white,
              const Color(0xFF00C853).withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: Listenable.merge([_logoController, _pulseController]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScale.value * _pulseAnimation.value,
                    child: Transform.rotate(
                      angle: _logoRotation.value * 0.5,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF00E676),
                              const Color(0xFF00C853),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00C853).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
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
                          Text(
                            'Nine27-Pharmacy',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Your Trusted Healthcare Partner',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 10.h),

              // Loading indicator
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFade.value,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 8.w,
                          height: 8.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF00C853),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
                    color: Colors.black.withOpacity(0.1),
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