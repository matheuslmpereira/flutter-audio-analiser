import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/colors.dart';

class VerticalRuler extends StatefulWidget {
  final double factor;
  final Color baseColor;
  final Color tunedColor;

  const VerticalRuler({
    Key? key,
    required this.factor,
    this.baseColor = Colors.black,
    this.tunedColor = successGreen
  }) : super(key: key);

  @override
  _VerticalRulerState createState() => _VerticalRulerState();
}

class _VerticalRulerState extends State<VerticalRuler>
    with TickerProviderStateMixin {
  late AnimationController _cursorController;
  late Animation<double> _cursorAnimation;
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: widget.baseColor,
      end: widget.tunedColor,
    ).animate(_colorController);

    _cursorController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _cursorAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(_cursorController);
  }

  @override
  void didUpdateWidget(covariant VerticalRuler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.factor != widget.factor) {
      if (widget.factor == 0) {
        _colorController.forward();
      } else {
        _colorController.reverse();
      }

      _cursorAnimation = Tween<double>(
        begin: _cursorAnimation.value,
        end: -widget.factor,
      ).animate(_cursorController);

      _cursorController
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _colorController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _cursorAnimation,
        builder: (context, child) {
          return Container(
            width: 60,
            height: 200,
            decoration: BoxDecoration(
                border: Border.all(color: _colorAnimation.value!, width: 2),
                borderRadius: BorderRadius.circular(5),
                color: componentBackground
            ),
            child: Stack(
              children: [
                ..._buildFadingLines(),
                CursorWidget(cursorAnimation: _cursorAnimation, colorAnimation: _colorAnimation),
                Align(
                  alignment: const Alignment(-1, 0),
                  child: _buildTriangle(),
                ),
                Align(
                  alignment: const Alignment(1, 0),
                  child: Transform.rotate(
                    angle: pi,
                    child: _buildTriangle(),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildTriangle() {
    return SizedBox(
      width: 10,
      height: 10,
      child: Transform.rotate(
        angle: -pi / 2,
        child: ClipPath(
          clipper: TriangleClipper(),
          child: Container(
            width: 10,
            height: 20,
            color: widget.baseColor,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFadingLines() {
    List<Widget> lines = [];
    int totalLinesAbove = 10;
    int totalLinesBelow = 10;

    for (int i = 0; i <= totalLinesAbove; i++) {
      double alignmentValue = -(i / (totalLinesAbove));
      double opacity = 1 - (i / (totalLinesAbove + 1));

      lines.add(
        Align(
          alignment: Alignment(0, alignmentValue),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 20,
              height: 2,
              color: widget.baseColor,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i <= totalLinesBelow; i++) {
      double alignmentValue = i / (totalLinesBelow);
      double opacity = 1 - (i / (totalLinesBelow + 1));

      lines.add(
        Align(
          alignment: Alignment(0, alignmentValue),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 20,
              height: 2,
              color: widget.baseColor,
            ),
          ),
        ),
      );
    }

    return lines;
  }
}

class CursorWidget extends StatelessWidget {
  const CursorWidget({
    super.key,
    required Animation<double> cursorAnimation,
    required Animation<Color?> colorAnimation,
  }) : _cursorAnimation = cursorAnimation, _colorAnimation = colorAnimation;

  final Animation<double> _cursorAnimation;
  final Animation<Color?> _colorAnimation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, _cursorAnimation.value),
      child: Container(
        width: 40,
        height: 4,
        color: _colorAnimation.value,
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
