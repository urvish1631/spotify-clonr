class PositionData {
  final Duration position;
  final Duration duration;
  final Duration bufferPosition;

  const PositionData(
    this.position,
    this.duration,
    this.bufferPosition,
  );
}

class AudioObject {
  final String title, subtitle, img;

  const AudioObject(this.title, this.subtitle, this.img);
}
