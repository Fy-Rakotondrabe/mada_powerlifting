class Meet {
  final int? id;
  final String name;
  final bool enableOtherLightColors;
  final DateTime startDateTime;
  final DateTime? exitDateTime;

  Meet({
    this.id,
    required this.name,
    required this.enableOtherLightColors,
    required this.startDateTime,
    this.exitDateTime,
  });

  factory Meet.fromJson(Map<String, dynamic> json) {
    return Meet(
      id: json['id'],
      name: json['name'],
      enableOtherLightColors:
          json['enableOtherLightColors'] == 1 ? true : false,
      startDateTime: DateTime.parse(json['startDateTime']),
      exitDateTime: json['exitDateTime'] != null
          ? DateTime.parse(json['exitDateTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'enableOtherLightColors': enableOtherLightColors ? 1 : 0,
      'startDateTime': startDateTime.toIso8601String(),
      'exitDateTime': exitDateTime?.toIso8601String(),
    };
  }

  Meet copyWith({
    int? id,
    String? name,
    bool? enableOtherLightColors,
    DateTime? startDateTime,
    DateTime? exitDateTime,
  }) {
    return Meet(
      id: id ?? this.id,
      name: name ?? this.name,
      enableOtherLightColors:
          enableOtherLightColors ?? this.enableOtherLightColors,
      startDateTime: startDateTime ?? this.startDateTime,
      exitDateTime: exitDateTime ?? this.exitDateTime,
    );
  }
}
