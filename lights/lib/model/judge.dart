class Judge {
  final String id;
  final String role;

  const Judge({
    required this.id,
    required this.role,
  });

  factory Judge.fromJson(Map<String, dynamic> json) {
    return Judge(
      id: json['id'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
    };
  }
}
