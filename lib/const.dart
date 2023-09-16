import 'package:surelight/models/fixture/basic_light_fixture.dart';
import 'package:surelight/models/fixture/fixture_data.dart';

FixtureData basicFixture = BasicLightFixture(
  name: 'Basic Light',
  numberOfChannels: 8,
  redOffset: 0,
  greenOffset: 1,
  blueOffset: 2,
  dimmerOffset: 3,
  strobeOffset: 4,
);


FixtureData RGBD = BasicLightFixture(
  name: 'RGBD',
  numberOfChannels: 4,
  redOffset: 0,
  greenOffset: 1,
  blueOffset: 2,
  dimmerOffset: 3,
);

FixtureData DRGB = BasicLightFixture(
  name: 'DRGB',
  numberOfChannels: 4,
  redOffset: 0,
  greenOffset: 1,
  blueOffset: 2,
  dimmerOffset: 3,
);