import 'fixture_data.dart';

class BasicLightFixture extends FixtureData {
  final int redOffset;
  final int greenOffset;
  final int blueOffset;
  final int dimmerOffset;
  final int strobeOffset;

  BasicLightFixture({
    required this.redOffset,
    required this.greenOffset,
    required this.blueOffset,
    required this.dimmerOffset,
    required this.strobeOffset,
    required super.numberOfChannels,
    required super.name,
  });
}
