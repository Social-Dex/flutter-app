import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermoji.dart';

class UserAvatar extends StatelessWidget {
  final double scale;
  final String svg;
  final Color statusColor;
  final Function onPress;
  final Color backgroundColor;

  const UserAvatar({
    super.key,
    this.scale = 1,
    this.svg = '',
    this.backgroundColor = Colors.transparent,
    required this.statusColor,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 116 * scale,
          height: 116 * scale,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4 * scale),
          child: Container(
            width: 108 * scale,
            height: 108 * scale,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        svg != ''
            ? Padding(
                padding: EdgeInsets.all(16 * scale),
                child: SizedBox(
                  width: 80 * scale,
                  height: 80 * scale,
                  child: SvgPicture.string(
                      FluttermojiFunctions().decodeFluttermojifromString(svg)),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(8 * scale),
                child: FluttermojiCircleAvatar(
                  radius: 50 * scale,
                  backgroundColor: Colors.transparent,
                ),
              ),
        TextButton(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(4 * scale)),
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          ),
          onPressed: () => onPress(),
          child: Container(
            width: 108 * scale,
            height: 108 * scale,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
