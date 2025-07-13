part of 'review_bloc.dart';

@immutable
sealed class ReviewState {}

final class ReviewInitial extends ReviewState {}
final class ReviewLoading extends ReviewState {}
final class ReviewSuccess extends ReviewState {}
final class ReviewFailure extends ReviewState {
  final String message;
  ReviewFailure({required this.message});
}