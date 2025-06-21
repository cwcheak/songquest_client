class User {
  final String id;
  final String email;
  final String? name;
  final String? photo;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.photo,
  });

  String displayName() {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }

    return email;
  }

  toJson() => {'id': id, 'name': name, 'email': email, 'photo': photo};

  static fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['name'],
        name: json['email'],
        photo: json['photo']);
  }

  static const empty = User(id: '', email: '', name: null, photo: null);
}
