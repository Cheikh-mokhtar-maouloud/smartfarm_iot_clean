import 'package:flutter/material.dart';

class WaterControl extends StatefulWidget {
  const WaterControl({super.key});

  @override
  State<WaterControl> createState() => _WaterControlState();
}

class _WaterControlState extends State<WaterControl>
    with SingleTickerProviderStateMixin {
  bool isWaterOn = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleWater() {
    setState(() {
      isWaterOn = !isWaterOn;
      if (isWaterOn) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Water Control',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: GestureDetector(
                    onTap: _toggleWater,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isWaterOn ? Colors.blue : Colors.grey[300],
                        boxShadow: [
                          BoxShadow(
                            color: isWaterOn
                                ? Colors.blue.withOpacity(0.5)
                                : Colors.black.withOpacity(0.2),
                            spreadRadius: isWaterOn ? 5 : 2,
                            blurRadius: isWaterOn ? 15 : 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isWaterOn
                              ? Icons.water_drop
                              : Icons.water_drop_outlined,
                          size: 80,
                          color: isWaterOn ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          Text(
            isWaterOn ? 'Water is ON' : 'Water is OFF',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: isWaterOn ? Colors.blue : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
