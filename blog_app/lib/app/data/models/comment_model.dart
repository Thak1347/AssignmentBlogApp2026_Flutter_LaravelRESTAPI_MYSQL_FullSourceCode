import 'user_model.dart';

class CommentModel {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final String? createdAt;
  final String? updatedAt;
  final UserModel? user;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: _parseInt(json['id']),
      postId: _parseInt(json['post_id']),
      userId: _parseInt(json['user_id']),
      content: _parseString(json['content']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
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
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
    };
  }

  String getFormattedDate() {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return createdAt!;
    }
  }
}
