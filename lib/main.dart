import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_app/Cubits/Circular_Indicator_Cubit/circular_indicator_cubit.dart';
import 'package:sports_app/Cubits/FootballCountries/football_countries_cubit.dart';
import 'package:sports_app/Cubits/LeagueCubit/league_cubit.dart';
import 'package:sports_app/Cubits/PlayersCubit/players_cubit.dart';
import 'package:sports_app/Cubits/SliderCubit/slider_cubit.dart';
import 'package:sports_app/Cubits/TeamsCubit/get_goals_cubit.dart';
import 'package:sports_app/Cubits/TeamsCubit/get_teams_cubit.dart';
import 'package:sports_app/Screens/SplashScreen.dart';
import 'package:sports_app/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SliderCubit>(
          create: (BuildContext context) => SliderCubit(),
        ),
        BlocProvider<FootballCountriesCubit>(
          create: (BuildContext context) => FootballCountriesCubit(),
        ),
        BlocProvider<LeagueCubit>(
          create: (BuildContext context) => LeagueCubit(),
        ),
        BlocProvider<GetTeamsCubit>(
          create: (BuildContext context) => GetTeamsCubit(),
        ),
        BlocProvider<GetGoalsCubit>(
          create: (BuildContext context) => GetGoalsCubit(),
        ),
        BlocProvider<GetPlayersCubit>(
          create: (BuildContext context) => GetPlayersCubit(),
        ),
        BlocProvider<CircularIndicatorCubit>(
          create: (BuildContext context) => CircularIndicatorCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sports App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 50, 85, 225),
          ),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
