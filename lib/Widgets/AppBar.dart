import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const MyAppBar({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.0,
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 0, 27, 164),
      title: Text(
        text,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
