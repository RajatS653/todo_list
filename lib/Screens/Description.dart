import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description_Screen extends StatefulWidget {
  final String Title, Description;
  const Description_Screen(
      {super.key, required this.Title, required this.Description});

  @override
  State<Description_Screen> createState() => _Description_ScreenState();
}

class _Description_ScreenState extends State<Description_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Description",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    widget.Title,
                    style: GoogleFonts.roboto(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    widget.Description,
                    style: GoogleFonts.roboto(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
