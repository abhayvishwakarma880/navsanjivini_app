/// Represents an authenticated user in Navsanjivini.
class AuthUser {
  final String id;
  final String phone;
  final String name;
  final String? token;

  const AuthUser({
    required this.id,
    required this.phone,
    required this.name,
    this.token,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'name': name,
        'token': token,
      };

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        name: json['name'] as String? ?? '',
        token: json['token'] as String?,
      );
}

