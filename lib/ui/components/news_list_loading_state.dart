import 'package:flutter/material.dart';

class NewsListLoadingState extends StatelessWidget {
  const NewsListLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 50,
          child: const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
