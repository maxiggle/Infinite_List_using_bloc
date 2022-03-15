part of 'infinite_list_bloc.dart';

abstract class InfiniteListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPosts extends InfiniteListEvent {}
