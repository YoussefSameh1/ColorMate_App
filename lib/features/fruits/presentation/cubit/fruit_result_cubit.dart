import 'dart:math';
import 'package:colormate_app/features/fruits/presentation/cubit/fruit_result_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FruitResultCubit extends Cubit<FruitResultState> {
  FruitResultCubit() : super(FruitResultInitial());

  Future<void> analyzeFruit(String imagePath) async {
    emit(FruitResultLoading());

    try {
      // 🌐 simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // 🔥 mock AI result (replace later with real API)
      final random = Random();
      final spoiled = random.nextInt(60) + 5; // 5% → 65%

      final status = spoiled > 30 ? "Not Fresh" : "Fresh";

      emit(
        FruitResultSuccess(
          imagePath: imagePath,
          spoiledPercent: spoiled.toDouble(),
          status: status,
        ),
      );
    } catch (e) {
      emit(FruitResultError(e.toString()));
    }
  }
}
