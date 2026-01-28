import 'package:colormate_app/core/utils/assets_data.dart';
import 'package:colormate_app/features/onboarding/data/models/onboarding_model.dart';

final List<OnboardingModel> onboardingData = [
  OnboardingModel(
    image: AssetsData.test,
    title: 'Test Your Color Vision',
    description:
        'Take quick and accurate color vision tests like Ishihara Test to detect if you have color blindness and know its type.',
  ),
  OnboardingModel(
    image: AssetsData.object,
    title: 'Object & Color Detection',
    description:
        'Use your camera to identify objects and their colors — powered by AI for accurate, fast results.',
  ),
  OnboardingModel(
    image: AssetsData.outfit,
    title: 'Outfit Color Matching',
    description:
        'Get smart outfit suggestions that help you match clothing colors confidently and look your best.',
  ),
];
