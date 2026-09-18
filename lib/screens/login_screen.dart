import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../home.dart';
import '../providers/user_provider.dart';
import '../providers/account_settings_provider.dart';
import '../screens/home_screen.dart';
import '../forgot_password.dart';
import '../signup.dart';

final storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  // Save user credentials securely
  Future<void> _userLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);

      userProvider.setUser(_emailController.text.trim(), _passwordController.text.trim());
      accountSettingsProvider.updateEmail(_emailController.text.trim());
      accountSettingsProvider.updatePassword(_passwordController.text.trim());

      if (_rememberMe) {
        // Save email and password securely
        await storage.write(key: 'email', value: _emailController.text.trim());
        await storage.write(key: 'password', value: _passwordController.text.trim());
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.code == 'user-not-found'
            ? 'No user found for that email.'
            : e.code == 'wrong-password'
            ? 'Wrong password provided.'
            : 'An error occurred. Please try again.';
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
    }
  }

  // Google Sign-In method
  Future<void> _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);

        userProvider.setUser(user.email!, '');  // You can store user data here
        accountSettingsProvider.updateEmail(user.email!);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Google sign-in error: $e");
      }
    }
  }

  // Load saved credentials
  Future<void> _loadSavedCredentials() async {
    final email = await storage.read(key: 'email');
    final password = await storage.read(key: 'password');

    if (email != null) _emailController.text = email;
    if (password != null) _passwordController.text = password;

    if (email != null && password != null) {
      setState(() {
        _rememberMe = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved credentials on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/home');
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.home,
                        size: 80,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  const Text(
                    'Welcome to Home Service!',
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Login to continue',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: _inputDecoration('Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 0),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text('Remember Me', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton(
                    onPressed: _userLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      minimumSize: const Size(180, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    ),
                    child: const Text("Login", style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPassword()));
                    },
                    child: const Text('Forgot Password?', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  const Text("OR", style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text("Sign Up with", style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(60, 45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                        icon: Image.asset('assets/images/google_logo.png', height: 50, width: 50),
                        label: const SizedBox.shrink(),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(60, 45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                        icon: Image.asset('assets/images/microsoft_logo.png', height: 50, width: 50),
                        label: const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUp()));
                    },
                    child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}
