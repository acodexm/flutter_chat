import 'package:flutter/widgets.dart';

class ShowHide extends StatefulWidget {
  final Widget child;
  final bool showing;

  /// How long it takes to show/hide
  final Duration duration;

  ShowHide({
    Key key,
    @required this.child,
    this.duration = const Duration(milliseconds: 200),
    @required this.showing,
  })  : assert(child != null),
        super(key: key);

  @override
  _ShowHideState createState() => _ShowHideState();
}

class _ShowHideState extends State<ShowHide>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showing) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    return SizeTransition(
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}
