import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:infinit_list2/post/models/models.dart';
import 'package:stream_transform/stream_transform.dart';

import 'infinite_list_state.dart';

part 'infinite_list_event.dart';

class InfiniteListBloc extends Bloc<InfiniteListEvent, InfiniteListState> {
  final _postLimit = 20;
  final throttleDuration = Duration(milliseconds: 100);
  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }

  InfiniteListBloc() : super(InfiniteListState()) {
    on<FetchPosts>(_onPostFetched,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onPostFetched(
      FetchPosts event, Emitter<InfiniteListState> emit) async {
    if (state.isEndOfPost) return;
    try {
      if (state.status == PostStatus.loading) {
        final post = await _fetchPost();
        return emit(state.copyWith(
            posts: post, status: PostStatus.success, isEndOfPost: false));
      }
      ;
      final posts = await _fetchPost(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(isEndOfPost: true))
          : emit(
              state.copyWith(
                status: PostStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                isEndOfPost: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<PostModel>> _fetchPost([_startIndex = 0]) async {
    final response = await http.get(
      Uri.https('jsonplaceholder.typicode.com', '/posts',
          <String, String>{'_start': '$_startIndex', '_limit': '$_postLimit'}),
    );
    if (response.statusCode == 200) {
      log('${response.body}');
      final post = jsonDecode(response.body) as List;
      return post.map((e) {
        return PostModel(
            id: e['id'] as int,
            title: e['title'] as String,
            body: e['body'] as String);
      }).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
