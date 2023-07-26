import 'package:ecommerce/model/privacy.dart';
import 'package:ecommerce/screens/homepage.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:ecommerce/theme/textstyle.dart';
import 'package:ecommerce/widgets/failedalert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkboxValue = false;
  bool checkboxError = false;
  Map<String, dynamic>? staffData;
  int? empID;
  String? empName;
  String? mobile;
  String? email;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final url = Uri.parse('https://fakestoreapi.com/auth/login');
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (mounted) {
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
        print(response.body);
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
            (route) => false,
          );
        }
      } else {
        // Handle the error case
        showErrorDialog('Error', 'Invalid Username Or Password');
      }
    } else {
      // Handle the error case
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const FailedAlertDialog();
        },
      );
    }
  }

  // Method to show error dialog
  Future<void> showErrorDialog(String title, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Check internet connection
  Future<bool> _checkInternetConnection() async {
    final isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected;
  }

  @override
  Widget build(BuildContext context) {
    const commonPadding = EdgeInsets.all(10);

    return Scaffold(
      backgroundColor: MyColorTheme.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Lottie.asset(
                  "assets/lottie/login1.json",
                ),
                Padding(
                  padding: commonPadding,
                  child: TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: MyColorTheme.primaryColor,
                      ),
                      labelText: "Username",
                      labelStyle: editTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: MyColorTheme.primaryColor),
                      hintText: "Enter Username",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColorTheme
                              .primaryColor, // Set the enabled border color here
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColorTheme
                              .primaryColor, // Set the focused border color here
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: commonPadding,
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.password,
                        color: MyColorTheme.primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: MyColorTheme.primaryColor,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      labelText: "Password",
                      labelStyle: editTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: MyColorTheme.primaryColor),
                      hintText: "Enter password",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColorTheme
                              .primaryColor, // Set the enabled border color here
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyColorTheme
                              .primaryColor, // Set the focused border color here
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: checkboxValue,
                      onChanged: (value) {
                        setState(() {
                          checkboxValue = value ?? false;
                          checkboxError =
                              false; // Reset the checkbox error status
                        });
                      },
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Privacy Policy'),
                              content: SingleChildScrollView(
                                child: Text(privacyPolicyText),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          'I have read and agree to the privacy policy, terms of service, and community guidelines.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                if (checkboxError)
                  Text(
                    'Please agree to the Privacy policy',
                    style: TextStyle(
                      color: MyColorTheme.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                Container(
                  height: 60,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColorTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final isConnected = await _checkInternetConnection();
                        if (isConnected) {
                          if (checkboxValue) {
                            // Checkbox is checked, proceed with login
                            _login();
                          } else {
                            // Checkbox is not checked, show an error message
                            setState(() {
                              checkboxError =
                                  true; // Set the checkbox error status
                            });
                          }
                        } else {
                          // No internet connection, show an error message
                          showErrorDialog('Error', 'No internet connection.');
                        }
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
