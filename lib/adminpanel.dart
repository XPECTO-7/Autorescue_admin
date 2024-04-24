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
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset - MediaQuery.of(context).size.width,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('PROVIDERS').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
                DataCell(Text(document['Fullname'] ?? '')),
                DataCell(Text(document['Email'] ?? '')),
                DataCell(Text(document['Phone Number'] ?? '')),
                DataCell(Text(document['Aadhar Number'] ?? '')),
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
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(document["Aadhar Photo"] ?? ""),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 1,
                                      child: Text(
                                        document['Fullname'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                DataCell(Text(document['Service Type'] ?? '')),
                DataCell(Text(document['Company Name'] ?? '')),
                DataCell(
                  Text(
                    '${document['Experience'] ?? ''} years',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
                DataCell(Text(document['Insurance No'] ?? '')),
                DataCell(Text(document['License No'] ?? '')),
                DataCell(Text(document['Min Price'] ?? '')),
              ]);
            }).toList();

            return DataTable(
              columns: const [
                DataColumn(label: Text('Pending', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Accepted', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Rejected', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Aadhar Number', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Aadhar Photo', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Service Type', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Company Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Experience', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Insurance No', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('License No', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Min Price', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: rows,
              dataRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
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
              headingRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
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
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color ?? Colors.white),
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
