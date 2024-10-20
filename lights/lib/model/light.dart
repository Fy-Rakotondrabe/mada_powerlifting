class Light {
  final String judgeRole;
  final int value;

  Light({
    required this.judgeRole,
    required this.value,
  });

  factory Light.fromJson(Map<String, dynamic> json) {
    return Light(
      judgeRole: json['judgeRole'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judgeRole': judgeRole,
      'value': value,
    };
  }
}
