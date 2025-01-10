import 'package:flutter/material.dart';
import '../config/app_settings.dart';

class RatingBar extends StatelessWidget {
  final double initialRating;
  final double minRating;
  final double maxRating;
  final ValueChanged<double> onRatingUpdate;

  const RatingBar({
    super.key,
    required this.initialRating,
    required this.minRating,
    required this.maxRating,
    required this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = AppSettings.iconSize; // Default icon size
    final availableWidth = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: availableWidth),
      child: Wrap(
        spacing: 4.0,
        children: List.generate(
          (maxRating / AppSettings.ratingStep).round(),
          (index) {
            final rating = (index + 1) * AppSettings.ratingStep;
            return IconButton(
              iconSize: iconSize,
              icon: Icon(
                rating <= initialRating ? Icons.star : Icons.star_border,
                color: AppSettings.accentColor,
              ),
              onPressed: () => onRatingUpdate(rating),
            );
          },
        ),
      ),
    );
  }
}
