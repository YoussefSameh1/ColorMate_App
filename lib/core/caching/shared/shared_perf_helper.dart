// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefHelper {
//   // التهيئة المتأخرة للـ Singleton
//   static final SharedPrefHelper _instance = SharedPrefHelper._internal();

//   // التهيئة الداخلية الخاصة
//   SharedPrefHelper._internal() {
//     // لا نقوم بتهيئة SharedPreferences في الكونستركتور لأن العملية
//     // غير متزامنة. يجب استدعاء ensureInitialized أو init من main() قبل الاستخدام.
//   }

//   // الحصول على الـ Singleton instance
//   static SharedPrefHelper get instance => _instance;

//   late SharedPreferences _prefs; // متغير متأخر لـ SharedPreferences
//   bool _isInitialized = false;

//   /// Public init method that can be awaited from main()
//   Future<void> init() async => await ensureInitialized();

//   // دالة تهيئة خاصة
//   Future<void> _init() async {
//     _prefs = await SharedPreferences.getInstance();
//     _isInitialized = true;
//   }

//   // تأكد من تهيئة _prefs قبل الاستخدام
//   Future<void> ensureInitialized() async {
//     if (!_prefsInitialized()) {
//       await _init();
//     }
//   }

//   // التحقق مما إذا كان _prefs تم تهيئته
//   bool _prefsInitialized() => _isInitialized;

//   // حفظ String
//   Future<void> saveString(String key, String value) async {
//     await ensureInitialized();
//     await _prefs.setString(key, value);
//   }

//   // استرجاع String
//   String? getString(String key) {
//     return _prefs.getString(key);
//   }

//   // حفظ int
//   Future<void> saveInt(String key, int value) async {
//     await ensureInitialized();
//     await _prefs.setInt(key, value);
//   }

//   // استرجاع int
//   int? getInt(String key) {
//     return _prefs.getInt(key);
//   }

//   // حفظ bool
//   Future<void> saveBool(String key, bool value) async {
//     await ensureInitialized();
//     await _prefs.setBool(key, value);
//   }

//   // استرجاع bool
//   bool? getBool(String key) {
//     return _prefs.getBool(key);
//   }

//   // حفظ double
//   Future<void> saveDouble(String key, double value) async {
//     await ensureInitialized();
//     await _prefs.setDouble(key, value);
//   }

//   // استرجاع double
//   double? getDouble(String key) {
//     return _prefs.getDouble(key);
//   }

//   // حفظ List<String>
//   Future<void> saveStringList(String key, List<String> value) async {
//     await ensureInitialized();
//     await _prefs.setStringList(key, value);
//   }

//   // استرجاع List<String>
//   List<String>? getStringList(String key) {
//     return _prefs.getStringList(key);
//   }

//   // حذف قيمة بناءً على المفتاح
//   Future<void> remove(String key) async {
//     await ensureInitialized();
//     await _prefs.remove(key);
//   }

//   // التحقق مما إذا كان المفتاح موجود
//   bool containsKey(String key) {
//     return _prefs.containsKey(key);
//   }

//   // مسح كل البيانات
//   Future<void> clearAll() async {
//     await ensureInitialized();
//     await _prefs.clear();
//   }
// }
