// lib/controllers/pollution_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartfarm_iot1/models/sensor_data.dart';

class PollutionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Stream<List<SensorData>> getPollutionDataStream() {
    return _firestore
        .collection('pollution_data')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SensorData.fromJson(doc.data()))
          .toList();
    });
  }
  
  Future<void> addPollutionData(double pollutionLevel) async {
    try {
      final data = SensorData(
        timestamp: DateTime.now(),
        temperature: 0,
        humidity: 0,
        soilMoisture: 0,
        lightLevel: 0,
        pollutionLevel: pollutionLevel,
      );
      
      await _firestore.collection('pollution_data').add(data.toJson());
    } catch (e) {
      throw Exception('Failed to add pollution data: ${e.toString()}');
    }
  }
  
  // Obtenir le statut actuel de la pollution
  Future<Map<String, dynamic>> getCurrentPollutionStatus() async {
    try {
      final snapshot = await _firestore
          .collection('pollution_data')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
          
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
      return {'pollutionLevel': 0.0};
    } catch (e) {
      throw Exception('Failed to get pollution status: ${e.toString()}');
    }
  }
}