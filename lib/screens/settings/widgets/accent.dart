import "package:flutter/material.dart";
import '../../../services/settings.dart' as settings;

Widget buildAccentColorPicker(BuildContext context) {
  final s = settings.SettingsService();

  final List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    s.systemAccentColor,
  ];

  return Padding(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Akzentfarbe',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: colors.map((color) {
              final isSelected = s.accentColor == color;
              return GestureDetector(
                onTap: () {
                  s.updateAccentColor(color);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                    boxShadow: isSelected
                        ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8, offset: const Offset(0, 2))]
                        : [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 1))],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 22)
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}
