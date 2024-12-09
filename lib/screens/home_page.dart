import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiService = ApiService();
  String username = '';
  String email = '';
  bool isLoading = true;

  Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('token') ?? '';
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    String token = await getToken();
    print('Token in Homepage: $token');
    _fetchUserProfile(token);
  }

  void logout() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
    Navigator.pushNamed(context, '/');
  }

  void _fetchUserProfile(String token) async {
    try {
      final response = await apiService.getUserProfile(token);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          username = data['user']['username'] ?? 'N/A';
          email = data['user']['email'] ?? 'N/A';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error fetching profile: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, $username',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Email: $email', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: logout, child: Text('Logout'))
                ],
              ),
      ),
    );
  }
}
