// class Post {
//   int id;
//   String image;
//   String title;
//   String content;
//   DateTime createdAt;
//   DateTime updatedAt;

//   Post({
//     required this.id,
//     required this.image,
//     required this.title,
//     required this.content,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Post.fromJson(Map<String, dynamic> json) => Post(
//         id: json["id"],
//         image: json["image"],
//         title: json["title"],
//         content: json["content"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "image": image,
//         "title": title,
//         "content": content,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };

//   @override
//   String toString() {
//     return 'Post{id: $id, image: $image, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt}';
//   }
// }

import 'dart:convert';

class Postmodel {
  final String? message;
  final List<Post>? post;

  Postmodel({
    this.message,
    this.post,
  });

  factory Postmodel.fromJson(String str) => Postmodel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Postmodel.fromMap(Map<String, dynamic> json) => Postmodel(
        message: json["message"],
        post: json["post"] == null
            ? []
            : List<Post>.from(json["post"]!.map((x) => Post.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "post":
            post == null ? [] : List<dynamic>.from(post!.map((x) => x.toMap())),
      };
  @override
  String toString() {
    return 'Postmodel{message: $message, post: $post}';
  }
}

class Post {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Post({
    this.id,
    this.title,
    this.description,
    this.image,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(String str) => Post.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Post.fromMap(Map<String, dynamic> json) => Post(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"] ?? '',
        content: json["content"] ?? '',
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'Post{id: $id, title: $title, description: $description, image: $image, content: $content, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
