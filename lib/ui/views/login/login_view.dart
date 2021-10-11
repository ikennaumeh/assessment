import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_test/ui/views/home/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum MobileVerificationState {
  showMobileFormState,
  showMobileOtpState,
}
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  MobileVerificationState currentState = MobileVerificationState.showMobileFormState;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final usernameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId;
  bool loading = false;

  void signInWithPhoneCredential(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      loading = true;
    });
    try{
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        loading = false;
      });
      if(authCredential.user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>const HomeView(),));
      }
    } on FirebaseAuthException catch (e){
      setState(() {
        loading = false;
      });
      _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        const Spacer(),
        const Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            hintText: "Username",
          ),
        ),
        const SizedBox(height: 5,),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            hintText: "Phone number",
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              loading = true;
            });
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString("username", usernameController.text);
           await _auth.verifyPhoneNumber(
               phoneNumber: phoneController.text,
               verificationCompleted: (phoneAuthCredential) async {
                 setState(() {
                   loading = false;
                 });
                 //signInWithPhoneCredential(phoneAuthCredential);
               },
               verificationFailed: (verificationFailed)async{
                 setState(() {
                   loading = false;
                 });
                 _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(verificationFailed.message!)));
               },
               codeSent: (verificationId, resendingToken) async {
                 setState(() {
                   loading = false;
                   currentState = MobileVerificationState.showMobileOtpState;
                   this.verificationId = verificationId;

                 });
               },
               codeAutoRetrievalTimeout: (verificationId) async {


               });
          },
          child: const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
        ),
        const Spacer(),

      ],
    );
  }
  getMobileOtpWidget(context){
    return Column(
      children: [
        const Spacer(),
        TextField(
          controller: otpController,
          decoration: const InputDecoration(
            hintText: "Otp",
          ),
        ),
        ElevatedButton(
          onPressed: ()async{
            PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text);

            signInWithPhoneCredential(phoneAuthCredential);
          },
          child: const Text(
            'Verify',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
        ),
        const Spacer(),

      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading ? const Center(child: CircularProgressIndicator(),) : currentState == MobileVerificationState.showMobileFormState ?
        getMobileFormWidget(context) : getMobileOtpWidget(context),
      ),
    );
  }

}
