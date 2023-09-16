import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surelight/models/settings_model.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  late SharedPreferences prefs;

  Future _init() async {
    prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("settings");

    if (data != null) {
      Settings settings = Settings.fromJson(jsonDecode(data));
      state = settings;
    }
  }

  SettingsNotifier() : super(Settings()) {
    _init();
  }
  void set(Settings settings) async {
    prefs.setString("settings", jsonEncode(settings.toJson()));
    state = settings;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);
