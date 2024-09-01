import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class EventButton extends StatelessWidget {
  final VoidCallback callback;
  final String? text, tooltip;
  final double? minWidth, height, borderRadius;
  final Widget? child;

  const EventButton({
    super.key,
    required this.callback,
    this.text,
    this.tooltip,
    this.minWidth,
    this.height,
    this.borderRadius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? "",
      child: MaterialButton(
        onPressed: () async {
          AssetSource source = AssetSource("audio/tap.mp3");
          await AudioPlayer().play(source);
          callback();
        },
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        minWidth: minWidth ?? ButtonTheme.of(context).minWidth,
        height: height ?? ButtonTheme.of(context).height,
        color: Theme.of(context).colorScheme.secondary,
        child: text != null
            ? Text(text!,
                style: Theme.of(context)
                    .primaryTextTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.tertiary))
            : child,
      ),
    );
  }
}
