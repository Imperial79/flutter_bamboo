import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ngf_organic/Models/Response_Model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Helper/api_config.dart';
import '../Models/User_Model.dart';

final userProvider = StateProvider<UserModel?>(
  (ref) => null,
);

final authRepository = Provider(
  (ref) => AuthRepo(),
);

final authFuture = FutureProvider(
  (ref) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    final res = await apiCallBack(
      path: "/user/auth",
      body: {
        "fcmToken": fcmToken,
      },
    );

    if (!res.error) {
      ref.read(userProvider.notifier).state = UserModel.fromMap(res.data);
    }
  },
);

class AuthRepo {
  static GoogleSignIn get googleSignIn => GoogleSignIn(
        serverClientId: dotenv.get("WEB_CLIENT_ID"),
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
        ],
      );
  static Future<ResponseModel> sendTokenToBackend(
    WidgetRef ref,
    String idToken,
    String? referrerCode,
  ) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      final res = await apiCallBack(
        path: "/user/login-with-google",
        body: {
          "token": idToken,
          "fcmToken": fcmToken,
          "referrerCode": referrerCode,
        },
      );

      if (!res.error) {
        ref.read(userProvider.notifier).state = UserModel.fromMap(res.data);
      }

      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> signInWithGoogle(WidgetRef ref,
      {String? referrerCode}) async {
    try {
      await googleSignIn.signOut();

      final GoogleSignInAccount? gAccount = await googleSignIn.signIn();

      if (gAccount != null) {
        final GoogleSignInAuthentication gAuth = await gAccount.authentication;

        return await sendTokenToBackend(ref, gAuth.idToken ?? "", referrerCode);
      }
      return ResponseModel(error: true, message: "User is null!");
    } catch (error) {
      rethrow;
    }
  }

  Future<ResponseModel> sendOtp({
    required String phone,
    required String appSignature,
  }) async {
    try {
      final res = await apiCallBack(
        path: "/sms-service/send-otp",
        body: {
          "phone": phone,
          "appSignature": appSignature,
        },
      );
      if (res.error) {
        throw res.message;
      }
      return res;
    } catch (error) {
      rethrow;
    }
  }

  Future<ResponseModel> loginWithPhone({
    required String phone,
    required String otp,
    String? referrerCode = "",
  }) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final res = await apiCallBack(
        path: "/user/login-with-phone",
        body: {
          "phone": phone,
          "otp": otp,
          "referrerCode": referrerCode,
          "fcmToken": fcmToken,
        },
      );
      if (res.error) {
        throw res.message;
      }
      return res;
    } catch (error) {
      rethrow;
    }
  }

  Future<ResponseModel> logout() async {
    try {
      final res = await apiCallBack(path: "/user/logout");
      return res;
    } catch (error) {
      rethrow;
    }
  }

  Future<ResponseModel> updateProfile(Map<String, dynamic> body) async {
    try {
      final res = await apiCallBack(path: "/user/update-profile", body: body);
      if (res.error) throw res.message;
      return res;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> auth(WidgetRef ref) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      final res = await apiCallBack(
        path: "/user/auth",
        body: {
          "fcmToken": fcmToken,
        },
      );

      if (!res.error) {
        ref.read(userProvider.notifier).state = UserModel.fromMap(res.data);
      }
    } catch (error) {
      rethrow;
    }
  }
}
