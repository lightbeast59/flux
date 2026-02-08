import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FluxLogo extends StatelessWidget {
  final double height;

  const FluxLogo({
    super.key,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/flux_logo.svg',
      height: height,
      fit: BoxFit.contain,
    );
  }
}
