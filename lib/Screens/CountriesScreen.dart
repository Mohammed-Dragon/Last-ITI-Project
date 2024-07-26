// ignore_for_file: prefer_typing_uninitialized_variables, unused_field, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sports_app/Cubits/FootballCountries/football_countries_cubit.dart';
import 'package:sports_app/Data/Repository/get_League_Repo.dart';
import 'package:sports_app/Widgets/AppBar.dart';
import 'package:sports_app/Widgets/DrawerClass.dart';
import 'package:sports_app/Screens/LeagueScreen.dart';

class FootballCountriesView extends StatefulWidget {
  const FootballCountriesView({super.key});

  @override
  State<FootballCountriesView> createState() => _FootballCountriesViewState();
}

class _FootballCountriesViewState extends State<FootballCountriesView> {
  final ScrollController _scrollController = ScrollController();

  double rowHeight = 80;

  Position? _currentLocation;
  late bool servicePermeation = false;
  late LocationPermission permission;

  var _currentAdress;
  var _currentName;
  var _country_name;
  var _country_number;
  var _country_index;
  var countries_name = [];
  final itemController = ItemScrollController();
  final itemListener = ItemPositionsListener.create();

  List<Map<String, dynamic>> fou = [];

  @override
  void initState() {
    super.initState();
  }

  Future<Position> _getCurrentLocation() async {
    servicePermeation = await Geolocator.isLocationServiceEnabled();
    if (!servicePermeation) {
      print("service disabled");
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAdress = "${place.administrativeArea}, ${place.country}";
        _country_name = place.country;
        _currentName = place.country;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const myDrawer(),
      appBar: const MyAppBar(text: "COUNTRIES"),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 16,
            bottom: 10,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 0, 27, 164),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              onPressed: () async {
                try {
                  _currentLocation = await _getCurrentLocation();
                  await _getAddressFromCoordinates();
                  print(_currentLocation);
                  for (int i = 0; i < _country_number; i++) {
                    if (_country_name == countries_name[i]) {
                      _country_index = i;
                    }
                  }
                  print('test here');
                  print(_country_name);
                  double offset = (_country_index / 3) * (rowHeight + 50);
                  _scrollController.animateTo(
                    offset,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                  );

                  print(_country_index);
                } catch (e) {
                  print('Error: $e');
                }
              },
              child: const Icon(
                Icons.location_on,
                color: Colors.white,
              ),
            ),
          ),
          if (_currentAdress != null)
            Positioned(
              right: 80,
              bottom: 25,
              child: Text(
                _currentAdress,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Container(
        color: const Color(0xff242C3B),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 30),
            Expanded(
              child: Container(
                child:
                    BlocBuilder<FootballCountriesCubit, FootballCountriesState>(
                  builder: (context, state) {
                    if (state is FootballCountriesSuccess) {
                      for (int i = 0; i < state.response.result.length; i++) {
                        countries_name.add(
                            state.response.result[i].countryName.toString());
                      }
                      return GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: state.response.result.length,
                        itemBuilder: (context, index) {
                          _country_number = state.response.result.length;
                          return Padding(
                            padding: const EdgeInsets.all(0),
                            child: GestureDetector(
                              onTap: () {
                                country_Id =
                                    state.response.result[index].countryKey;
                                print(country_Id);
                                context
                                    .read<FootballCountriesCubit>()
                                    .getCountries();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LeagueScreen(),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: rowHeight,
                                    decoration: BoxDecoration(
                                      border: index == _country_index
                                          ? Border.all(
                                              color: const Color.fromARGB(
                                                  255, 24, 202, 24),
                                              width: 6)
                                          : null,
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          state.response.result[index]
                                                  .countryLogo ??
                                              "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Flag_of_Cuba.svg/420px-Flag_of_Cuba.svg.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Center(
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        state.response.result[index]
                                                .countryName ??
                                            "countryName",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          letterSpacing: 0.5,
                                          wordSpacing: -0.50,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is FootballCountriesError) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else {
                      return FutureBuilder<void>(
                        future: context
                            .read<FootballCountriesCubit>()
                            .getCountries(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const Center(
                              child:
                                  Text("An error occurred while loading data."),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
