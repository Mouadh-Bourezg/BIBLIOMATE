class User {
  final int? id;
  final String email;
  final String username;
  final String? profilePictureUrl;
  final String passwordHash;

  User({
    this.id,
    required this.email,
    required this.username,
    this.profilePictureUrl,
    required this.passwordHash,
  });

  // Convert a User object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profilePictureUrl': profilePictureUrl,
      'passwordHash': passwordHash,
    };
  }

  // Create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      profilePictureUrl: map['profilePictureUrl'],
      passwordHash: map['passwordHash'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, username: $username}';
  }
}
