import 'package:flutter/material.dart';

class IsHover extends StatefulWidget {
  final Widget child;
  final Color hoverColor;
  final VoidCallback? onTap;
  final double borderRadius; // Border radius as double

  const IsHover({
    Key? key,
    required this.child,
    this.hoverColor =  const Color.fromARGB(28, 130, 130, 130),
    this.onTap,
    this.borderRadius = 0.0, // Default value for border radius
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
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius), // Use BorderRadius.circular
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
