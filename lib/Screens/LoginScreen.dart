import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_app/Screens/HomeScreen.dart';
import 'package:sports_app/Screens/verify.dart';
import 'package:sports_app/Widgets/square_tile.dart';

// ignore: must_be_immutable
class PhoneNumberPage extends StatelessWidget {
  PhoneNumberPage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegExp phoneNumberRegex = RegExp(r'^01[0-9]{9}$');
  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff242C3B),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 7),
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: SizedBox(
                      child: Image.asset("assets/Logos/Sport News.png"),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      validator: (value) {
                        if (phoneNumberRegex.hasMatch(value!) == false) {
                          return 'Invalid Phone number';
                        } else {
                          phoneNumber = value;
                          return null;
                        }
                      },
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red[400]),
                        contentPadding: const EdgeInsets.all(15),
                        prefixIcon: const Icon(Icons.phone,
                            color: Color.fromARGB(255, 145, 142, 142),
                            size: 30),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Phone number',
                        hintStyle: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CodePage(phoneNumber: phoneNumber),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.8, 60),
                      shadowColor: Colors.black,
                      elevation: 10,
                      backgroundColor: Color.fromARGB(255, 0, 27, 164),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        InkWell(
                          onTap: () async {
                            try {
                              await signingWithGoogle();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error signing in with Google: $e')),
                              );
                            }
                          },
                          child: const SquareTile(
                              imagePath: 'assets/Logos/google.png'),
                        ),
                        SizedBox(width: 40),
                        SquareTile(imagePath: 'assets/Logos/apple.png')
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signingWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        throw Exception('Google sign-in failed');
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(authCredential);

      User? user = userCredential.user;
      if (user == null) {
        throw Exception('User credential is null');
      }
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('google_logedin', true);
      prefs.setBool('phone_logedin', false);
      String? googleName = user.displayName;
      String? googlePhoto = user.photoURL;
      String? googleEmail = user.email;
      String? googleNumber = user.phoneNumber;
      prefs.setString('google_name', googleName ?? '');
      prefs.setString('google_photo', googlePhoto ?? '');
      prefs.setString('google_email', googleEmail ?? '');
      prefs.setString('google_number', googleNumber ?? '');
    } catch (e) {
      throw Exception('Error during Google sign-in: $e');
    }
  }
}
