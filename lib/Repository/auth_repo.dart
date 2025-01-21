import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bamboo/Models/Response_Model.dart';
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

class AuthRepo {
  static GoogleSignIn get googleSignIn => GoogleSignIn(
        serverClientId: dotenv.get("WEB_CLIENT_ID"),
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
        ],
      );
  static Future<ResponseModel> sendTokenToBackend(
      WidgetRef ref, String idToken) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      final res = await apiCallBack(
        path: "/user/login-with-google",
        body: {"token": idToken, "fcmToken": fcmToken},
      );

      if (!res.error) {
        ref.read(userProvider.notifier).state = UserModel.fromMap(res.data);
      }

      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> signInWithGoogle(WidgetRef ref) async {
    try {
      log("Trying to login...");
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            "320745356337-g0n67k8c7mq250men3h8lj3va1cv0dh2.apps.googleusercontent.com",
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
        ],
      );
      log("Signning out...");
      await googleSignIn.signOut();

      final GoogleSignInAccount? gAccount = await googleSignIn.signIn();
      log("Google Signned In");

      if (gAccount != null) {
        final GoogleSignInAuthentication gAuth = await gAccount.authentication;

        return await sendTokenToBackend(ref, gAuth.idToken ?? "");
      }
      return ResponseModel(error: true, message: "User is null!");
    } catch (error) {
      rethrow;
    }
  }

  Future<ResponseModel> logout(WidgetRef ref) async {
    try {
      final res = await apiCallBack(path: "/user/logout");
      return res;
    } catch (error) {
      rethrow;
    }
  }
}
