import 'package:flutter/material.dart';
import 'package:sports_app/Widgets/AppBar.dart';
import 'package:sports_app/Widgets/DrawerClass.dart';
import 'package:sports_app/Screens/CountriesScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const myDrawer(),
        appBar: const MyAppBar(text: "SPORTS"),
        body: Center(
          child: Container(
            color: const Color(0xff242C3B),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: ((MediaQuery.of(context).size.width) /
                    (MediaQuery.of(context).size.height -
                        20 -
                        MediaQuery.of(context).size.height * 1 / 4)),
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
                              const FootballCountriesView(),
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
                                    Navigator.of(context).pop();
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
                                    Navigator.of(context).pop();
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
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
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
              const SizedBox(
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
