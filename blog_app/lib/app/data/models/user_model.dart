class UserModel {
  final int id;
  final String name;
  final String email;
  final String? profileImage;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      email: _parseString(json['email']),
      profileImage: _parseString(json['profile_image']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? profileImage,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String getProfileImageUrl() {
    if (profileImage != null && profileImage!.isNotEmpty) {
      return 'http://localhost:8000/storage/$profileImage';
    }
    return '';
  }

  String getInitials() {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return names[0][0].toUpperCase();
  }
}
