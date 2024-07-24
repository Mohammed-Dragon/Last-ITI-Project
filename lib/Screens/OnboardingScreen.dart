import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_app/Cubits/SliderCubit/slider_cubit.dart';
import 'package:sports_app/Screens/LoginScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sports_app/Widgets/my_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _titles = [
    "News From All Countries",
    "Discover Exciting Leagues",
    "Team And Players Profiles"
  ];

  final List<String> _subtitles = [
    "Choose your favorite football nation to explore leagues, teams, and players.",
    "Explore top football leagues from around the world and stay updated with the latest scores and standings.",
    "Dive into the world of football stars. Learn about their careers, achievements, and stats."
  ];

  final CarouselController _carouselController = CarouselController();
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<SliderCubit, SliderState>(
            builder: (context, state) {
              return CarouselSlider(
                items: List.generate(
                  _titles.length,
                  (index) => Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/Images/${index + 1}.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromARGB(100, 0, 0, 0),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _titles[index],
                              style: GoogleFonts.lato(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            Text(
                              _subtitles[index],
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _activePage = index;
                    });
                    context.read<SliderCubit>().Slider();
                  },
                  scrollDirection: Axis.horizontal,
                ),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<SliderCubit, SliderState>(
                  builder: (context, state) {
                    return AnimatedSmoothIndicator(
                      activeIndex: _activePage,
                      count: _titles.length,
                      onDotClicked: (index) {
                        setState(() {
                          _activePage = index;
                        });
                        _carouselController.animateToPage(_activePage);
                        context.read<SliderCubit>().button();
                      },
                      effect: ScrollingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: Color.fromARGB(255, 4, 48, 128),
                      ),
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 20),
                  child: MyButton(
                    text: "Skip",
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('showHome', true);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => PhoneNumberPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
