import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_demand_home_services/numericpad.dart';
import 'package:on_demand_home_services/screens/home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _codeController = TextEditingController();
  String phoneNumber = "";
  String data = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithMobileNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${data.trim()}',
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          await _auth.signInWithCredential(authCredential).then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>HomeScreen()),
            );
          });
        },
        verificationFailed: (error) {
          if (kDebugMode) print(error);
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Enter Passcode"),
              content: TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '6-digit Passcode',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: _codeController.text.trim(),
                    );
                    _auth.signInWithCredential(credential).then((result) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }).catchError((e) {
                      if (kDebugMode) print(e);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Verify"),
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Verify Your Phone",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(  // Wrap Column with SingleChildScrollView
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,  // Add dynamic height
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  height: 120,
                  child: Image.asset('assets/images/phone.png'),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "6-digit Passcode to verify your phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              buildPhoneInputSection(context),
              const SizedBox(height: 20),
              NumericPad(
                onNumberSelected: (value) {
                  setState(() {
                    if (value == -1 && phoneNumber.isNotEmpty) {
                      phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
                    } else if (value != -1 && value != -2) {
                      phoneNumber += value.toString();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPhoneInputSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Phone Number",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text(
                  "+91 ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (phoneNumber.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        phoneNumber = "";
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                      size: 26,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: phoneNumber.length >= 10
                  ? () {
                data = phoneNumber;
                _signInWithMobileNumber();
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[400],
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
