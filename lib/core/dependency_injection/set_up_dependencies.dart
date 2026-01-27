// import 'package:get_it/get_it.dart';
// import 'package:soul_trip/features/categories_trips/data/repositories/categories_trips_repository.dart';
// import 'package:soul_trip/features/categories_trips/manager/categories_trips_cubit/categories_trips_cubit.dart';

// import '../../features/authentication/data/authentication_repository.dart';
// import '../../features/authentication/logic/forget_password/forget_password_cubit.dart';
// import '../../features/authentication/logic/login/login_cubit.dart';
// import '../../features/authentication/logic/signup/signup_cubit.dart';
// import '../../features/authentication/logic/social_auth/social_auth_cubit.dart';
// import '../../features/category_trips/data/repositories/category_trips_repository.dart';
// import 'package:soul_trip/features/home/data/repositories/banner_repository.dart';
// import 'package:soul_trip/features/home/data/repositories/home_trips_repository.dart';
// import 'package:soul_trip/features/home/data/repositories/banner_likes_repository.dart';
// import 'package:soul_trip/features/home/data/repositories/trips_likes_repository.dart';
// import 'package:soul_trip/features/home/manager/banner_cubit/banner_cubit.dart';
// import 'package:soul_trip/features/home/manager/home_trips_cubit/home_trips_cubit.dart';
// import '../../features/onboarding/data/onboarding_repository.dart';
// import '../../features/onboarding/logic/onboarding_cubit.dart';
// import '../../features/profile/data/data_upload/data_upload_repository.dart';
// import '../../features/profile/data/user/user_repository.dart';
// import '../../features/profile/logic/data_upload/data_upload_cubit.dart';
// import '../../features/profile/logic/user/user_cubit.dart';
// import '../../features/reviews/data/reviews_repository.dart';
// import '../../features/reviews/logic/post_review/post_review_cubit.dart';
// import '../../features/reviews/logic/write_review/write_review_cubit.dart';
// import '../../features/search/data/repositories/search_repository.dart';
// import '../../features/search/manager/search_cubit/search_cubit.dart';
// import '../../features/wishlist/data/repository/wishlist_repository.dart';
// import '../../features/wishlist/logic/cubit/wishlist_cubit.dart';
// import 'package:soul_trip/core/caching/hive/notification_hive_helper.dart';
// import '../caching/hive/user_hive_helper.dart';
// import '../repositories/storage/cloudinary_service.dart';
// import '../services/fcm_service.dart';


// final getIt = GetIt.instance;

// void setupDependencies() async {
//   // getIt.registerSingleton<DioHelper>(DioHelper());

//   /// 1. (Singletons) -- Core / Helpers
//   /// "registerLazySingleton" = Create it ONCE and keep it alive forever.
//   /// Note: (ConnectivityCubit) Hashed to avoid Dual-Injection
//   // getIt.registerFactory<ConnectivityCubit>(() => ConnectivityCubit());
//   getIt.registerLazySingleton<UserHiveHelper>(() => UserHiveHelper());
//   getIt.registerLazySingleton<NotificationHiveHelper>(
//     () => NotificationHiveHelper(),
//   );

