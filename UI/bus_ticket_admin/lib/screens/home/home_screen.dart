import 'package:bus_ticket_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_translate/flutter_translate.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: SingleChildScrollView(
        child: Container(
          child: Center(
            heightFactor: 0.5,
            child: Image.asset(
              'assets/images/bus_logo.png',
              fit: BoxFit.contain,
              // optionally set width/height:
              // width: 150,
              // height: 150,
            ),
          ),
        ),
      ),
    );
  }
}

