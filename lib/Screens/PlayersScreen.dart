import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sports_app/Cubits/PlayersCubit/players_cubit.dart';
import 'package:sports_app/Data/Repository/get_players_repo.dart';
import 'package:sports_app/Data/Repository/get_teams_data_repo.dart';
import 'package:sports_app/Widgets/DrawerClass.dart';

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const myDrawer(),
      appBar: AppBar(
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
        toolbarHeight: MediaQuery.of(context).size.height * (1 / 15),
        backgroundColor: const Color.fromARGB(255, 0, 27, 164),
        centerTitle: true,
        title: Text(
          '$team_name Players',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color(0xff242C3B),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 10, left: 5, right: 5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.2,
                child: TextField(
                  onChanged: (text) {
                    player_name = text;
                    team_id = temp;
                    context.read<GetPlayersCubit>().getPlayers();
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search,
                        color: Color.fromARGB(255, 145, 142, 142), size: 25),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                ),
              ),
              BlocBuilder<GetPlayersCubit, GetPlayersState>(
                  builder: (context, state) {
                if (state is GetPlayersInitial) {
                  return const Center(
                    child: Text('Please press the button to get news'),
                  );
                } else if (state is GetPlayersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetPlayersSuccess) {
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Player\'s info',
                                        style: GoogleFonts.lato(),
                                      ),
                                      content: SingleChildScrollView(
                                        child: BlocBuilder<GetPlayersCubit,
                                            GetPlayersState>(
                                          builder: (context, state) {
                                            if (state is GetPlayersLoading) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (state
                                                is GetPlayersSuccess) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              1 /
                                                              3,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  145,
                                                                  142,
                                                                  142),
                                                              width: 1.6,
                                                            ),
                                                          ),
                                                          child: Image.network(
                                                            state
                                                                    .playersresponse
                                                                    .result[
                                                                        index]
                                                                    .playerImage ??
                                                                "https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1721606400&semt=sph",
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Image.network(
                                                                  "https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1721606400&semt=sph");
                                                            },
                                                            fit: BoxFit
                                                                .cover, // Use cover to maintain aspect ratio and fill the container
                                                          ),
                                                        ),
                                                      )),
                                                  Center(
                                                    child: Text(
                                                      state
                                                          .playersresponse
                                                          .result[index]
                                                          .playerName,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Number : ${state.playersresponse.result[index].playerNumber ?? "No data"}",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Country : ${state.playersresponse.result[index].playerCountry ?? "No data"}",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Matches Played : ${state.playersresponse.result[index].playerMatchPlayed ?? "No data"}",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Age : ${state.playersresponse.result[index].playerAge}",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Yellow Cards Num : ${state.playersresponse.result[index].playerYellowCards ?? "No data"}",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Red Cards Num : ${state.playersresponse.result[index].playerRedCards ?? "No data"}",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Goals : ${state.playersresponse.result[index].playerGoals ?? "No data"}",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Assists : ${state.playersresponse.result[index].playerAssists ?? "No data"}",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return const Center(
                                                child: Text(
                                                    "Something wrong happened"),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("Share Player"),
                                          onPressed: () {
                                            Share.share(
                                                "Name : ${state.playersresponse.result[index].playerName}\nNumber : ${state.playersresponse.result[index].playerNumber ?? ""}");
                                          },
                                        ),
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
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 145, 142, 142),
                                    width: 1.6,
                                  ),
                                ),
                                margin: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Image.network(
                                      state.playersresponse.result[index]
                                              .playerImage ??
                                          "https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1721606400&semt=sph",
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.network(
                                            "https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1721606400&semt=sph");
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      state.playersresponse.result[index]
                                          .playerName
                                          .toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: state.playersresponse.result.length,
                        ))
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Invalid Search'),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
