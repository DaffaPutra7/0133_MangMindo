import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/core/core.dart';
import 'package:projek_akhir/data/model/request/user/review_request_model.dart';
import 'package:projek_akhir/data/repository/order_repository.dart';
import 'package:projek_akhir/presentation/user/review/bloc/review_bloc.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class AddReviewScreen extends StatefulWidget {
  final int orderId;
  const AddReviewScreen({super.key, required this.orderId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final commentController = TextEditingController();
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc(OrderRepository(ServiceHttpClient())),
      child: Scaffold(
        appBar: AppBar(title: const Text('Beri Ulasan & Rating')),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text('Berikan rating Anda:', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                );
              }),
            ),
            const SpaceHeight(24),
            CustomTextField(
              controller: commentController,
              label: 'Tulis Komentar (Opsional)',
              maxLines: 5,
            ),
            const SpaceHeight(24),
            BlocConsumer<ReviewBloc, ReviewState>(
              listener: (context, state) {
                if (state is ReviewSuccess) {
                  Navigator.pop(context, true); 
                }
                if (state is ReviewFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.primaryRed,
                  ));
                }
              },
              builder: (context, state) {
                return Button.filled(
                  isLoading: state is ReviewLoading,
                  onPressed: () {
                    if (_rating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Rating tidak boleh kosong'),
                          backgroundColor: AppColors.primaryRed));
                      return;
                    }
                    final model = ReviewRequestModel(
                      rating: _rating,
                      comment: commentController.text,
                    );
                    context
                        .read<ReviewBloc>()
                        .add(SubmitReview(orderId: widget.orderId, data: model));
                  },
                  label: 'Kirim Review',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}