import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:liveasy/screen/language.dart';
import 'package:liveasy/screen/profile.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LanguageSelect(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String verId;
  late String phone;
  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            codeSent
                ? OTPTextField(
              length: 6,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 30,
              style: TextStyle(fontSize: 20),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                verifyPin(pin);
              },
            )
                : IntlPhoneField(
              decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderSide: BorderSide())),
              initialCountryCode: 'IN',
              onChanged: (phoneNumber) {
                setState(() {
                  phone = phoneNumber.completeNumber;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),


            Container(
              width: 256,
              height: 48,
              margin: const EdgeInsets.all(48),
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    Expanded(child: Center(child: Text('VERIFY'))),
                  ],
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                onPressed: () {
                  log('Forwarding to verify phone');
                  verifyPhone();
                },
              ),
            ),


          ],


        ),
      ),
    );
  }

  Future<void> verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          final snackBar = SnackBar(content: Text("Login Success"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MyStatefulWidget()));
          log('Forwarding to profile');

        },
        verificationFailed: (FirebaseAuthException e) {
          final snackBar = SnackBar(content: Text("${e.message}"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeSent:(verficationId,  resendToken) {
          setState(() {
            codeSent = true;
            verId = verficationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verId = verificationId;
          });
        },
        timeout: Duration(seconds: 60));
  }

  Future<void> verifyPin(String pin) async {
    PhoneAuthCredential credential =
    PhoneAuthProvider.credential(verificationId: verId, smsCode: pin);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final snackBar = SnackBar(content: Text("Login Success"));
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSelect()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text("${e.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
