import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/res/hive_style.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notifications = true;
  bool hideGoals = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HiveColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text("Profile", style: HiveStyle.boldTitle.copyWith(color: HiveColors.platinum)),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 100, color: HiveColors.background),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: HiveColors.yellow,
                        child: Icon(Icons.edit, color: HiveColors.darkPurple, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              buildTextField("Name:", "John Doe"),
              buildTextField("Username:", "johndoe123"),
              buildTextField("Email:", "johndoe123@gmail.com"),
              buildPasswordTextField("Password:", "************"),
              buildToggle("Notifications:", notifications, (val) {
                setState(() {
                  notifications = val;
                });
              }),
              buildToggle("Hide Goals:", hideGoals, (val) {
                setState(() {
                  hideGoals = val;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(label, style: HiveStyle.boldBody.copyWith(color: HiveColors.steel)),
          SizedBox(height: 5),
          TextField(
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

Widget buildPasswordTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 5),
          TextField(
            obscureText: obscurePassword,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,              
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.check : Icons.visibility_off,
                  color: HiveColors.darkPurple,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToggle(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: HiveStyle.boldBody.copyWith(color: HiveColors.steel)),
          FlutterSwitch(
            width: 50,
            height: 25,
            toggleSize: 20,
            activeColor: HiveColors.yellow,
            inactiveColor: HiveColors.steel,
            value: value,
            onToggle: onChanged,
          ),
        ],
      ),
    );
  }
}
