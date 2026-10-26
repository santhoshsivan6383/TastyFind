import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/tasty_image.dart';
import '../../providers/food_providers.dart';

class AddReviewScreen extends ConsumerStatefulWidget {
  final int dishId;

  const AddReviewScreen({super.key, required this.dishId});

  @override
  ConsumerState<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends ConsumerState<AddReviewScreen> {
  int _selectedRating = 5;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;
  int _photoCount = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_selectedRating < 1 || _selectedRating > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating between 1 and 5')),
      );
      return;
    }

    if (_reviewController.text.length > 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review cannot exceed 1000 characters')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(foodRepositoryProvider);
      await repo.addReview(
        dishId: widget.dishId,
        rating: _selectedRating,
        reviewText: _reviewController.text.trim(),
      );

      // Invalidate dish details so the new review is shown
      ref.invalidate(dishDetailsProvider(widget.dishId));

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you! Your dish review has been published.'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dishAsync = ref.watch(dishDetailsProvider(widget.dishId));
    final dish = dishAsync.value;

    final dishName = dish?.name ?? 'Masala Dosa';
    final restName = dish?.restaurantName.isNotEmpty == true ? dish!.restaurantName : 'Hotel Sri Murugan';

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        title: const Text('Add Review'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dish preview card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          TastyImage(
                            imageUrl: dish?.imageUrl,
                            width: 54,
                            height: 54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dishName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepCharcoal,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  restName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),

                    // Rating Selector
                    const Text(
                      'Rating',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        final isSelected = star <= _selectedRating;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedRating = star);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.star_rounded,
                              size: 38,
                              color: isSelected ? AppColors.ratingStar : const Color(0xFFE2E8F0),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 26),

                    // Written Review
                    const Text(
                      'Your Review (optional)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: TextField(
                        controller: _reviewController,
                        maxLines: 4,
                        maxLength: 1000,
                        style: const TextStyle(fontSize: 14, color: AppColors.deepCharcoal),
                        decoration: const InputDecoration(
                          hintText: 'Share your experience about the taste, crispiness, and accompaniments...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Add Photos
                    Text(
                      'Add Photos ($_photoCount/5)',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        if (_photoCount < 5) {
                          setState(() => _photoCount++);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Photo attached for verification')),
                          );
                        }
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder, style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_outlined, color: AppColors.textMuted, size: 26),
                            const SizedBox(height: 4),
                            Text(
                              _photoCount > 0 ? '$_photoCount added' : 'Upload',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: PrimaryButton(
                text: 'Submit Review',
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : _submitReview,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
