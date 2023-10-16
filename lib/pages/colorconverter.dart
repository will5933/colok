import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class ColorConverter extends StatefulWidget {
  const ColorConverter({
    super.key,
  });

  @override
  State<ColorConverter> createState() => _ColorConverterState();
}

class _ColorConverterState extends State<ColorConverter> {
  Container createInputCard({
    required TextEditingController controller,
    required int labelindex,
    required String hintText,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(36, 4, 36, 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          enabled: _labelListSupport.contains(_labelList[labelindex]),
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy_rounded),
              onPressed: () {
                if (controller.text == '') return;
                Clipboard.setData(ClipboardData(text: controller.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${controller.text}" Copied!'),
                  ),
                );
              },
            ),
            contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            filled: true,
            labelText: _labelList[labelindex],
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (str) {
            if (str != '') _convertColor(labelindex, str);
          },
        ),
      ),
    );
  }

  final TextEditingController _hex = TextEditingController();
  final TextEditingController _rgb = TextEditingController();
  final TextEditingController _hsl = TextEditingController();
  final TextEditingController _hsv = TextEditingController();
  final TextEditingController _hwb = TextEditingController();
  final TextEditingController _lch = TextEditingController();
  final TextEditingController _lab = TextEditingController();

  // getRGB
  RGB? _getRGB(String str) {
    final RegExpMatch? match = RegExp(
      r'[rR][gG][bB][aA]?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,?\s*([01].?\d*)?\)',
    ).firstMatch(str);
    if (match == null) return null;
    final int r = int.parse(match[1]!);
    final int g = int.parse(match[2]!);
    final int b = int.parse(match[3]!);
    double? a = double.tryParse(match[4] ?? '');
    if (r > 255 || g > 255 || b > 255) return null;
    if (a != null && a > 1) return null;
    return a != null ? RGB(r: r, g: g, b: b, a: a) : RGB(r: r, g: g, b: b);
  }

  // rgb2hex
  String? _rgb2hex(String str) {
    final RGB c = _getRGB(str)!;
    final bool hasAlpha = c.a != null;
    String toHEX(int num) {
      final String str = num.toRadixString(16);
      return str.length == 1 ? '0$str' : str;
    }

    return (hasAlpha
            ? '#${toHEX(c.r)}${toHEX(c.g)}${toHEX(c.b)}${hasAlpha ? toHEX((c.a! * 255).round()) : ''}'
            : '#${toHEX(c.r)}${toHEX(c.g)}${toHEX(c.b)}')
        .toUpperCase();
  }

  // hex2rgb
  String? _hex2rgb(String str) {
    final RegExpMatch? match = RegExp(
      r'#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})?',
    ).firstMatch(str);
    if (match == null) return null;

    final int r = int.parse(match[1]!, radix: 16);
    final int g = int.parse(match[2]!, radix: 16);
    final int b = int.parse(match[3]!, radix: 16);
    final int? a = int.tryParse(match[4] ?? '', radix: 16);
    return 'RGB($r, $g, $b${a != null ? ', ${(a / 255).toStringAsFixed(1)}' : ''})';
  }

  // rgb2hsv
  String? _rgb2hsv(String str) {
    final RGB c = _getRGB(str)!;
    final bool hasAlpha = c.a != null;

    final double r = c.r / 255;
    final double g = c.g / 255;
    final double b = c.b / 255;

    final double maxNum = [r, g, b].reduce(max);
    final double minNum = [r, g, b].reduce(min);
    final double delta = maxNum - minNum;
    final int hue;
    final double sat;

    if (delta == 0) {
      hue = 0;
    } else if (maxNum == r) {
      hue = g >= b
          ? (60 * (g - b) / delta).round()
          : (60 * (g - b) / delta + 360).round();
    } else if (maxNum == g) {
      hue = (60 * (b - r) / delta + 120).round();
    } else {
      hue = (60 * (r - g) / delta + 240).round();
    }
    sat = maxNum == 0 ? 0 : delta / maxNum;
    return hasAlpha
        ? 'HSV($hue, ${sat.toStringAsFixed(2)}, ${maxNum.toStringAsFixed(2)}, ${c.a})'
        : 'HSV($hue, ${sat.toStringAsFixed(2)}, ${maxNum.toStringAsFixed(2)})';
  }

  // hsv2rgb
  String? _hsv2rgb(String str) {
    final RegExpMatch? match = RegExp(
      r'[Hh][Ss][Vv][Aa]?\(\s*(\d+)d?e?g?\s*,\s*([01].?\d*)\s*,\s*([01].?\d*)\s*,?\s*([01].?\d*)?\)',
    ).firstMatch(str);
    if (match == null) return null;

    final int h = int.parse(match[1]!);
    final double s = double.parse(match[2]!);
    final double v = double.parse(match[3]!);
    double? a = double.tryParse(match[4] ?? '');
    if (h >= 360 || s > 1 || v > 1) return null;
    if (a != null && a > 1) return null;

    double c = v * s;
    double x = c * (1 - ((h / 60) % 2 - 1).abs());
    double m = v - c;

    double r;
    double g;
    double b;
    [r, g, b] = (0 <= h && h < 60)
        ? [c, x, 0]
        : (60 <= h && h < 120)
            ? [x, c, 0]
            : (120 <= h && h < 180)
                ? [0, c, x]
                : (180 <= h && h < 240)
                    ? [0, x, c]
                    : (240 <= h && h < 300)
                        ? [x, 0, c]
                        : [c, 0, x];
    [r, g, b] = [(r + m) * 255, (g + m) * 255, (b + m) * 255];
    return 'RGB(${r.round()}, ${g.round()}, ${b.round()}${a != null ? ', $a' : ''})';
  }

  // rgb2hsl
  String? _rgb2hsl(String str) {
    final RGB c = _getRGB(str)!;
    final bool hasAlpha = c.a != null;

    final double r = c.r / 255;
    final double g = c.g / 255;
    final double b = c.b / 255;

    final double maxNum = [r, g, b].reduce(max);
    final double minNum = [r, g, b].reduce(min);
    final double delta = maxNum - minNum;
    final int hue;
    final double sat;
    final double lig = (maxNum + minNum) / 2;

    if (delta == 0) {
      hue = 0;
    } else if (maxNum == r) {
      hue = g >= b
          ? (60 * (g - b) / delta).round()
          : (60 * (g - b) / delta + 360).round();
    } else if (maxNum == g) {
      hue = (60 * (b - r) / delta + 120).round();
    } else {
      hue = (60 * (r - g) / delta + 240).round();
    }
    sat = delta == 0 ? 0 : delta / (1 - (2 * lig - 1).abs());
    return hasAlpha
        ? 'HSL($hue, ${sat.toStringAsFixed(2)}, ${lig.toStringAsFixed(2)}, ${c.a})'
        : 'HSL($hue, ${sat.toStringAsFixed(2)}, ${lig.toStringAsFixed(2)})';
  }

  // hsl2rgb
  String? _hsl2rgb(String str) {
    final RegExpMatch? match = RegExp(
      r'[Hh][Ss][Ll][Aa]?\(\s*(\d+)d?e?g?\s*,\s*([01].?\d*)\s*,\s*([01].?\d*)\s*,?\s*([01].?\d*)?\)',
    ).firstMatch(str);
    if (match == null) return null;

    final int h = int.parse(match[1]!);
    final double s = double.parse(match[2]!);
    final double l = double.parse(match[3]!);
    double? a = double.tryParse(match[4] ?? '');
    if (h >= 360 || s > 1 || l > 1) return null;
    if (a != null && a > 1) return null;

    double c = (1 - (2 * l - 1).abs()) * s;
    double x = c * (1 - ((h / 60) % 2 - 1).abs());
    double m = l - c / 2;

    double r;
    double g;
    double b;
    [r, g, b] = (0 <= h && h < 60)
        ? [c, x, 0]
        : (60 <= h && h < 120)
            ? [x, c, 0]
            : (120 <= h && h < 180)
                ? [0, c, x]
                : (180 <= h && h < 240)
                    ? [0, x, c]
                    : (240 <= h && h < 300)
                        ? [x, 0, c]
                        : [c, 0, x];
    [r, g, b] = [(r + m) * 255, (g + m) * 255, (b + m) * 255];
    return 'RGB(${r.round()}, ${g.round()}, ${b.round()}${a != null ? ', $a' : ''})';
  }

  // rgb2hwb
  String? _rgb2hwb(String str) {
    final RGB c = _getRGB(str)!;
    final bool hasAlpha = c.a != null;

    final double r = c.r / 255;
    final double g = c.g / 255;
    final double b = c.b / 255;

    final double maxNum = [r, g, b].reduce(max);
    final double minNum = [r, g, b].reduce(min);
    final double delta = maxNum - minNum;
    final int hue;
    final String white = minNum.toStringAsFixed(2);
    final String black = (1 - maxNum).toStringAsFixed(2);

    if (delta == 0) {
      hue = 0;
    } else if (maxNum == r) {
      hue = g >= b
          ? (60 * (g - b) / delta).round()
          : (60 * (g - b) / delta + 360).round();
    } else if (maxNum == g) {
      hue = (60 * (b - r) / delta + 120).round();
    } else {
      hue = (60 * (r - g) / delta + 240).round();
    }

    return hasAlpha
        ? 'HWB($hue, $white, $black, ${c.a})'
        : 'HWB($hue, $white, $black)';
  }

  // hwb2rgb
  String? _hwb2rgb(String value) {
    final RegExpMatch? match = RegExp(
      r'[Hh][Ww][Bb][Aa]?\(\s*(\d+)d?e?g?\s*,\s*([01].?\d*)\s*,\s*([01].?\d*)\s*,?\s*([01].?\d*)?\)',
    ).firstMatch(value);
    if (match == null) return null;

    final int hue = int.parse(match[1]!);
    final double white = double.parse(match[2]!);
    final double black = double.parse(match[3]!);
    double? a = double.tryParse(match[4] ?? '');
    if (hue >= 360 || white > 1 || black > 1 || white + black > 1) return null;
    if (a != null && a > 1) return null;

    final double r, g, b;
    if (hue == 0) {
      r = g = b = white;
    } else {
      final double max = 1 - black;
      final double min = white;
      final double delta = max - min;
      switch (hue) {
        case <= 60:
          [r, g, b] = [max, hue * delta / 60 + min, min];
          break;
        case <= 120:
          [g, r, b] = [max, (120 - hue) * delta / 60 + min, min];
          break;
        case <= 180:
          [g, b, r] = [max, (hue - 120) * delta / 60 + min, min];
          break;
        case <= 240:
          [b, g, r] = [max, (240 - hue) * delta / 60 + min, min];
          break;
        case <= 300:
          [b, r, g] = [max, (hue - 240) * delta / 60 + min, min];
          break;
        case < 360:
          [r, b, g] = [max, (360 - hue) * delta / 60 + min, min];
          break;
        default:
          [r, g, b] = [0, 0, 0];
      }
    }

    return 'RGB(${(r * 255).round()}, ${(g * 255).round()}, ${(b * 255).round()}${a != null ? ', $a' : ''})';
  }

  final List<String> _labelList = [
    'RGB',
    'HEX',
    'HSV',
    'HSL',
    'HWB',
    'LCH',
    'LAB',
  ];
  final List<String> _labelListSupport = [
    'RGB',
    'HEX',
    'HSV',
    'HSL',
    'HWB',
    // 'LCH',
    // 'LAB',
  ];

  void _convertColor(int index, String str) {
    final Map<String, List<Function>> fnList = {
      'HEX': [_rgb2hex, _hex2rgb],
      'HSV': [_rgb2hsv, _hsv2rgb],
      'HSL': [_rgb2hsl, _hsl2rgb],
      'HWB': [_rgb2hwb, _hwb2rgb],
      // 'LCH': [_rgb2lch, _lch2rgb],
      // 'LAB': [_rgb2lab, _lab2rgb],
    };
    void updateAll() {
      if (index != 1) _hex.text = _rgb2hex(_rgb.text)!;
      if (index != 2) _hsv.text = _rgb2hsv(_rgb.text)!;
      if (index != 3) _hsl.text = _rgb2hsl(_rgb.text)!;
      if (index != 4) _hwb.text = _rgb2hwb(_rgb.text)!;
    }

    void cleanAll() {
      if (index != 0) _rgb.text = '';
      if (index != 1) _hex.text = '';
      if (index != 2) _hsv.text = '';
      if (index != 3) _hsl.text = '';
      if (index != 4) _hwb.text = '';
    }

    if (index != 0 && fnList[_labelList[index]]![1](str) != null) {
      str = _rgb.text = fnList[_labelList[index]]![1](str);
    }
    _getRGB(str) != null ? updateAll() : cleanAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            createInputCard(
              controller: _rgb,
              labelindex: 0,
              hintText: 'RGB(R, G, B, (A))',
            ),
            createInputCard(
              controller: _hex,
              labelindex: 1,
              hintText: '#RRGGBB(AA)',
            ),
            createInputCard(
              controller: _hsv,
              labelindex: 2,
              hintText: 'HSV(H, S, V, (A))',
            ),
            createInputCard(
              controller: _hsl,
              labelindex: 3,
              hintText: 'HSL(H, S, L, (A))',
            ),
            createInputCard(
              controller: _hwb,
              labelindex: 4,
              hintText: 'HWB(H, W, B, (A))',
            ),
            createInputCard(
              controller: _lch,
              labelindex: 5,
              hintText: 'LCH(L, C, H, (A))',
            ),
            createInputCard(
              controller: _lab,
              labelindex: 6,
              hintText: 'LAB(L, A, B, (A))',
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(36, 4, 36, 4),
              child: Card(
                // color: Theme.of(context).colorScheme.surfaceVariant,
                // shadowColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alpha: [0, 1]'),
                      Text(
                          'Value, Saturation, Lightness, White, Black: [0, 1]'),
                      Text('Hue: [0, 360)'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RGB {
  final int r;
  final int g;
  final int b;
  final double? a;

  RGB({
    required this.r,
    required this.g,
    required this.b,
    this.a,
  });
}
