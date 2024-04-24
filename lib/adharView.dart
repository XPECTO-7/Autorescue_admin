import 'package:flutter/material.dart';

class AdhaarView extends StatelessWidget {
  final String image;

  const AdhaarView({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(
          image,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }
            return const CircularProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            return Text('Failed to load image: $error');
          },
        ),
      ),
    );
  }
}
