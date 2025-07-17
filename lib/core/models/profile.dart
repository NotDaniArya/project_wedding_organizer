class Profile {
  Profile({
    required this.id,
    required this.full_name,
    required this.email,
    required this.no_hp,
  });

  final String id;
  final String full_name;
  final String email;
  final String no_hp;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      full_name: json['full_name'] as String,
      email: json['email'] as String,
      no_hp: json['no_hp'] as String,
    );
  }
}
