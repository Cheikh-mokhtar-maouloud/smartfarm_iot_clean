import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartfarm_iot1/models/sensor_data.dart';

class SensorController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<SensorData>> getSensorDataStream() {
    return _firestore
        .collection('sensor_data')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SensorData.fromJson(doc.data()))
          .toList();
    });
  }

  Future<void> addSensorData(SensorData data) async {
    await _firestore.collection('sensor_data').add(data.toJson());
  }

  Future<List<SensorData>> getHistoricalData(
      DateTime start, DateTime end) async {
    final snapshot = await _firestore
        .collection('sensor_data')
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .where('timestamp', isLessThanOrEqualTo: end)
        .get();

    return snapshot.docs
        .map((doc) => SensorData.fromJson(doc.data()))
        .toList();
  }
}