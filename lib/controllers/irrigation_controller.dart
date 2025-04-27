// lib/controllers/irrigation_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class IrrigationController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Méthode pour ouvrir/fermer la vanne d'eau
  Future<void> toggleWaterValve(bool isOpen) async {
    try {
      // Enregistrer l'état de la vanne
      await _firestore.collection('irrigation_control').doc('water_valve').set({
        'isOpen': isOpen,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // Ajout d'une entrée dans l'historique
      await _firestore.collection('irrigation_history').add({
        'isOpen': isOpen,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to toggle water valve: ${e.toString()}');
    }
  }
  
  // Obtenir l'état actuel de la vanne
  Stream<bool> getWaterValveStatus() {
    return _firestore
        .collection('irrigation_control')
        .doc('water_valve')
        .snapshots()
        .map((snapshot) => snapshot.data()?['isOpen'] ?? false);
  }
}
