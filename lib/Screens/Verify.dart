import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:sports_app/Cubits/Circular_Indicator_Cubit/circular_indicator_cubit.dart';
import 'package:sports_app/Screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodePage extends StatefulWidget {
  final String? phoneNumber;
  const CodePage({required this.phoneNumber, super.key});

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? otpCode;
  String? randomOtp;
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateOtp();
  }

  void _generateOtp() {
    var random = Random();
    var tempOtp = random.nextInt(8) + 1;
    randomOtp = (random.nextInt(1000) + (1000 * tempOtp)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff242C3B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xff242C3B),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 7,
                  ),
                  Image.asset(
                    "assets/Images/Page-1.png",
                    height: MediaQuery.of(context).size.height * 1 / 4.5,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 50,
                  ),
                  const Text(
                    "Verification",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Pinput(
                      controller: _pinController,
                      length: 4,
                      onChanged: (value) {
                        otpCode = value;
                      },
                      onCompleted: (value) {
                        if (otpCode != randomOtp) {
                          _pinController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Incorrect code. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      defaultPinTheme: PinTheme(
                        width: 75,
                        height: 75,
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 75,
                        height: 75,
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                          color: Colors.white,
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 75,
                        height: 75,
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  BlocBuilder<CircularIndicatorCubit, CircularIndicatorState>(
                    builder: (context, state) {
                      final isLoading = state is CircularIndicatorLoading;
                      return ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              otpCode == randomOtp) {
                            context.read<CircularIndicatorCubit>().Circular();
                            await Future.delayed(const Duration(seconds: 3));
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const HomeScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('phone_logedin', true);
                            prefs.setBool('google_logedin', false);
                            prefs.setString(
                                'phone_number', widget.phoneNumber!);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 0.8, 60),
                          shadowColor: Colors.black,
                          elevation: 10,
                          backgroundColor:
                              const Color.fromARGB(255, 0, 27, 164),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text(
                                      '  Please Wait...',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            : const Text(
                                'Verifying',
                                style: TextStyle(color: Colors.white),
                              ),
                      );
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            _generateOtp();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Verification Code',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: SizedBox(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                            'You should write it in the verification code place'),
                                        Text(
                                          randomOtp!,
                                          style: const TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Send new verification code?',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
