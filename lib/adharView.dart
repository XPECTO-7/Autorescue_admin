// import 'package:flutter/material.dart';

// class AdhaarView extends StatelessWidget {
//   final String image;

//   const AdhaarView({Key? key, required this.image}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Image.network(
//           image,
//           loadingBuilder: (context, child, progress) {
//             if (progress == null) {
//               return child;
//             }
//             return const CircularProgressIndicator();
//           },
//           errorBuilder: (context, error, stackTrace) {
//             return Text('Failed to load image: $error');
//           },
//         ),
//       ),
//     );
//   }
// }
// SizedBox(
//                                       width: MediaQuery.of(context).size.width *
//                                           0.5,
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.5,
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Container(
//                                             decoration: BoxDecoration(
//                                               image: DecorationImage(
//                                                 image: NetworkImage(
//                                                     document["Aadhar Photo"] ??
//                                                         ""),
//                                                 fit: BoxFit.contain,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
