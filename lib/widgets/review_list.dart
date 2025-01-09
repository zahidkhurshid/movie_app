import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../config/app_settings.dart';

class ReviewList extends StatelessWidget {
  final int movieId;

  ReviewList({required this.movieId});

  // TODO: Implement fetching reviews from API

  @override
  Widget build(BuildContext context) {
    // Placeholder reviews
    final reviews = [
      Review(
          id: '1',
          author: 'John Doe',
          content: 'Great movie! The special effects were mind-blowing and the plot kept me on the edge of my seat.',
          rating: 4.5,
          userId: 'user123',
          userName: 'movie_buff_john',
          comment: 'Definitely worth watching in IMAX!'
      ),
      Review(
          id: '2',
          author: 'Jane Smith',
          content: 'Enjoyed it a lot. The acting was superb and the cinematography was breathtaking.',
          rating: 4.0,
          userId: 'user456',
          userName: 'cinemagic_jane',
          comment: 'A must-see for any film enthusiast.'
      ),
      Review(
          id: '3',
          author: 'Mike Johnson',
          content: 'Decent movie, but the pacing was a bit off in the middle.',
          rating: 3.5,
          userId: 'user789',
          userName: 'critical_mike',
          comment: 'Good performances, but the script could use some work.'
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: AppSettings.smallPadding),
          child: ListTile(
            title: Text(review.author, style: AppSettings.headlineStyle),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSettings.smallPadding),
                Text(review.content, style: AppSettings.bodyStyle),
                SizedBox(height: AppSettings.smallPadding),
                Row(
                  children: [
                    Icon(Icons.star, color: AppSettings.accentColor, size: 16),
                    SizedBox(width: 4),
                    Text('${review.rating}/5', style: AppSettings.bodyStyle),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


