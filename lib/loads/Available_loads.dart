import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:transmaacode/loads/suggetion_loads.dart';
import '../history_details/history_screen.dart';
import 'package:http/http.dart' as http;

class PlaceSuggestion {
  final String displayName;

  PlaceSuggestion({
    required this.displayName,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      displayName: json['display_name'],
    );
  }
}

class LoadsScreen extends StatefulWidget {
  const LoadsScreen({Key? key});

  @override
  _LoadsScreenState createState() => _LoadsScreenState();
}

class _LoadsScreenState extends State<LoadsScreen> {
  TextEditingController fromLocationController = TextEditingController();
  TextEditingController toLocationController = TextEditingController();

  User? driver;

  Map<String, dynamic>? documentData;
  String? fromLocation;
  String? toLocation;
  List<String> locationDetails = [];
  bool isLoading = false;
  bool isSearchEnabled = false;
  bool isAccepted = false;
  bool showSuggestions = false;
  List<Map<String, String>> locationPairs = [];

  String selectedDate = '';
  String selectedTime = '';
  String selectedGoodsType = '';
  String selectedTruck = '';
  String currentUser = ''; // State variable to hold current user's name
  List<PlaceSuggestion> fromLocationSuggestions = [];
  List<PlaceSuggestion> toLocationSuggestions = [];

  @override
  void initState() {
    super.initState();
    fetchDriverData(); // Fetch current user's name when the widget initializes
  }

