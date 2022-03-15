import 'package:equatable/equatable.dart';
import 'package:infinit_list2/post/models/models.dart';

enum PostStatus { failure, success, loading }

class InfiniteListState extends Equatable {
  const InfiniteListState({
    this.posts = const <PostModel>[],
    this.status = PostStatus.loading,
    this.isEndOfPost = false,
  });
  final List<PostModel> posts;
  final PostStatus status;
  final bool isEndOfPost;

  InfiniteListState copyWith({
    List<PostModel>?posts,
    PostStatus? status,
    bool? isEndOfPost,
  }) {
    return InfiniteListState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      isEndOfPost: isEndOfPost ?? this.isEndOfPost,
    );
  }

  @override
  String toString() =>
      'InfiniteListState(posts: $posts, status: $status, isEndOfPost: $isEndOfPost)';
  @override
  List<Object> get props => [posts, status, isEndOfPost];
}
