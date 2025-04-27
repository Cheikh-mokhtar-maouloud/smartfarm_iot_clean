// lib/views/irrigation/water_control_screen.dart
import 'package:flutter/material.dart';
import 'package:smartfarm_iot1/controllers/irrigation_controller.dart';

class WaterControlScreen extends StatefulWidget {
  const WaterControlScreen({super.key});

  @override
  State<WaterControlScreen> createState() => _WaterControlScreenState();
}

class _WaterControlScreenState extends State<WaterControlScreen>
    with SingleTickerProviderStateMixin {
  final IrrigationController _irrigationController = IrrigationController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _splashAnimation;
  
  bool _isWaterOn = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticIn),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _colorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.blue,
    ).animate(_animationController);
    
    _splashAnimation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleWaterValve() async {
    setState(() {
      _isWaterOn = !_isWaterOn;
    });
    
    if (_isWaterOn) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    
    try {
      await _irrigationController.toggleWaterValve(_isWaterOn);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isWaterOn 
            ? 'Irrigation system turned ON'
            : 'Irrigation system turned OFF'),
          backgroundColor: _isWaterOn ? Colors.blue : Colors.grey,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigation Control'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tap to control irrigation system',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            StreamBuilder<bool>(
              stream: _irrigationController.getWaterValveStatus(),
              builder: (context, snapshot) {
                if (snapshot.hasData && _isWaterOn != snapshot.data) {
                  // Synchronisons l'UI avec les données Firebase
                  _isWaterOn = snapshot.data ?? false;
                  if (_isWaterOn) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                }
                
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animation de splash d'eau
                        if (_isWaterOn)
                          Container(
                            width: 280 + _splashAnimation.value,
                            height: 280 + _splashAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.2),
                            ),
                          ),
                        
                        // Bouton principal
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: GestureDetector(
                              onTap: _toggleWaterValve,
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _colorAnimation.value,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isWaterOn ? Colors.blue : Colors.grey).withOpacity(0.5),
                                      spreadRadius: _isWaterOn ? 8 : 2,
                                      blurRadius: _isWaterOn ? 20 : 10,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isWaterOn 
                                            ? Icons.water_drop
                                            : Icons.water_drop_outlined,
                                        size: 90,
                                        color: _isWaterOn ? Colors.white : Colors.grey[700],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        _isWaterOn ? 'ON' : 'OFF',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: _isWaterOn ? Colors.white : Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 70),
            Text(
              _isWaterOn ? 'Water valve is OPEN' : 'Water valve is CLOSED',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: _isWaterOn ? Colors.blue : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Smart Irrigation System',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isWaterOn 
                        ? 'Water conservation system active. Providing optimal irrigation based on soil moisture levels.'
                        : 'Water conservation system on standby. Tap to activate irrigation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}