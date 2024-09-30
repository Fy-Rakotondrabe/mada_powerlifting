class Light {
  final String judgeId;
  final String value;

  Light({
    required this.judgeId,
    required this.value,
  });

  factory Light.fromJson(Map<String, dynamic> json) {
    return Light(
      judgeId: json['judgeId'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judgeId': judgeId,
      'value': value,
    };
  }
}
