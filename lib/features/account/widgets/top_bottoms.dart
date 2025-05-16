import 'package:flutter/material.dart';
import 'package:nukdi2/features/account/widgets/account_button.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({Key? key}) : super(key: key);

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Your orders', onTap: () {}),
            AccountButton(text: 'Your wishlist', onTap: () {}),
          ],
        ),
        const SizedBox(height: 10),
        Row(children: [AccountButton(text: 'Log out', onTap: () {})]),
      ],
    );
  }
}
