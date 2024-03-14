import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../history_details/history_screen.dart';

class SuggestionsContainer extends StatefulWidget {
  final List<Map<String, String>> locationPairs;
  final List<String> fromLocations;
  final List<String> toLocations;
  final String selectedDate;
  final String selectedTime;
  final String selectedGoodsType;
  final String selectedTruck;
  final String driverName;
  final String driverPhoneNumber;
  final void Function() onClose;
  final BuildContext parentContext;

  const SuggestionsContainer({
    Key? key,
    required this.locationPairs,
    required this.fromLocations,
    required this.toLocations,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedGoodsType,
    required this.selectedTruck,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.onClose,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<SuggestionsContainer> createState() => _SuggestionsContainerState();
}

class _SuggestionsContainerState extends State<SuggestionsContainer> {
  Set<String> acceptedSuggestions = Set();
  bool isAccepted = false;

  Future<void> _acceptButtonPressed(
      String suggestionId, Map<String, dynamic> suggestionData) async {
    try {
      final customerSnapshot = await FirebaseFirestore.instance
          .collection('Transmaa_accepted_orders')
          .doc(suggestionId)
          .get();

      final customerName = customerSnapshot['customerName'];
      final customerPhoneNumber = customerSnapshot['customerPhoneNumber'];

      await FirebaseFirestore.instance.collection('DriversAcceptedOrders').add({
        'fromLocation': suggestionData['fromLocation'],
        'toLocation': suggestionData['toLocation'],
        'selectedDate': suggestionData['selectedDate'],
        'selectedTime': suggestionData['selectedTime'],
        'selectedGoodsType': suggestionData['selectedGoodsType'],
        'selectedTruck': suggestionData['selectedTruck'],
        'driverName': widget.driverName,
        'driverPhoneNumber': widget.driverPhoneNumber,
        'customerName': customerName,
        'customerPhoneNumber': customerPhoneNumber,
        'status': 'Accepted',
      });

      // Remove the document from Transmaa_accepted_orders
      await FirebaseFirestore.instance
          .collection('Transmaa_accepted_orders')
          .doc(suggestionId)
          .delete();

      Navigator.push(
        widget.parentContext,
        MaterialPageRoute(
          builder: (context) => HistoryScreen({
            'fromLocation': suggestionData['fromLocation'],
            'toLocation': suggestionData['toLocation'],
            'selectedDate': suggestionData['selectedDate'],
            'selectedTime': suggestionData['selectedTime'],
            'selectedGoodsType': suggestionData['selectedGoodsType'],
            'selectedTruck': suggestionData['selectedTruck'],
          }),
        ),
      );
    } catch (e) {
      print('Error accepting suggestion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Transmaa_accepted_orders')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final suggestions = snapshot.data!.docs.map((doc) {
          final suggestionId = doc.id;
          final fromLocation = doc['fromLocation'];
          final toLocation = doc['toLocation'];
          final selectedDateTimestamp = doc['selectedDate'] as Timestamp;
          final selectedDate = selectedDateTimestamp.toDate();
          final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          final selectedTime = doc['selectedTime'];
          final selectedGoodsType = doc['selectedGoodsType'];
          final selectedTruck = {
            'name': doc['selectedTruck']['name'],
            'weightCapacity': doc['selectedTruck']['weightCapacity'].toString(),
          };

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('$fromLocation'),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('$toLocation'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Goods Type:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text('$selectedGoodsType'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text('$formattedDate'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Truck:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                              '${selectedTruck['name']} (Capacity: ${selectedTruck['weightCapacity']}kg)'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text('$selectedTime'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(120, 30),
                        primary: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isAccepted = true;
                        });
                        _acceptButtonPressed(suggestionId, {
                          'fromLocation': fromLocation,
                          'toLocation': toLocation,
                          'selectedDate': selectedDate,
                          'selectedTime': selectedTime,
                          'selectedGoodsType': selectedGoodsType,
                          'selectedTruck': selectedTruck,
                        });
                      },
                      child: Text(
                        isAccepted ? 'Accepted' : 'Accept',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList();

        return SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Suggested Loads : ",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              Divider(
                thickness: 2,
                color: Colors.brown,
              ),
              Column(
                children: suggestions,
              ),
            ],
          ),
        );
      },
    );
  }
}

List<Map<String, String>> locationPairs = [
  {'from': 'Location A', 'to': 'Location B'},
  {'from': 'Location C', 'to': 'Location D'},
];

List<String> locationDetails = [
  'Location A',
  'Location B',
  'Location C',
  'Location D'
];
String selectedDate = '2022-02-16';
String selectedTime = '14:30';
String selectedGoodsType = 'Furniture';
String selectedTruck = 'Truck A';

class MyWidget extends StatelessWidget {
  final String currentUser;
  final User? driver;

  MyWidget({
    required this.currentUser,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SuggestionsContainer(
        locationPairs: locationPairs,
        fromLocations: locationDetails,
        toLocations: locationDetails,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        selectedGoodsType: selectedGoodsType,
        selectedTruck: selectedTruck,
        driverName: currentUser,
        driverPhoneNumber: driver?.phoneNumber ?? '',
        onClose: () {},
        parentContext: context,
      ),
    );
  }
}