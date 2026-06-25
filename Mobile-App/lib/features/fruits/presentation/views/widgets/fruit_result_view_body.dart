// fruit_result_view_body.dart
import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/fruits/presentation/cubit/fruit_result_cubit.dart';
import 'package:colormate_app/features/fruits/presentation/cubit/fruit_result_state.dart';
import 'package:colormate_app/features/fruits/presentation/views/widgets/image_card.dart';
import 'package:colormate_app/features/fruits/presentation/views/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FruitResultViewBody extends StatelessWidget {
  final String imagePath;

  const FruitResultViewBody({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FruitResultCubit()..analyzeFruit(imagePath),
      child: BlocBuilder<FruitResultCubit, FruitResultState>(
        builder: (context, state) {
          return SingleChildScrollView(  // prevents overflow when result card + image are both tall
            child: Column(
              children: [
                CustomAppBar(
                  title: 'Fruits Scanner',
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

  Widget _buildImage(FruitResultState state) {
    if (state is FruitResultSuccess) {
      return ImageCard(imagePath: state.imagePath);
    }
    return ImageCard(imagePath: imagePath);
  }

  Widget _buildResult(FruitResultState state) {
    if (state is FruitResultLoading) {
      return Column(
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 10.h),
          const Text('Analyzing fruit...'),
        ],
      );
    }

    if (state is FruitResultSuccess) {
      return ResultCard(
        status: state.status,
        spoiledPercent: state.spoiledPercent,
        confidence: state.confidence,
      );
    }

    if (state is FruitResultError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
    }

    return const SizedBox();
  }
}