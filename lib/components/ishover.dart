import 'package:flutter/material.dart';

class IsHover extends StatefulWidget {
  final Widget child;
  final Color hoverColor;
  final VoidCallback? onTap;

  const IsHover({
    Key? key,
    required this.child,
    this.hoverColor = Colors.black12,
    this.onTap,
  }) : super(key: key);

  @override
  _IsHoverState createState() => _IsHoverState();
}

class _IsHoverState extends State<IsHover> {
  Color _backgroundColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _backgroundColor = widget.hoverColor;
        });
      },
      onExit: (_) {
        setState(() {
          _backgroundColor = Colors.transparent;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: _backgroundColor,
          child: widget.child,
        ),
      ),
    );
  }
}
