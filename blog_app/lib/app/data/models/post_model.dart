import 'comment_model.dart';
import 'user_model.dart';

class PostModel {
  final int id;
  final int userId;
  final String title;
  final String? content;
  final String? image;
  final String? imageUrl; 
  final String? createdAt;
  final String? updatedAt;
  final UserModel? user;
  final List<CommentModel>? comments;
  final bool? isLiked;
  final int? likeCount;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    this.content,
    this.image,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.comments,
    this.isLiked = false,
    this.likeCount = 0,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      title: _parseString(json['title']),
      content: _parseString(json['content']),
      image: _parseString(json['image']),
      imageUrl: _parseString(json['image_url']), // From Laravel
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      comments: json['comments'] != null && json['comments'] is List
          ? (json['comments'] as List)
                .whereType<Map<String, dynamic>>()
                .map((c) => CommentModel.fromJson(c))
                .toList()
          : null,
      isLiked: _parseBool(json['is_liked']),
      likeCount: _parseInt(json['like_count']),
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

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  // Get image URL - uses imageUrl from Laravel first, then falls back to manual
  String getImageUrl() {
    // First try to use the image_url from Laravel
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Laravel returns full URL via asset() helper
      return imageUrl!;
    }

    // Fallback: manually construct URL
    if (image != null && image!.isNotEmpty) {
      const String baseUrl = 'http://10.0.2.2:8000';
      final cleanPath = image!.startsWith('/') ? image!.substring(1) : image!;
      return '$baseUrl/storage/$cleanPath';
    }

    return '';
  }

  String getFormattedDate() {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return createdAt!;
    }
  }

  String getTimeAgo() {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 30) {
        return getFormattedDate();
      } else if (difference.inDays > 7) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks week${weeks > 1 ? 's' : ''} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return createdAt!;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  int getCommentCount() => comments?.length ?? 0;

  bool hasImage() => image != null && image!.isNotEmpty;

  bool hasContent() => content != null && content!.isNotEmpty;

  String getContentPreview({int length = 150}) {
    if (content == null || content!.isEmpty) return '';
    if (content!.length <= length) return content!;
    return '${content!.substring(0, length)}...';
  }

  bool get isLikedByUser => isLiked ?? false;

  int get getLikeCount => likeCount ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'image': image,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'comments': comments?.map((c) => c.toJson()).toList(),
      'is_liked': isLiked,
      'like_count': likeCount,
    };
  }

  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? content,
    String? image,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
    UserModel? user,
    List<CommentModel>? comments,
    bool? isLiked,
    int? likeCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
    );
  }

  @override
  String toString() {
    return 'PostModel(id: $id, title: $title, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
