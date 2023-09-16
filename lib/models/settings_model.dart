class Settings {
  final String ip;

  Settings({
    this.ip = '192.168.1.100',
  });

  Settings copyWith({
    String? ip,
  }) {
    return Settings(
      ip: ip ?? this.ip,
    );
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      ip: json['ip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
    };
  }
}
