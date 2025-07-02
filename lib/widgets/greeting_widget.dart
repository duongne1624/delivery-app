import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  final String userName;

  const GreetingWidget({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xin chào, $userName!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 8),
        Text(
          'Hôm nay bạn muốn ăn gì?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
