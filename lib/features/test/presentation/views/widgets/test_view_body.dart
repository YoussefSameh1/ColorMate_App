import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/test/presentation/cubit/test_cubit.dart';
import 'package:colormate_app/features/test/presentation/views/widgets/answer_option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TestViewBody extends StatelessWidget {
  const TestViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestCubit, TestState>(
      listener: (context, state) {
        if (state is TestFinished) {
          GoRouter.of(context).push(Routes.testResultView);
        }
      },
      builder: (context, state) {
        if (state is TestQuestionLoaded) {
          final question = state.questions[state.currentIndex];
          return Column(
            children: [
              CustomAppBar(title: 'Color Vision Test'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      'What number do you see in the circle?',
                      style: Styles.testQuestionTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Question ${question.questionNumber} of ${state.questions.length}',
                        style: Styles.descriptionStyle.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Image.asset(
                      question.image,
                      height: 270.h,
                      width: 270.w,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => context.read<TestCubit>().selectAnswer(),
                          child: AnswerOptionButton(
                            option: '${question.options[index]}',
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () => context.read<TestCubit>().selectAnswer(),
                      child: AnswerOptionButton(option: 'None of the above'),
                    ),
                    TextButton(
                      onPressed: () => context.read<TestCubit>().selectAnswer(),
                      child: Text(
                        'Didn\'t see it!',
                        style: Styles.textButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
