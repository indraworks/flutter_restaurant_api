class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

//Re
class CustomerReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReview> customeReviews;

  CustomerReviewResponse({
    required this.error,
    required this.message,
    required this.customeReviews,
  });

  factory CustomerReviewResponse.fromJson(Map<String, dynamic> json) {
    return CustomerReviewResponse(
      error: json['error'] ?? '',
      message: json['message'] ?? 'unknown error',
      customeReviews: (json['customerReviews'] as List<dynamic>? ?? [])
          .map((r) => CustomerReview.fromJson(r))
          .toList(),
    );
  }
}
