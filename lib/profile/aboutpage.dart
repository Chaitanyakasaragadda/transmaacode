import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCard(
                title: 'Transmaa provides a wide range of services :',
                content:
                'Transmaa provides a wide range of services, such as load management, upfront pricing, on-time delivery, insurance and guarantee, and support for global logistics to provide smooth transportation solutions everywhere.',
              ),
              _buildCard(
                title: 'Load :',
                content:
                'Transmaa effective load management, which offers a range of services from logistics planning to real-time tracking, guarantees safe and timely delivery.',
              ),
              _buildCard(
                title: 'Vehicle Buy & Sell :',
                content:
                'Transmaa simplifies ethical transactions by promoting transparent connections in a productive marketplace for buying and selling.',
              ),
              _buildCard(
                title: 'Insurance :',
                content:
                'With our all-inclusive insurance, which covers every stage of transportation and successfully reduces risks for asset protection, you can feel safe.',
              ),
              _buildCard(
                title: 'Finance :',
                content:
                'Transmaa drives transportation industry growth by providing specialized financial services ranging from working capital to fleet expansion support.',
              ),
              _buildCard(
                title: 'Fuel :',
                content:
                'Transmaa new fuel Services provide ease and accessibility by cooperating with all fuel pumps across India for smooth fueling experiences.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title, required String content}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
