import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../models/service.dart';
import '../models/booking.dart';
import '../providers/bookings_provider.dart';

class BookingScreen extends StatefulWidget {
  final Service service;

  BookingScreen({required this.service});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _workController = TextEditingController();
  bool _isLoading = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _workController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (!mounted) return;

    setState(() {
      _currentPosition = position;
      _locationController.text =
      '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      _timeController.text = pickedTime.format(context);
    }
  }

  bool _validateDate(String date) {
    try {
      DateFormat('dd-MM-yyyy').parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _validateTime(String time) {
    try {
      DateFormat.jm().parseStrict(time);
      return true;
    } catch (e) {
      try {
        DateFormat.Hm().parseStrict(time);
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  void _confirmBooking() {
    final location = _locationController.text.trim();
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();
    final work = _workController.text.trim();

    if (location.isEmpty || date.isEmpty || time.isEmpty || work.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    if (!_validateDate(date)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid date in DD-MM-YYYY format.')),
      );
      return;
    }

    bool _validateTime(String time) {
      try {
        DateFormat.jm().parseStrict(time); // 'h:mm a' format
        return true;
      } catch (e) {
        try {
          DateFormat.Hm().parseStrict(time); // 'HH:mm' format
          return true;
        } catch (e) {
          return false;
        }
      }
    }

    setState(() {
      _isLoading = true;
    });

    final newBooking = Booking(
      id: DateTime.now().toIso8601String(),
      serviceName: widget.service.name,
      date: date,
      time: time,
      status: 'Pending',
      notes: work,
      location: location,
      userId: 'guest_user',
    );

    Provider.of<BookingsProvider>(context, listen: false).addBooking(newBooking);

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Confirmed for ${widget.service.name}')),
      );

      Navigator.pop(context);
    });
  }

  void _cancelBooking() {
    Navigator.pop(context);
  }

  IconData getServiceIcon() {
    switch (widget.service.name.toLowerCase()) {
      case 'plumbing':
        return FontAwesomeIcons.faucet;
      case 'cleaning':
        return FontAwesomeIcons.broom;
      case 'electrical':
        return FontAwesomeIcons.bolt;
      case 'painting':
        return FontAwesomeIcons.paintRoller;
      case 'carpentry':
        return FontAwesomeIcons.hammer;
      case 'gardening':
        return FontAwesomeIcons.seedling;
      case 'hvac repair':
        return FontAwesomeIcons.snowflake;
      case 'pest control':
        return FontAwesomeIcons.bug;
      case 'moving services':
        return FontAwesomeIcons.truckMoving;
      case 'appliance repair':
        return FontAwesomeIcons.screwdriverWrench;
      default:
        return FontAwesomeIcons.toolbox;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${service.name}'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    getServiceIcon(),
                    size: 100,
                    color: Colors.blueAccent,
                    key: ValueKey(service.name),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Service: ${service.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${service.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Price: ₹${service.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            _buildTextField(
              controller: _workController,
              hint: 'Describe your work...',
              label: 'Select Work',
              maxLines: 4,
              icon: Icons.work,
            ),
            _buildTextField(
              controller: _locationController,
              hint: 'Enter your location',
              label: 'Location',
              icon: Icons.location_on,
            ),
            _buildDateAndTimeField('Select Date', _selectDate, _dateController),
            _buildDateAndTimeField('Select Time', _selectTime, _timeController),
            SizedBox(height: 30),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildElevatedButton('Cancel', _cancelBooking, Colors.lightBlueAccent),
                _buildElevatedButton('Confirm Booking', _confirmBooking, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String label,
    IconData? icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTimeField(
      String label, Future<void> Function(BuildContext) onTap, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => onTap(context),
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Select a $label',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }
}
