import 'package:autorescue_admin/adharView.dart';
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
          'Admin Panel',
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.ubuntu().fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('PROVIDERS').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
                      border: Border.all(color: Colors.blue), // Example border
                      borderRadius:
                          BorderRadius.circular(10), // Example border radius
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
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AdhaarView(
                        image: document["Aadhar Photo"] ?? "",
                      );
                    },
                  ));
                },
              ),
              DataCell(Text(document['Service Type'] ?? '')),
              DataCell(Text(document['Company Name'] ?? '')),
              DataCell(Text(document['Experience'] ?? '')),
              DataCell(Text(document['Insurance No'] ?? '')),
              DataCell(Text(document['License No'] ?? '')),
              DataCell(Text(document['Min Price'] ?? '')),
            ]);
          }).toList();

          return SingleChildScrollView(
            controller: _scrollController, // Use the scroll controller here
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(
                    label: Text('Pending',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Accepted',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Rejected',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Full Name',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Email',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Phone Number',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Aadhar Number',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Aadhar Photo',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Service Type',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Company Name',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Experience',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Insurance No',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('License No',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Min Price',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                // Added column for Aadhar Photo
                // Add more DataColumn widgets for additional headings
              ],
              rows: rows,
              dataRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.white; // Use any color for the data row
              }),
              dataRowHeight: 60.0, // Adjust the row height as needed
              dataTextStyle: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                color: Colors.black87, // Use any text color for the data
              ),
              border: TableBorder.all(
                color: Colors.grey, // Use any border color
                width: 1.0, // Adjust the border width as needed
              ),
              headingRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.black87; // Use any color for the heading row
              }),
              headingTextStyle: TextStyle(
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                color: Colors.white, // Use any text color for the heading text
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
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
