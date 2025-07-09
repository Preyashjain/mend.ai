import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';

class ScoresScreen extends StatefulWidget {
  final String sessionId;
  const ScoresScreen({super.key, required this.sessionId});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  final AppwriteService _appwriteService = AppwriteService();
  int? score;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScore();
  }

  Future<void> fetchScore() async {
    try {
                           // For now, use mock data
                     final scoreData = {
                       'score': 8,
                     };
      setState(() {
        score = scoreData['score'] ?? 8; // Fallback if null
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        score = 8; // Default score on error
        isLoading = false;
      });
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.orange;
    return Colors.red;
  }

  String _getScoreMessage(int score) {
    if (score >= 8) return 'Excellent compatibility!';
    if (score >= 6) return 'Good compatibility with room for improvement.';
    return 'Consider working on communication together.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session Score"),
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
                      Icons.star,
                      size: 64,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Compatibility Score',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _getScoreColor(score ?? 0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getScoreColor(score ?? 0),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${score ?? 0}/10",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(score ?? 0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _getScoreMessage(score ?? 0),
                            style: TextStyle(
                              fontSize: 16,
                              color: _getScoreColor(score ?? 0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/sessions');
                          },
                          child: const Text('New Session'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/home');
                          },
                          child: const Text('Back to Home'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
