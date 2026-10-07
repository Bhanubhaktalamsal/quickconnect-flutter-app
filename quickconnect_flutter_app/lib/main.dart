import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const QuickConnectApp());
}

class QuickConnectApp extends StatelessWidget {
  const QuickConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickConnect',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0877BD)),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const QuickMenuPage(),
    );
  }
}

class QuickMenuPage extends StatelessWidget {
  const QuickMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(35, 18, 35, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Menu',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202020),
                ),
              ),
              const SizedBox(height: 55),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuickMenuItem(
                    icon: Icons.show_chart_rounded,
                    label: 'Diagnose\nInternet',
                    onTap: () => _message(context, 'Diagnose Internet selected'),
                  ),
                  QuickMenuItem(
                    icon: Icons.cable_rounded,
                    label: 'Request\nConnection',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NewConnectionPage(),
                        ),
                      );
                    },
                  ),
                  QuickMenuItem(
                    icon: Icons.wifi_rounded,
                    label: 'Wifi\nAnalyzer',
                    onTap: () => _message(context, 'WiFi Analyzer selected'),
                  ),
                  QuickMenuItem(
                    icon: Icons.web_rounded,
                    label: 'Visit\nWebsite',
                    onTap: () => _message(context, 'Website selected'),
                  ),
                ],
              ),
              const SizedBox(height: 62),
              const PromoCard(),
            ],
          ),
        ),
      ),
    );
  }

  static void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class QuickMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 75,
        child: Column(
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE1E1E1)),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 43,
                color: const Color(0xFF0877BD),
              ),
            ),
            const SizedBox(height: 34),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                height: 1.28,
                color: Color(0xFF3C4247),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  const PromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9EEF8), width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QuickConnect',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0877BD),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Power Your Business with',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0877BD),
            ),
          ),
          SizedBox(height: 10),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF0877BD),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Text(
                'QuickConnect Bulk SMS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewConnectionPage extends StatefulWidget {
  const NewConnectionPage({super.key});

  @override
  State<NewConnectionPage> createState() => _NewConnectionPageState();
}

class _NewConnectionPageState extends State<NewConnectionPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  final mapController = MapController();

  LatLng selectedPoint = const LatLng(28.60, 81.63);
  String selectedRequest = 'Installation Request';
  bool loadingLocation = false;

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> useCurrentLocation() async {
    setState(() => loadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _show('Please enable Location/GPS on your phone.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _show('Location permission was not granted.');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final point = LatLng(position.latitude, position.longitude);

      setState(() => selectedPoint = point);
      mapController.move(point, 17);
    } catch (e) {
      _show('Unable to get current location.');
    } finally {
      if (mounted) setState(() => loadingLocation = false);
    }
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void sendRequest() {
    if (nameController.text.trim().isEmpty ||
        mobileController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      _show('Please fill all required fields.');
      return;
    }

    final lat = selectedPoint.latitude.toStringAsFixed(6);
    final lng = selectedPoint.longitude.toStringAsFixed(6);

    // Replace this section with your API/Firebase call.
    debugPrint('NEW CONNECTION REQUEST');
    debugPrint('Name: ${nameController.text}');
    debugPrint('Mobile: ${mobileController.text}');
    debugPrint('Email: ${emailController.text}');
    debugPrint('Address: ${addressController.text}');
    debugPrint('Request: $selectedRequest');
    debugPrint('Latitude: $lat');
    debugPrint('Longitude: $lng');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Request Submitted'),
        content: Text(
          'Your $selectedRequest has been recorded.\n\n'
          'Location: $lat, $lng',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: selectedPoint,
                          initialZoom: 16,
                          onTap: (_, point) {
                            setState(() => selectedPoint = point);
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.quickconnect.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: selectedPoint,
                                width: 46,
                                height: 46,
                                child: const Icon(
                                  Icons.location_on,
                                  size: 45,
                                  color: Color(0xFF0877BD),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 18,
                        left: 35,
                        right: 35,
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(8),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search your location',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 28,
                        child: FloatingActionButton(
                          onPressed: loadingLocation ? null : useCurrentLocation,
                          backgroundColor: const Color(0xFF0877BD),
                          child: loadingLocation
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildFormSheet(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 76,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'New Connection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildFormSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.58,
      minChildSize: 0.32,
      maxChildSize: 0.82,
      expand: false,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                color: Color(0x33000000),
              ),
            ],
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(34, 12, 34, 20),
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB9B9B9),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Select address from the map',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _label('Your name'),
              _field(nameController, 'Your name', TextInputType.name),
              _label('Mobile no.'),
              _field(mobileController, 'Your mobile number',
                  TextInputType.phone),
              _label('Email'),
              _field(emailController, 'Your email', TextInputType.emailAddress),
              _label('Address'),
              _field(addressController, 'Address', TextInputType.streetAddress),
              const SizedBox(height: 14),
              const Text(
                'Request For:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text('Installation Request'),
                value: 'Installation Request',
                groupValue: selectedRequest,
                onChanged: (value) =>
                    setState(() => selectedRequest = value!),
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text('Service Expansion Request'),
                value: 'Service Expansion Request',
                groupValue: selectedRequest,
                onChanged: (value) =>
                    setState(() => selectedRequest = value!),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: sendRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0877BD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Send Request',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint,
    TextInputType type,
  ) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
