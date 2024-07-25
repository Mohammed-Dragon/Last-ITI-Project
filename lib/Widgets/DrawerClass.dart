import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_app/Screens/LoginScreen.dart';

class myDrawer extends StatefulWidget {
  const myDrawer({super.key});

  @override
  State<myDrawer> createState() => _myDrawerState();
}

var phone;
var name;
var first_name;
var last_name;
bool? google_logedin;
bool? phone_logedin;

class _myDrawerState extends State<myDrawer> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  void initState() {
    super.initState();
    Future<String> abc() async {
      final prefs = await SharedPreferences.getInstance();

      google_logedin = prefs.getBool('google_logedin') ?? false;

      phone_logedin = prefs.getBool('phone_logedin') ?? false;
      String phoneNumber = prefs.getString('phone_number').toString();
      print("*//**//*/**/*/**//**/**//*$phoneNumber");

      String googleName = prefs.getString('google_name') ?? "";
      String googleNumber = prefs.getString('google_number') ?? "";

      for (int i = 0; i < googleName.length; i++) {
        if (googleName[i] == " ") {
          first_name = googleName.substring(0, i);
          last_name = googleName.substring(i, googleName.length);
          i = googleName.length;
        }
      }

      if (google_logedin == true) {
        name = googleName;
        phone = googleNumber;
        setState(() {});
        print("*//**//*/**/*/**//**/**//*$name");
        return phone;
      } else {
        phone = phoneNumber;
        first_name = null;
        last_name = null;
        print("*//**//*/**/*/**//**/**//*$phone");
        setState(() {});
        return name;
      }
    }

    abc();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff242C3B),
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 20, right: 30),
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                child: Image.asset("assets/Logos/Sport News.png"),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            Text(
              "Phone |  ${phone ?? " "}",
              style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            if (google_logedin == true)
              Text(
                "First Name |  ${first_name ?? " "}",
                style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
              ),
            const SizedBox(
              height: 20,
            ),
            if (google_logedin == true)
              Text(
                "Last Name |  ${last_name ?? " "}",
                style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
              ),
            const Spacer(),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    await signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                PhoneNumberPage()),
                        ModalRoute.withName("/"));
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('google_logedin', false);
                    prefs.setBool('phone_logedin', false);
                  },
                  label: Text(
                    'Signout',
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Color.fromARGB(255, 0, 27, 164),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ))
          ],
        )),
      ),
    );
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
