import 'package:flutter/material.dart';

class AdhaarView extends StatelessWidget {
  final String image;
  const AdhaarView({super.key,required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Expanded(child:  Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(image))),
                        ),),
    );
  }
}