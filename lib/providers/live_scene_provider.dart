import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/services/live_scene_service.dart';

final liveSceneProvider = Provider<LiveScene>((ref) {
  return LiveScene(ref);
});