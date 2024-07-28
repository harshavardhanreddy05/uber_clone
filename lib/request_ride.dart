import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

class RideRequestPage extends StatefulWidget {
  RideRequestPage();

  @override
  _RideRequestPageState createState() => _RideRequestPageState();
}

class _RideRequestPageState extends State<RideRequestPage> {
  late Future<Map<String, dynamic>> _rideRequestFuture;

  @override
  void initState() {
    super.initState();
    _rideRequestFuture = _loadRideRequestData();
  }

  Future<Map<String, dynamic>> _loadRideRequestData() async {
    final jsonString = await rootBundle.loadString('lib/data/sample_data.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 138, 178, 1),
        foregroundColor: Colors.white,
        title: Text(
          'Ride Request Details',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _rideRequestFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No ride request data available'));
          }

          final rideRequestResponse = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text('Status: ${rideRequestResponse['status']}'),
                Text('Ride ID: ${rideRequestResponse['ride_id']}'),
                Text(
                    'Driver: ${rideRequestResponse['driver']?['name'] ?? 'N/A'}'),
                Text(
                    'Car Model: ${rideRequestResponse['driver']?['car_model'] ?? 'N/A'}'),
                Text(
                    'Rating: ${rideRequestResponse['driver']?['rating'] ?? 'N/A'}'),
                Text(
                    'Estimated Arrival Time: ${rideRequestResponse['estimated_arrival_time'] ?? 'N/A'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
