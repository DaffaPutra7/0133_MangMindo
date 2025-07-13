part of 'review_bloc.dart';

@immutable
sealed class ReviewEvent {}

class SubmitReview extends ReviewEvent {
  final int orderId;
  final ReviewRequestModel data;
  SubmitReview({required this.orderId, required this.data});
}