  Future<void> fetchDriverData() async {
    // Get the current user
    User? driver = FirebaseAuth.instance.currentUser;

    if (driver != null) {
      setState(() {
        this.driver = driver;
      });

      // Get user document from Firestore based on phone number
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Driver')
          .where('phone_number', isEqualTo: driver.phoneNumber)
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming phone number is unique, there should only be one document
        DocumentSnapshot driverDoc = querySnapshot.docs.first;

        // Extract user data from the document
        Map<String, dynamic>? driverData =
        driverDoc.data() as Map<String, dynamic>?;

        if (driverData != null) {
          if (driverData.containsKey('name')) {
            setState(() {
              currentUser = driverData['name'];
            });
          }
        } else {
          // Handle the case where driverData is null
          print('Driver data is null.');
        }
      } else {
        // Handle the case where no documents match the query
        print('No driver document found for the current user.');
      }
    }
  }

  Future<List<PlaceSuggestion>> fetchFromSuggestions(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/search?q=$query&format=json&viewbox=68.1,6.5,97.4,35.5&bounded=1&countrycodes=in'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<PlaceSuggestion> suggestions =
        data.map((json) => PlaceSuggestion.fromJson(json)).toList();
        return suggestions;
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Text(
                    "Hi $currentUser..",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 4,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          child: Icon(
                            Icons.circle_outlined,
                            color: Colors.transparent,
                            size: 1,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'From',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextField(
                                controller: fromLocationController,
                                onChanged: (value) {
                                  fetchFromSuggestions(value)
                                      .then((suggestions) {
                                    setState(() {
                                      fromLocationSuggestions = suggestions;
                                    });
                                  }).catchError((error) {
                                    print('Error fetching suggestions: $error');
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Load it....',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                              if (fromLocationSuggestions.isNotEmpty)
                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: fromLocationSuggestions
                                        .map((suggestion) {
                                      return ListTile(
                                        title: Text(suggestion.displayName),
                                        onTap: () {
                                          setState(() {
                                            fromLocationController.text =
                                                suggestion.displayName;
                                            fromLocationSuggestions.clear();
                                            updateSearchButtonState();
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'To',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        swapTextFields();
                                      });
                                    },
                                    child: Icon(Icons.swap_vert),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextField(
                                controller: toLocationController,
                                onChanged: (value) {
                                  fetchFromSuggestions(value)
                                      .then((suggestions) {
                                    setState(() {
                                      toLocationSuggestions = suggestions;
                                    });
                                  }).catchError((error) {
                                    print('Error fetching suggestions: $error');
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Unload to....',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                              // Suggestions Container for 'To' location
                              if (toLocationSuggestions.isNotEmpty)
                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    children:
                                    toLocationSuggestions.map((suggestion) {
                                      return ListTile(
                                        title: Text(suggestion.displayName),
                                        onTap: () {
                                          setState(() {
                                            toLocationController.text =
                                                suggestion.displayName;
                                            toLocationSuggestions.clear();
                                            updateSearchButtonState();
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:
                          isSearchEnabled ? _searchButtonPressed : null,
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(200, 40),
                            primary: Colors.grey[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Search',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
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
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                child: isLoading
                    ? CircularProgressIndicator()
                    : documentData != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Available Loads : ",
                      style: TextStyle(
                          fontSize: 20, color: Colors.black),
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.brown,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
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
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'From Location:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text('$fromLocation'),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'To Location:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text('$toLocation'),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Goods Type:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${documentData!['selectedGoodsType']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${formatDate(documentData!['selectedDate'])}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Truck:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${documentData!['selectedTruck']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${documentData!['selectedTime']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
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
                          SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 30),
                              primary: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isAccepted = true;
                              });
                              _acceptButtonPressed();
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
                    )
                  ],
                )
                    : showSuggestions
                    ? SuggestionsContainer(
                  fromLocations: locationDetails,
                  toLocations: locationDetails,
                  locationPairs: locationPairs,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  selectedGoodsType: selectedGoodsType,
                  selectedTruck: selectedTruck,
                  driverName: currentUser,
                  driverPhoneNumber: driver?.phoneNumber ?? '',
                  onClose: () {},
                  parentContext: context,
                )
                    : Text('No document data available'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateSearchButtonState() {
    setState(() {
      isSearchEnabled = fromLocationController.text.isNotEmpty &&
          toLocationController.text.isNotEmpty;
    });
  }

  void _searchButtonPressed() async {
    setState(() {
      isLoading = true;
      locationDetails.clear();
      locationPairs.clear(); // Clear the previous suggestions
    });

    try {
      await Firebase.initializeApp();

      // Update fromLocation and toLocation with the text from the controllers
      fromLocation = fromLocationController.text;
      toLocation = toLocationController.text;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('/Transmaa_accepted_orders')
          .where('fromLocation', isEqualTo: fromLocation)
          .where('toLocation', isEqualTo: toLocation)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          documentData =
          querySnapshot.docs.first.data() as Map<String, dynamic>?;
          isLoading = false;
        });
      } else {
        // No available loads found, show suggestions
        setState(() {
          isLoading = false;
          documentData = null;
          showSuggestions = true;
        });

        // Fetch and populate suggestion data
        fetchFromSuggestions;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        documentData = null;
      });
      print('Error fetching data: $e');
    }
  }

  void swapTextFields() {
    String temp = fromLocationController.text;
    fromLocationController.text = toLocationController.text;
    toLocationController.text = temp;
    setState(() {
      fromLocation = fromLocationController.text;
      toLocation = toLocationController.text;
      updateSearchButtonState();
    });
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  void _acceptButtonPressed() async {
    try {
      await Firebase.initializeApp();
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      User? driver = FirebaseAuth.instance.currentUser;
      // Add the accepted load to the 'DriversAcceptedOrders' collection
      DocumentReference acceptedOrderRef =
      await firestore.collection('DriversAcceptedOrders').add({
        'driverName': currentUser, // Include the driver's name
        'driverPhoneNumber': driver?.phoneNumber,
        'fromLocation': documentData!['fromLocation'],
        'toLocation': documentData!['toLocation'],
        'selectedDate': documentData!['selectedDate'],
        'selectedTime': documentData!['selectedTime'],
        'selectedGoodsType': documentData!['selectedGoodsType'],
        'selectedTruck': documentData!['selectedTruck'],
        'customerName': documentData!['customerName'],
        'customerphoneNumber': documentData!['customerphoneNumber'],
        'status': 'Pending',
      });

      // Get the document ID of the newly added document in 'DriversAcceptedOrders' collection
      String? documentId = acceptedOrderRef.id;
      print("Document ID: $documentId");

      if (documentId != null) {
        // Query the 'Transmaa_accepted_orders' collection to find the document matching the current data
        QuerySnapshot querySnapshot = await firestore
            .collection('Transmaa_accepted_orders')
            .where('fromLocation', isEqualTo: documentData!['fromLocation'])
            .where('toLocation', isEqualTo: documentData!['toLocation'])
            .where('selectedDate', isEqualTo: documentData!['selectedDate'])
            .where('selectedTime', isEqualTo: documentData!['selectedTime'])
            .where('selectedGoodsType',
            isEqualTo: documentData!['selectedGoodsType'])
            .where('selectedTruck', isEqualTo: documentData!['selectedTruck'])
            .where('customerName', isEqualTo: documentData!['customerName'])
            .where('customerphoneNumber',
            isEqualTo: documentData!['customerphoneNumber'])
            .get();

        // Check if any matching documents found
        if (querySnapshot.docs.isNotEmpty) {
          // Assuming there's only one matching document, get its reference and delete it
          await querySnapshot.docs.first.reference.delete();
          print("Document deleted from Transmaa_accepted_orders.");
        } else {
          print("No matching document found in Transmaa_accepted_orders.");
        }
      } else {
        print("Document ID is null.");
      }

      setState(() {
        isAccepted = true; // Update the UI to show 'Accepted'
      });

      // Navigate to the history screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryScreen(documentData),
        ),
      );
    } catch (e, stackTrace) {
      print('Error accepting load: $e');
      print('StackTrace: $stackTrace');
    }
  }
}
