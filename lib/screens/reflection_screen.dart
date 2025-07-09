import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';

class ReflectionScreen extends StatefulWidget {
  final String sessionId;
  const ReflectionScreen({super.key, required this.sessionId});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final AppwriteService _appwriteService = AppwriteService();
  String? reflection;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReflection();
  }

  Future<void> _fetchReflection() async {
    try {
                           // For now, use mock data
                     final data = {
                       'content': 'This is a sample reflection from the session.',
                     };
      setState(() {
        reflection = data['content'] ?? 'No reflection found for this session.';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        reflection = 'Error fetching reflection: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pushNamed(context, '/scores');
            },
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.psychology,
                      size: 64,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Session Reflection',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        reflection ?? 'No reflection found.',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/scores');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text('View Scores'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
