import 'package:flutter/material.dart';
import 'package:shopping_app/screens/shared_components/primary_action_button.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops!...',
              style: TextStyle(fontSize: 60.0, color: Colors.teal),
            ),
            const Text(
              'Could not find this page',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            PrimaryActionButton(
              onTap: () => Navigator.pop(context),
              text: 'Go back',
              width: 200.0,
            )
          ],
        ),
      ),
    );
  }
}
