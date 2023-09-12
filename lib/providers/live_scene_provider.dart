import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/services/live_scene_service.dart';

final liveSceneProvider = StateNotifierProvider<LiveScene, LiveSceneSettings>((ref) {
  return LiveScene(ref);
});