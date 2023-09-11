import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/services/artnet.dart';

final artNetProvider = Provider<ArtNet>((ref) => ArtNet());
