import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  const PostModel({
    required this.id,
    required this.title,
    required this.body,
  });
  final int id;
  final String title;
  final String body;

  PostModel copyWith({
    int? id,
    String? title,
    String? body,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  List<Object> get props => [id, title, body];
}
