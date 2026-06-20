import 'package:flutter/material.dart';

class SliderListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final ValueChanged<double>? onChanged;

  const SliderListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.secondary,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: title,
          subtitle: subtitle,
          leading: secondary,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: label,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
