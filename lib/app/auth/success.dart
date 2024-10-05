import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  const Success({super.key});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Account Created Successfully , now you can Login !",
              style: TextStyle(fontSize: 16),
            ),
          ),
          MaterialButton(
            textColor: Colors.white,
            color: Colors.blue,
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: Text('Login'),
          )
        ],
      ),
    );
  }
}
