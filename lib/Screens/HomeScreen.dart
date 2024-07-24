import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_app/Widgets/DrawerClass.dart';
import 'package:sports_app/Screens/CountriesScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: myDrawer(),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 1 / 15,
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 0, 27, 164),
          title: Text(
            "SPORTS",
            style: GoogleFonts.lato(color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
          leading: Builder(builder: (context) {
            return IconButton(
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          }),
        ),
        body: Center(
          child: Container(
            color: Color(0xff242C3B),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: ((MediaQuery.of(context).size.width) /
                    (MediaQuery.of(context).size.height -
                        20 -
                        MediaQuery.of(context).size.height * 1 / 6)),
                crossAxisCount: 2,
                children: [
                  buildGridItem(
                    context,
                    'assets/Logos/soccer-ball-green-grass-soccer-field-generative-ai 1.png',
                    'assets/Logos/f (2).png',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              FootballCountriesView(),
                        ),
                      );
                    },
                  ),
                  buildGridItem(
                    context,
                    'assets/Logos/b (2).png',
                    'assets/Logos/close-up-basketball-outdoors 1.png',
                    () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Not Available yet'),
                              content: const Text(
                                'Coming Soon...',
                                style: TextStyle(fontSize: 15),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  buildGridItem(
                    context,
                    'assets/Logos/2d729a58aaf7e8c94affa63fc176e300 1.png',
                    'assets/Logos/c (2).png',
                    () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Not Available yet'),
                              content: const Text(
                                'Coming Soon...',
                                style: TextStyle(fontSize: 15),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  buildGridItem(
                    context,
                    'assets/Logos/t (2).png',
                    'assets/Logos/Group 143726072.png',
                    () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Not Available yet'),
                              content: const Text(
                                'Coming Soon...',
                                style: TextStyle(fontSize: 15),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildGridItem(
      BuildContext context, String image1, String image2, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Image.asset(image1),
              SizedBox(
                height: 20,
              ),
              Image.asset(image2),
            ],
          ),
        ),
      ),
    );
  }
}
