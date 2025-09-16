import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_review_provider.dart';
import '../states/result_state.dart';

class ReviewSection extends StatelessWidget {
  final String restaurantId;
  final TextEditingController nameController;
  final TextEditingController reviewController;

  const ReviewSection({
    super.key,
    required this.restaurantId,
    required this.nameController,
    required this.reviewController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Consumer<RestaurantReviewProvider>(
          //rp parameter name utk rstaurantreviewprovider
          builder: (context, rp, _) {
            switch (rp.state) {
              case ResultState.loading:
                return Center(
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                    width: 80,
                  ),
                );
              case ResultState.success:
                final reviews = rp.reviewResult?.customeReviews ?? [];
                if (reviews.isEmpty) {
                  return const Text('No Review Yet..');
                }
                return Column(
                  children: //childrennya gak pake array atau  [] krn hanya 1 saja
                  reviews.map((r) {
                    return Card(
                      child: ListTile(
                        title: Text(r.name),
                        subtitle: Text(r.review),
                        trailing: Text(r.date),
                      ),
                    );
                  }).toList(),
                );

              case ResultState.error:
                return Text(
                  rp.errorMessage.isNotEmpty
                      ? rp.errorMessage
                      : 'Failed to Load Reviews',
                  style: TextStyle(color: Colors.red),
                );
              case ResultState.noData:
                return const Text('No Reviews yet!...');
            }
          },
        ),
        //Bagian Form  tambah Review
        SizedBox(height: 24),
        Text('Add Your Review ', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 12),
        TextField(
          //NAMA
          controller: nameController,

          decoration: InputDecoration(
            labelText: "Your name",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 12),
        TextField(
          //REVIEWNYA
          controller: reviewController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: "Your Review",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final review = reviewController.text.trim();
            if (name.isNotEmpty && review.isNotEmpty) {
              context.read<RestaurantReviewProvider>().submitReview(
                restaurantId: restaurantId,
                name: name,
                review: review,
              );
              //clearkan
              nameController.clear();
              reviewController.clear();
            }
          },
          child: const Text('Submit Review'),
        ),
      ],
    );
  }
}
