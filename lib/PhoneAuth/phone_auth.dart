import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final OtpFieldController _otpController = OtpFieldController();
 late final FirebaseAuth auth ;
  String _mVerificationId="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth= FirebaseAuth.instance;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Authentication")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Otp Verification",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
            SizedBox(height: 50,),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400
              ),
              onPressed: (){

                auth.setSettings(forceRecaptchaFlow: false,appVerificationDisabledForTesting: true);

                auth.verifyPhoneNumber(
                  phoneNumber: '+91${_phoneController.text.toString()
                  }',

                  verificationCompleted: (PhoneAuthCredential credential){
                    auth.signInWithCredential(credential).then((value) {
                      print("Logged in: ${value.user!.uid}");
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Phone number verified successfully!")));
                  },

                  verificationFailed: (FirebaseAuthException e) {
                    if (e.code == 'invalid-phone-number') {
                      print('Verification failed:The provided phone number is not valid.${e.message}');
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Verification failed: ${e.message}")));
                  },

                  codeSent: (String verificationId, int? resendToken){

                    _mVerificationId=verificationId;
                    print("CodeSent: ${_mVerificationId}");

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("OTP Sent Successfully!")));
                  },
                  // timeout: const Duration(seconds: 60),
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );

              },
              // onPressed: _verifyPhoneNumber,
              child: const Text("Send OTP",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            const SizedBox(height: 20),
            OTPTextField(
              controller: _otpController,
              length: 6,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 50,
              style: const TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              onCompleted: (pin) => (){
                // Update the UI - wait for the user to enter the SMS code
                String otp = "${_otpController.toString()}";

                // Create a PhoneAuthCredential with the code
                var credential = PhoneAuthProvider.credential(verificationId: _mVerificationId, smsCode: pin);

                // Sign the user in (or link) with the credential
                auth.signInWithCredential(credential).then((value) {
                  print("Logged in: ${value.user!.uid}");
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("OTP verified successfully!")));

              },

              // onCompleted: (pin) => _verifyOTP(pin),
            ),
          ],
        ),
      ),
    );
  }
}





/*void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Phone number verified successfully!")));
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP Sent Successfully!")));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _verifyOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP verified successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP. Try again.")));
    }
  }*/


//  var cred = PhoneAuthProvider.credential(verificationId: _mVerificationId, smsCode: _otpController.toString());
//                 auth
//                     .signInWithCredential(cred)
//                     .then((value) {
//                   print("Logged in: ${value.user!.uid}");
//                 });