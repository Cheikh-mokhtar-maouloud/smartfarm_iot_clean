import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _temperatureUnit = '°C';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _temperatureUnit = prefs.getString('temperature_unit') ?? '°C';
    });
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('dark_mode_enabled', _darkModeEnabled);
    await prefs.setString('temperature_unit', _temperatureUnit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive alerts and updates'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
                _saveSettings();
              });
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
                _saveSettings();
              });
            },
          ),
          ListTile(
            title: const Text('Temperature Unit'),
            subtitle: Text('Current: $_temperatureUnit'),
            trailing: DropdownButton<String>(
              value: _temperatureUnit,
              items: const [
                DropdownMenuItem(value: '°C', child: Text('Celsius')),
                DropdownMenuItem(value: '°F', child: Text('Fahrenheit')),
              ],
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _temperatureUnit = value;
                    _saveSettings();
                  });
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Smart Farm IoT v1.0.0'),
            leading: const Icon(Icons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Smart Farm IoT',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(),
                children: const [
                  Text('A smart farming solution for modern agriculture'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
