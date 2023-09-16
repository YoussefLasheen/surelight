import 'package:surelight/models/fixture/fixture_data.dart';

class Fixture {
  final String id;
  final String name;
  final int startingChannel;
  final FixtureData data;

  Fixture(
      {required this.name,
      required this.id,
      required this.startingChannel,
      required this.data});
}
