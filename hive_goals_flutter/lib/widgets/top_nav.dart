import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/res/hive_text.dart';
import 'package:hive_goals_flutter/services/app_state.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: HiveColors.background,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HiveText.normalTitle(title),
            CircleAvatar(
              radius: 24,
              backgroundColor: HiveColors.platinum,
              child: IconButton(
                padding: EdgeInsets.zero,
                  icon: const Icon(Icons.person_outline, color: HiveColors.darkPurple, size: 40),
                  onPressed: () {AppState().changeTabCallback?.call(9);},
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