//   // -- Repositories
//   // - Cloudinary (Storage)
//   getIt.registerLazySingleton<CloudinaryService>(() => CloudinaryService());
//   // - FCM Service
//   getIt.registerLazySingleton<FCMService>(() => FCMService());
//   // - Authentication Repository
//   getIt.registerLazySingleton<AuthenticationRepository>(
//     () => AuthenticationRepository(),
//   );
//   // - User Repository
//   getIt.registerLazySingleton<UserRepository>(() => UserRepository());
//   // - OnBoarding
//   getIt.registerLazySingleton<OnboardingRepository>(
//     () => OnboardingRepository(),
//   );
//   // - Home Repositories
//   getIt.registerLazySingleton<HomeTripsRepository>(() => HomeTripsRepository());
//   getIt.registerLazySingleton<BannerRepository>(() => BannerRepository());
//   getIt.registerLazySingleton<BannerLikesRepository>(
//     () => BannerLikesRepository(),
//   );
//   getIt.registerLazySingleton<TripsLikesRepository>(
//     () => TripsLikesRepository(),
//   );
//   getIt.registerLazySingleton<CategoriesTripsRepository>(
//     () => CategoriesTripsRepository(),
//   );
//   getIt.registerLazySingleton<CategoryTripsRepository>(
//     () => CategoryTripsRepository(),
//   );
//   getIt.registerLazySingleton<SearchRepository>(
//     () => SearchRepository(
//       getIt<HomeTripsRepository>(),
//       getIt<CategoriesTripsRepository>(),
//     ),
//   );
//   // - Notification Repository
//   getIt.registerLazySingleton<NotificationRepository>(
//     () => NotificationRepository(getIt<NotificationHiveHelper>()),
//   );

//   // - Reviews Repository
//   getIt.registerLazySingleton<ReviewsRepository>(
//     () => ReviewsRepository(getIt<CloudinaryService>()),
//   );

//   // - Wishlist Repository
//   getIt.registerLazySingleton<WishlistRepository>(() => WishlistRepository());

//   /// 2. (Factories) - Logic/State (Cubits)
//   /// "registerFactory" = so a new Cubit is created every time a screen opens
//   /// (Good for Screens like (Login/SignUp) which are destroyed when closed)

//   // - Login
//   getIt.registerFactory<LoginCubit>(
//     () => LoginCubit(getIt<AuthenticationRepository>()),
//   );
//   // - Sign Up
//   getIt.registerFactory<SignupCubit>(
//     () =>
//         SignupCubit(getIt<AuthenticationRepository>(), getIt<UserRepository>()),
//   );
//   // - Google Login/SignUp
//   getIt.registerFactory<SocialAuthCubit>(
//     () => SocialAuthCubit(getIt<AuthenticationRepository>()),
//   );
//   // - Forget Password
//   getIt.registerFactory<ForgetPasswordCubit>(
//     () => ForgetPasswordCubit(getIt<AuthenticationRepository>()),
//   );
//   // - User
//   getIt.registerFactory<UserCubit>(
//     () => UserCubit(getIt<UserRepository>(), getIt<CloudinaryService>()),
//   );
//   // - OnBoarding
//   getIt.registerFactory<OnboardingCubit>(
//     () => OnboardingCubit(getIt<OnboardingRepository>()),
//   );
//   // - Data Upload
//   getIt.registerLazySingleton<DataUploadRepository>(
//     () => DataUploadRepository(getIt<CloudinaryService>()),
//   );
//   getIt.registerFactory<DataUploadCubit>(
//     () => DataUploadCubit(getIt<DataUploadRepository>()),
//   );

//   // - Home Cubits
//   getIt.registerFactory<HomeTripsCubit>(
//     () => HomeTripsCubit(getIt<HomeTripsRepository>()),
//   );
//   getIt.registerFactory<BannerCubit>(
//     () => BannerCubit(getIt<BannerRepository>()),
//   );
//   getIt.registerFactory<CategoriesTripsCubit>(
//     () => CategoriesTripsCubit(getIt<CategoriesTripsRepository>()),
//   );
//   getIt.registerFactory<SearchCubit>(
//     () => SearchCubit(getIt<SearchRepository>()),
//   );

//   // Reviews Logic
//   getIt.registerFactory<ReviewCubit>(
//     () => ReviewCubit(getIt<ReviewsRepository>()),
//   );

//   getIt.registerFactory<WriteReviewCubit>(
//     () => WriteReviewCubit(getIt<ReviewsRepository>()),
//   );

//   getIt.registerFactory<WishlistCubit>(
//     () => WishlistCubit(repository: getIt<WishlistRepository>()),
//   );
// }
