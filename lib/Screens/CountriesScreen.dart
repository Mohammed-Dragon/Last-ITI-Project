import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sports_app/Cubits/FootballCountries/football_countries_cubit.dart';
import 'package:sports_app/Data/Repository/get_League_Repo.dart';
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
  bool servicePermission = false;
  LocationPermission? permission;

  String? _currentAddress;
  String? _countryName;
  int _countryIndex = -1; // Initialize to -1
  List<String> countriesName = [];

  final itemController = ItemScrollController();
  final itemListener = ItemPositionsListener.create();

  List<Map<String, dynamic>> fou = [];

  @override
  void initState() {
    super.initState();
  }

  Future<Position> _getCurrentLocation() async {
    try {
      servicePermission = await Geolocator.isLocationServiceEnabled();
      if (!servicePermission) {
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
        return Future.error('Location permissions are permanently denied.');
      }
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return Future.error('Failed to get location: $e');
    }
  }

  Future<void> _getAddressFromCoordinates() async {
    if (_currentLocation == null) return; // Check for null
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.administrativeArea}, ${place.country}";
        _countryName = place.country;
      });
    } catch (e) {
      print('Failed to get address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const myDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 27, 164),
        leading: Builder(builder: (context) {
          return IconButton(
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          );
        }),
        automaticallyImplyLeading: false,
        title: const Text(
          "Countries",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
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
                  print('Fetching current location...');
                  _currentLocation = await _getCurrentLocation();
                  print('Location fetched: $_currentLocation');
                  await _getAddressFromCoordinates();
                  print('Address fetched: $_currentAddress');

                  if (_countryName != null) {
                    for (int i = 0; i < countriesName.length; i++) {
                      if (_countryName == countriesName[i]) {
                        _countryIndex = i;
                        print('Country index found: $_countryIndex');
                        break; // Exit the loop early once the index is found
                      }
                    }

                    if (_countryIndex >= 0 &&
                        _countryIndex < countriesName.length) {
                      double offset = (_countryIndex / 3) * (rowHeight + 21);
                      print('Scrolling to offset: $offset');
                      _scrollController.animateTo(
                        offset,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      print('Invalid country index: $_countryIndex');
                    }
                  }
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
          if (_currentAddress != null)
            Positioned(
              right: 80,
              bottom: 25,
              child: Text(
                _currentAddress!,
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
              child:
                  BlocBuilder<FootballCountriesCubit, FootballCountriesState>(
                builder: (context, state) {
                  if (state is FootballCountriesSuccess) {
                    countriesName.clear(); // Clear previous data
                    for (int i = 0; i < state.response.result.length; i++) {
                      countriesName
                          .add(state.response.result[i].countryName.toString());
                    }
                    return GridView.builder(
                      controller: _scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: state.response.result.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(0),
                          child: GestureDetector(
                            onTap: () {
                              country_Id =
                                  state.response.result[index].countryKey;
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
                                    border: _countryIndex == index
                                        ? Border.all(
                                            color: const Color.fromARGB(
                                                255, 37, 205, 11),
                                            width: 6,
                                          )
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
                      future:
                          context.read<FootballCountriesCubit>().getCountries(),
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
          ],
        ),
      ),
    );
  }
}
