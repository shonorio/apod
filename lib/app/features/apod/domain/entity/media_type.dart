enum MediaType {
  image('image'),
  video('video');

  const MediaType(this.value);
  final String value;

  factory MediaType.fromString(String value) {
    return MediaType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Invalid media type: $value'),
    );
  }
}
