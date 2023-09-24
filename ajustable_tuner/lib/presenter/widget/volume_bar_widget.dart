import 'package:flutter/material.dart';
import '../../core/colors.dart';

class VolumeBarWidget extends StatefulWidget {
  final double volume;
  final double width;
  final double baseHeight;
  final double maxBarHeight;
  final Duration animationDuration;
  final Color backgroundColor;
  final List<Color> barColors;

  const VolumeBarWidget({
    Key? key,
    required this.volume,
    this.width = 12.0,
    this.baseHeight = 50.0,
    this.maxBarHeight = 50.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.backgroundColor = componentBackground,
    this.barColors = const [
      comfortAudioColor,
      heavyNoiseColor,
    ],
  }) : super(key: key);

  @override
  _VolumeBarWidgetState createState() => _VolumeBarWidgetState();
}

class _VolumeBarWidgetState extends State<VolumeBarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _heightController;
  late Animation<double> _heightAnimation;
  late LinearGradient _gradient;

  @override
  void initState() {
    super.initState();
    _gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: widget.barColors,
        stops: const [0.7, 1]
    );

    _heightController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: 0,
      end: widget.volume * widget.maxBarHeight,
    ).animate(_heightController);

    _heightController.forward();
  }

  @override
  void didUpdateWidget(covariant VolumeBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.volume != widget.volume) {
      _heightAnimation = Tween<double>(
        begin: _heightAnimation.value,
        end: widget.volume * widget.maxBarHeight,
      ).animate(_heightController);

      _heightController
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: SizedBox(
            width: widget.width,
            height: widget.baseHeight,
            child: Container(
              decoration: BoxDecoration(
                gradient: _gradient,
              ),
              child: _buildInvertedVolumeColumn(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvertedVolumeColumn() {
    return Column(
      children: [
        Container(
          color: componentBackground,
          height: widget.baseHeight - _heightAnimation.value,
          width: widget.width,
        ),
        Container(
          height: _heightAnimation.value,
          width: widget.width,
          color: Colors.transparent,
        ),
      ],
    );
  }
}
