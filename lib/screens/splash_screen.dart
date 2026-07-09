import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../main.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;
  bool _navigated = false;
  bool _videoReady = false;
  bool _videoFailed = false;

  static const _bg = Color(0xFF090A07);

  @override
  void initState() {
    super.initState();
    _initVideo();

    // Safety timeout — navigate after 8s no matter what
    Future.delayed(const Duration(seconds: 8), () {
      if (!_navigated && mounted) _navigate();
    });
  }

  Future<void> _initVideo() async {
    try {
      // Use asset() on all platforms — Flutter's asset bundle handles the
      // correct resolution path, including on web.
      final ctrl = VideoPlayerController.asset('assets/video/splash.mp4');
      _controller = ctrl;

      await ctrl.initialize();
      if (!mounted) return;

      ctrl.setVolume(1.0);
      ctrl.addListener(_onVideoProgress);

      setState(() => _videoReady = true);
      await ctrl.play();
    } catch (e) {
      debugPrint('[SplashScreen] Video init failed: $e');
      if (!mounted) return;
      setState(() => _videoFailed = true);
      // Navigate after a brief pause so the user sees something
      Future.delayed(const Duration(seconds: 2), () {
        if (!_navigated && mounted) _navigate();
      });
    }
  }

  void _onVideoProgress() {
    if (_navigated) return;
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return;

    // Trigger rebuild so the VideoPlayer platform view stays in sync
    if (mounted) setState(() {});

    final pos = ctrl.value.position;
    final dur = ctrl.value.duration;

    if (dur > Duration.zero &&
        pos >= dur - const Duration(milliseconds: 300)) {
      _navigated = true;
      _navigate();
    }
  }

  void _navigate() {
    if (!mounted) return;
    _navigated = true;

    final destination = AuthService.isLoggedIn
        ? const MainShell()
        : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => destination,
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoProgress);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: GestureDetector(
        onTap: () {
          // Tap to skip
          if (!_navigated) _navigate();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_videoReady && _controller != null)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  // Use known video dimensions as fallback — avoids the
                  // zero-size flash that happens when the web platform
                  // view hasn't reported its intrinsic size yet.
                  child: SizedBox(
                    width: _controller!.value.size.width > 0
                        ? _controller!.value.size.width
                        : 720,
                    height: _controller!.value.size.height > 0
                        ? _controller!.value.size.height
                        : 1280,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),

            // Show loading or error state
            if (!_videoReady)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/app_logo.png',
                      width: 120,
                      height: 120,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    if (_videoFailed)
                      const Text('GHOST PROTOCOL',
                          style: TextStyle(
                              color: Color(0xFFA8FF00),
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4.0))
                    else
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFA8FF00),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
