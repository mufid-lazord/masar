import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة إدارة الحسابات
/// تحفظ المستخدمين فعليًا على الجهاز باستخدام shared_preferences
/// كل مستخدم يسجّل بحسابه، ويدخل ببياناته هو لا ببيانات ثابتة.
class AuthService {
  static const String _usersKey = 'masar_users';
  static const String _currentUserKey = 'masar_current_user';

  /// جلب كل المستخدمين المسجّلين (قائمة من خرائط)
  static Future<List<Map<String, dynamic>>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return [];
    final List decoded = jsonDecode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }

  /// حفظ قائمة المستخدمين
  static Future<void> _saveAllUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  /// إنشاء حساب جديد
  /// يرجّع رسالة خطأ إن وُجدت، أو null عند النجاح
  static Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    if (name.trim().isEmpty) return 'الرجاء إدخال الاسم الكامل';
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      return 'الرجاء إدخال بريد إلكتروني صحيح';
    }
    if (password.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }

    final users = await _getAllUsers();

    // التأكد أن البريد غير مستخدم مسبقًا
    final exists = users.any((u) => u['email'] == cleanEmail);
    if (exists) {
      return 'هذا البريد الإلكتروني مسجّل مسبقًا، سجّل الدخول بدلاً من ذلك';
    }

    users.add({
      'name': name.trim(),
      'email': cleanEmail,
      'phone': phone.trim(),
      'password': password,
    });
    await _saveAllUsers(users);

    // تسجيل الدخول تلقائيًا بعد إنشاء الحساب
    await _setCurrentUser(cleanEmail);
    return null;
  }

  /// تسجيل الدخول بحساب موجود
  /// يرجّع رسالة خطأ إن وُجدت، أو null عند النجاح
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    if (cleanEmail.isEmpty || password.isEmpty) {
      return 'الرجاء إدخال البريد وكلمة المرور';
    }

    final users = await _getAllUsers();

    Map<String, dynamic>? user;
    for (final u in users) {
      if (u['email'] == cleanEmail) {
        user = u;
        break;
      }
    }

    if (user == null) {
      return 'لا يوجد حساب بهذا البريد، أنشئ حسابًا جديدًا أولاً';
    }
    if (user['password'] != password) {
      return 'كلمة المرور غير صحيحة';
    }

    await _setCurrentUser(cleanEmail);
    return null;
  }

  /// حفظ بريد المستخدم الحالي (الجلسة المفتوحة)
  static Future<void> _setCurrentUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, email);
  }

  /// جلب بيانات المستخدم الحالي المسجّل دخوله (أو null إن لا أحد)
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_currentUserKey);
    if (email == null) return null;

    final users = await _getAllUsers();
    for (final u in users) {
      if (u['email'] == email) return u;
    }
    return null;
  }

  /// هل يوجد مستخدم مسجّل دخوله حاليًا؟
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey) != null;
  }

  /// تسجيل الخروج (إنهاء الجلسة فقط، الحسابات تبقى محفوظة)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}
