import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/fruits/presentation/views/widgets/image_card.dart';
import 'package:colormate_app/features/matching/presentation/cubit/matching_cubit.dart';
import 'package:colormate_app/features/matching/presentation/cubit/matching_state.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/outfit_score_card.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/outfit_suggestions_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OutfitRatingViewBody extends StatelessWidget {
  final String imagePath;

  const OutfitRatingViewBody({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchingCubit()..analyzeFruit(imagePath),
      child: BlocBuilder<MatchingCubit, MatchingState>(
        builder: (context, state) {
          return SingleChildScrollView(
            // prevents overflow when result card + image are both tall
            child: Column(
              children: [
                CustomAppBar(
                  title: 'Outfit Rating',
                  onBackPressed: () => context.go(Routes.homeView),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 32.h,
                    left: 16.w,
                    right: 16.w,
                    bottom: 24.h,
                  ),
                  child: Column(
                    children: [
                      _buildImage(state),
                      SizedBox(height: 16.h),
                      _buildResult(state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(MatchingState state) {
    if (state is MatchingSuccess) {
      return ImageCard(imagePath: state.imagePath);
    }
    return ImageCard(imagePath: imagePath);
  }

  Widget _buildResult(MatchingState state) {
    if (state is MatchingLoading) {
      return Column(
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 10.h),
          const Text('Analyzing outfit...'),
        ],
      );
    }

    if (state is MatchingSuccess) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ Pass real score from API (85.0)
          OutfitScoreCard(score: state.score),
          SizedBox(height: 20.h),
          // ✅ Pass real suggestions from API
          OutfitSuggestionsCard(suggestions: state.suggestions),
        ],
      );
    }

    if (state is MatchingError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
    }

    return const SizedBox();
  }
}
