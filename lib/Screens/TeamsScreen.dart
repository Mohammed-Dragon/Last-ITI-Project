import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_app/Cubits/PlayersCubit/players_cubit.dart';
import 'package:sports_app/Cubits/TeamsCubit/get_goals_cubit.dart';
import 'package:sports_app/Cubits/TeamsCubit/get_teams_cubit.dart';
import 'package:sports_app/Data/Repository/get_players_repo.dart';
import 'package:sports_app/Data/Repository/get_teams_data_repo.dart';
import 'package:sports_app/Screens/PlayersScreen.dart';
import 'package:sports_app/Widgets/DrawerClass.dart';

class TeamsScreen extends StatelessWidget {
  TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Stack(children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 0, 27, 164),
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height * (1 / 50),
              bottom: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Color.fromARGB(172, 194, 198, 255),
                tabs: [
                  Tab(
                    child: Text(
                      "Teams",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Top Scorers",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                  color: Color(0xff242C3B),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  // color: Colors.red,
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
                              team_name = text;
                              league_id = temp2;
                              context.read<GetGoalsCubit>().getGoals();
                              context.read<GetTeamsCubit>().getTeams();
                            },
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.search,
                                  color: Color.fromARGB(255, 145, 142, 142),
                                  size: 25),
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
                        BlocBuilder<GetTeamsCubit, GetTeamsState>(
                            builder: (context, state) {
                          if (state is GetTeamsInitial) {
                            return const Center(
                              child: Text('There is no data'),
                            );
                          } else if (state is GetTeamsLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is GetTeamsSuccess) {
                            return Expanded(
                                child: Column(
                              children: [
                                Expanded(
                                    child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: state.teamsresponse.result.length,
                                  itemBuilder: (context, index) {
                                    team_id = state.teamsresponse.result[index]
                                            .teamKey ??
                                        10;
                                    print(team_id);
                                    return InkWell(
                                      onTap: () {
                                        player_name = "";
                                        team_name = state.teamsresponse
                                                .result[index].teamName ??
                                            "";
                                        team_id = state.teamsresponse
                                                .result[index].teamKey ??
                                            10;
                                        context
                                            .read<GetPlayersCubit>()
                                            .getPlayers();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PlayersScreen(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 145, 142, 142),
                                              width: 1.6,
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Center vertically
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center, // Center horizontally
                                            children: [
                                              Image.network(
                                                state.teamsresponse
                                                    .result[index].teamLogo
                                                    .toString(),
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.network(
                                                      width: 70,
                                                      height: 70,
                                                      "https://upload.wikimedia.org/wikipedia/ar/f/f7/Fifa-logo.png?20140204004927");
                                                },
                                                width: 70,
                                                height: 70,
                                              ),
                                              SizedBox(
                                                  height:
                                                      8), // Add some space between image and text
                                              Text(
                                                state
                                                        .teamsresponse
                                                        .result[index]
                                                        .teamName ??
                                                    "",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign
                                                    .center, // Center the text within its own bounds
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                ))
                              ],
                            ));
                          } else {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Invalid Search",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        })
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff242C3B),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      BlocBuilder<GetGoalsCubit, GetGoalsState>(
                          builder: (context, state) {
                        if (state is GetGoalsInitial) {
                          return const Center(
                            child: Text(''),
                          );
                        } else if (state is GetGoalsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is GetGoalsSuccess) {
                          return Expanded(
                              child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 90),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount:
                                          state.goalsresponse.result.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: 80,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 145, 142, 142),
                                              width: 1.6,
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(6.5),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Row(
                                              children: [
                                                Text(
                                                  (index + 1).toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 15, 47, 207),
                                                  ),
                                                ),
                                                Spacer(),
                                                Column(
                                                  children: [
                                                    Text(
                                                      state
                                                          .goalsresponse
                                                          .result[index]
                                                          .playerName,
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      "penalty goals " +
                                                          state
                                                              .goalsresponse
                                                              .result[index]
                                                              .penaltyGoals
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.5)),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  state.goalsresponse
                                                      .result[index].teamName,
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                Spacer(),
                                                Text(
                                                  state.goalsresponse
                                                      .result[index].goals
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }))
                            ],
                          ));
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: const Center(
                              child: Text(
                                'There is no data here',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          );
                        }
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Builder(builder: (context) {
              return Container(
                margin: const EdgeInsets.only(top: 40),
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
              );
            }),
          )
        ]),
      ),
      drawer: const myDrawer(),
    );
  }
}
