class UserModel {
  final int id;
  final String email;
  final String username;
  final String name;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    this.avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 1,
      email: json['email'] as String? ?? 'johndoe@gmail.com',
      username: json['username'] as String? ?? 'johndoe',
      name: json['name'] != null
          ? "${json['name']['firstname']} ${json['name']['lastname']}"
          : 'John Doe',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'name': name,
        'avatarUrl': avatarUrl,
      };
}
