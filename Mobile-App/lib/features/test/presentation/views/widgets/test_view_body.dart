// test_view_body.dart
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
        if (state is TestError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is TestLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TestQuestionLoaded) {
          final question = state.questions[state.currentIndex];

          return Column(
            children: [
              const CustomAppBar(
                title: 'Color Vision Test',
                isBackButtonVisible: false,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12.h),
                      Text(
                        'What number do you see in the circle?',
                        style: Styles.testQuestionTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Question ${question.imageId} of ${state.questions.length}',
                          style: Styles.descriptionStyle.copyWith(
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Image takes proportional share of vertical space
                      Expanded(
                        flex: 5,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            question.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Answers take remaining space, never overflow
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3.2,   // slightly wider tap targets
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 10.h,
                              ),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => context
                                      .read<TestCubit>()
                                      .selectAnswer(
                                        '${question.options[index]}',
                                      ),
                                  child: AnswerOptionButton(
                                    option: '${question.options[index]}',
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () =>
                                  context.read<TestCubit>().selectAnswer("x"),
                              child: const AnswerOptionButton(
                                option: 'None of the above',
                              ),
                            ),
                            SizedBox(height: 2.h),
                            TextButton(
                              onPressed: () =>
                                  context.read<TestCubit>().selectAnswer("x"),
                              child: Text(
                                "Didn't see it!",
                                style: Styles.textButtonTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}