class Meet {
  final String id;
  final String name;
  final String password;
  final bool enableOtherLightColors;

  Meet({
    required this.id,
    required this.name,
    required this.password,
    required this.enableOtherLightColors,
  });

  factory Meet.fromJson(Map<String, dynamic> json) {
    return Meet(
      id: json['id'],
      name: json['name'],
      password: json['password'],
      enableOtherLightColors: json['enableOtherLightColors'],
    );
  }
}
