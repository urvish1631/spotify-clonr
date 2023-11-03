import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';

class ControlWidget extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const ControlWidget({Key? key, required this.audioPlayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (!(playing ?? false)) {
          if (processingState == ProcessingState.loading) {
            return Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
              child: IconButton(
                onPressed: () => {},
                color: whiteColor,
                icon: const Padding(
                  padding: EdgeInsets.all(7.0),
                  child: CircularProgressIndicator(
                    color: whiteColor,
                  ),
                ),
              ),
            );
          } else {
            return Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
              child: IconButton(
                onPressed: audioPlayer.play,
                color: whiteColor,
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  size: 50,
                ),
              ),
            );
          }
        } else if (processingState != ProcessingState.completed) {
          return Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: IconButton(
              onPressed: audioPlayer.pause,
              color: whiteColor,
              icon: const Icon(
                Icons.pause,
                size: 50,
              ),
            ),
          );
        }
        return Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor,
          ),
          child: IconButton(
            onPressed: audioPlayer.play,
            color: whiteColor,
            icon: const Icon(
              Icons.play_arrow_rounded,
              size: 50,
            ),
          ),
        );
      },
    );
  }
}
