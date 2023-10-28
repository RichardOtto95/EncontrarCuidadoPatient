import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrarCuidado/app/core/models/patient_model.dart';
import 'package:encontrarCuidado/app/core/services/auth/auth_service_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService implements AuthServiceInterface {
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future handleFacebookSignin() {
    return null;
  }

  @override
  Future<String> handleGetToken() {
    return null;
  }

  @override
  Future<User> handleGetUser() async {
    return _auth.currentUser;
  }

  @override
  Future<User> handleEmailSignin(String userEmail, String userPassword) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: userEmail, password: userPassword);
    final User user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    //print'signInEmail succeeded: $user');

    return user;
  }

  @override
  Future handleSignup(PatientModel patient) async {
    print('%%%%%%%% handleSignup %%%%%%%%');

    User user = _auth.currentUser;

    // String token = await FirebaseMessaging.instance.getToken();
    // print('tokenId: $token');
    // print('user criar : ${user.uid}');
    if (patient != null) {
      String tokenString = await FirebaseMessaging.instance.getToken();

      patient.id = user.uid;
      patient.createdAt = Timestamp.now();
      patient.username = '${user.phoneNumber}';
      patient.notificationDisabled = false;
      patient.phone = user.phoneNumber;
      patient.status = 'ACTIVE';
      patient.type = 'HOLDER';
      patient.connected = true;
      patient.country = 'Brasil';
      patient.tokenId = [tokenString];
      Map<String, dynamic> patientMap = PatientModel().toJson(patient);
      print('patientMap: $patientMap');

      DocumentReference patRef =
          FirebaseFirestore.instance.collection('patients').doc(user.uid);

      await patRef.set(patientMap);
    }

    return patient;
  }

  @override
  Future<User> handleLinkAccountGoogle(User _user) async {
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    User user;

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // user = (await _user.linkWithCredential(credential)).user;
    // //print"signed in " + user.displayName);
    // Firestore.instance
    //     .collection('users')
    //     .document(user.uid)
    //     .updateData({'firstName': user.displayName, 'email': user.email});
    // // var credentialResult = await _auth.signInWithCredential(credential);
    // // user.linkWithCredential(credential);
    // return user;
  }

  @override
  Future<User> handleGoogleSignin() async {
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    User user;
    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );
    // List<String> providers =
    //     await _auth.fetchSignInMethodsForEmail(email: googleUser.email);
    // //print'providers: $providers');
    // if (providers != null) {
    //   //print"TEM PROV  $user");
    //   user = (await _auth.signInWithCredential(credential)).user;

    //   user.linkWithCredential(credential);
    //   //print"TEM PROV  $user");
    // } else {
    //   user = (await _auth.signInWithCredential(credential)).user;
    //   //print"signed in " + user.displayName);
    //   //print"NAO TEM PROV  $user");
    // }
    // user = (await _auth.signInWithCredential(credential)).user;
    // //print"signed in " + user.displayName);
    // var credentialResult = await _auth.signInWithCredential(credential);
    // user.linkWithCredential(credential);
    return user;
  }

  @override
  Future handleSetSignout() {
    return _auth.signOut();
  }

  @override
  Future verifyNumber(String userPhone) async {
    String verifID;
    var phoneMobile = userPhone;
    //print'$phoneMobile');

    await _auth
        .verifyPhoneNumber(
      phoneNumber: phoneMobile,
      verificationCompleted: (AuthCredential authCredential) async {
        //code for signing in}).catchError((e){
        final User user =
            (await _auth.signInWithCredential(authCredential)).user;
        _auth
            .signInWithCredential(authCredential)
            .then((UserCredential result) {
          //print'AuthResult ${result.user}');
        }).catchError((e) {
          //print'ERROR !!! $e');
        });
        // //print'verifyPhoneNumber $e}');
      },
      verificationFailed: (FirebaseAuthException authException) {
        // //printauthException.message);
        //print'ERROR !!! ${authException.message}');
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        verificationId = verificationId;
        verifID = verificationId;
        // Modular.to.pushNamed('/signin-phone/signin-phone-verify');

        //print"Código enviado para " + userPhone);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        //printverificationId);
        //print"Timout");
      },
      timeout: Duration(seconds: 60),
    )
        .catchError((e) {
      //print'ERROR !!! $e');
    });
    return verifID;
  }

  @override
  Future<User> handleSmsSignin(String smsCode, String verificationId) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    final User user = (await _auth.signInWithCredential(credential)).user;

    return user;
  }
}
