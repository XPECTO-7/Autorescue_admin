import 'package:autorescue_admin/Colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPanelPage extends StatefulWidget {
  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  final ScrollController _scrollController = ScrollController();
  Map<String, String> approvalStatus = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Provider Verification',
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.ubuntu().fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.appPrimary,
            ),
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset - MediaQuery.of(context).size.width,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: AppColors.appPrimary,
            ),
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset + MediaQuery.of(context).size.width,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('PROVIDERS')
                .orderBy('Regtime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              }
              List<DataRow> rows =
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                approvalStatus[document.id] = document['Approved'] ?? 'Pending';
                return DataRow(cells: [
                  DataCell(_buildButton(document, 'Pending')),
                  DataCell(_buildButton(document, 'Accepted')),
                  DataCell(_buildButton(document, 'Rejected')),
                  DataCell(Text(document['Fullname'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(document['Email'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(document['Phone Number'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(document['Aadhar Number'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "View",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Service Provider : ${document['Fullname'] ?? ''}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily:
                                            GoogleFonts.ubuntu().fontFamily,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    document["Aadhar Photo"] ??
                                                        ""),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  DataCell(Text(document['Service Type'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(document['Company Name'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(
                    Text(
                      '${document['Experience'] ?? ''} years',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(Text(document['Insurance No'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(document['License No'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(document['Min Price'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                ]);
              }).toList();

              return DataTable(
                columns: const [
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Verification ongoing',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.yellow),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Approved Service',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Issues detected',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Full Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Phone Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Aadhar Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Aadhar Photo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Service Type',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Company Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Experience',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Insurance No',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'License No',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Center(
                      child: Text(
                        'Min Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                rows: rows,
                dataRowColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.white;
                }),
                dataRowHeight: 60.0,
                dataTextStyle: TextStyle(
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                  color: Colors.black87,
                ),
                border: TableBorder.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                headingRowColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.black87;
                }),
                headingTextStyle: TextStyle(
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildButton(DocumentSnapshot document, String status) {
    Color? color;

    if (approvalStatus[document.id] == status) {
      if (status == 'Pending') {
        color = Colors.yellow;
      } else if (status == 'Accepted') {
        color = Colors.green;
      } else if (status == 'Rejected') {
        color = Colors.red;
      }
    }

    return ElevatedButton(
      child: Text(
        status,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(color ?? Colors.white),
      ),
      onPressed: () {
        FirebaseFirestore.instance
            .collection('PROVIDERS')
            .doc(document.id)
            .update({
          'Approved': status,
        }).then((value) {
          setState(() {
            approvalStatus[document.id] = status;
          });
        });
      },
    );
  }
}
