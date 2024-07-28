import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_clone/request_ride.dart';

class AvailableRidesPage extends StatefulWidget {
  @override
  _AvailableRidesPageState createState() => _AvailableRidesPageState();
}

class _AvailableRidesPageState extends State<AvailableRidesPage> {
  late Future<List<Map<String, dynamic>>> _driversFuture;

  @override
  void initState() {
    super.initState();
    _driversFuture = _loadDriversData(); // Initialize here
  }

  Future<List<Map<String, dynamic>>> _loadDriversData() async {
    final jsonString = await rootBundle.loadString('lib/data/drivers.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return List<Map<String, dynamic>>.from(jsonResponse);
  }

  Future<Map<String, dynamic>> _loadSampleRideRequestResponse() async {
    final jsonString = await rootBundle.loadString('lib/data/sample_data.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse;
  }

  Future<void> _requestRide(Map<String, dynamic> driver) async {
    // Load sample ride request response from JSON file
    final rideRequestResponse = await _loadSampleRideRequestResponse();
    rideRequestResponse['driver'] =
        driver; // Update driver info in the response

    // Navigate to the RideRequestPage
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RideRequestPage(
            // rideRequestResponse: rideRequestResponse,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 138, 178, 1),
        foregroundColor: Colors.white,
        title: Text('Available Rides', style: GoogleFonts.poppins()),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _driversFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No available rides'));
          }

          final drivers = snapshot.data!;
          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return ListTile(
                leading: Icon(Icons.car_rental),
                title: Text(driver['name']),
                subtitle: Text('Rating: ${driver['rating']}'),
                trailing: Text('Car Model: ${driver['car_model']}'),
                onTap: () => _requestRide(driver),
              );
            },
          );
        },
      ),
    );
  }
}
