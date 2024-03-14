import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../appbar_icons/helpline_screen.dart';
import '../appbar_icons/notification_screen.dart';
import '../drivers_profile/profile_screen.dart';
import '../loads/Available_loads.dart';
import '../login_registration/driver_login.dart';
import '../profile/help.dart';
import 'buy_sell.dart';
import 'finance_insurance.dart';
import 'fuel.dart';

class MyHomePage extends StatefulWidget {
  final String enteredName;
  final String documentId; // Add this field

  MyHomePage(
      {Key? key,
      required this.enteredName,
      required this.documentId,
      required String phoneNumber,
      required void Function() onLogout})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      LoadsScreen(),
      BuyAndSell(),
      FinanceAndInsurance(
        documentId: widget.documentId,
      ),
      Fuel(),
      Profile()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Navigate back to the login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (_) => LoginScreen(
                onLogin: () {},
                phoneNumber: '',
              )),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [SizedBox(height: 35,),
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 5),
                  child: Container(
                    child: Image.asset(
                      'assets/Finallogo.png',
                      fit: BoxFit.cover,
                      height: 45,
                      width: 161,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Help Icon
                      IconButton(
                        icon: Tooltip(
                          message: 'Help',
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.help_outline_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _screens[_selectedIndex],)
        ],
      ),
      bottomNavigationBar: Container(
        height:70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/loads_icon.png")),
              label: 'Loads',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/buyandsell_icon.png')),
              label: 'Sell & Buy',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/financeandinsurance_icon.png')),
              label: 'Finance &\n Insurance',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/710296.png')),
              label: 'Fuel',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/user_icon.png')),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          selectedLabelStyle: TextStyle(color: Colors.white, fontSize: 9,),
          unselectedLabelStyle: TextStyle(color: Colors.grey, fontSize: 9),
          iconSize: 22,
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
