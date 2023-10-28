import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServiceInterface {
  Future<User> handleGetUser();
  Future handleSetSignout();
  Future<String> handleGetToken();
  Future<User> handleGoogleSignin();
  Future<User> handleLinkAccountGoogle(User user);
  Future handleFacebookSignin();
  Future handleSignup(PatientModel model);
  Future<User> handleEmailSignin(String userEmail, String userPassword);
  Future verifyNumber(String userPhone);
  Future handleSmsSignin(String smsCode, String verificationId);
}
