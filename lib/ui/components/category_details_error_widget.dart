import 'package:flutter/material.dart';

class CategoryDetailsErrorWidget extends StatelessWidget {

  const CategoryDetailsErrorWidget({
    required this.errorMessage, super.key,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 50,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(errorMessage),
                const SizedBox(height: 24),
                const Text(
                  'Pull down to refresh',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}