import 'package:flutter/widgets.dart';

class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeIn({
    Key key,
    @required this.child,
    this.duration = const Duration(milliseconds: 500),
  })  : assert(child != null),
        super(key: key);

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
