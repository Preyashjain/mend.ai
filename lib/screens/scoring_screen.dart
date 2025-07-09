import 'package:flutter/material.dart';
import '../models/score_model.dart';
import '../models/user_model.dart';

class ScoringScreen extends StatefulWidget {
  final String sessionId;
  final UserModel currentUser;
  final UserModel partner;

  const ScoringScreen({
    super.key,
    required this.sessionId,
    required this.currentUser,
    required this.partner,
  });

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  final Map<String, int> _userScores = {};
  final Map<String, int> _partnerScores = {};
  final List<String> _criteria = [
    'empathy',
    'listening',
    'reception',
    'clarity',
    'respect',
    'responsiveness',
    'openMindedness',
  ];

  @override
  void initState() {
    super.initState();
    _initializeScores();
  }

  void _initializeScores() {
    for (String criteria in _criteria) {
      _userScores[criteria] = 0;
      _partnerScores[criteria] = 0;
    }
  }

  int _calculateTotalScore(Map<String, int> scores) {
    return scores.values.reduce((a, b) => a + b);
  }

  List<String> _generateStrengths(Map<String, int> scores) {
    List<String> strengths = [];
    scores.forEach((criteria, score) {
      if (score >= 8) {
        strengths.add('Excellent $criteria');
      } else if (score >= 6) {
        strengths.add('Good $criteria');
      }
    });
    return strengths;
  }

  List<String> _generateSuggestions(Map<String, int> scores) {
    List<String> suggestions = [];
    scores.forEach((criteria, score) {
      if (score <= 4) {
        suggestions.add('Work on improving $criteria');
      } else if (score <= 6) {
        suggestions.add('Continue developing $criteria');
      }
    });
    return suggestions;
  }

  void _saveScores() {
    final userTotalScore = _calculateTotalScore(_userScores);
    final partnerTotalScore = _calculateTotalScore(_partnerScores);
    
    final userStrengths = _generateStrengths(_userScores);
    final userSuggestions = _generateSuggestions(_userScores);
    final partnerStrengths = _generateStrengths(_partnerScores);
    final partnerSuggestions = _generateSuggestions(_partnerScores);

    final scoreModel = ScoreModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sessionId: widget.sessionId,
      userId: widget.currentUser.id,
      partnerId: widget.partner.id,
      userScores: Map.from(_userScores),
      partnerScores: Map.from(_partnerScores),
      userTotalScore: userTotalScore,
      partnerTotalScore: partnerTotalScore,
      userStrengths: userStrengths,
      userSuggestions: userSuggestions,
      partnerStrengths: partnerStrengths,
      partnerSuggestions: partnerSuggestions,
      timestamp: DateTime.now(),
    );

    // TODO: Save to database
    print('Scores saved: $scoreModel');

    // Navigate to post-resolution screen
    Navigator.pushReplacementNamed(context, '/post-resolution', arguments: widget.sessionId);
  }

  Widget _buildScoreCard(String title, Map<String, int> scores, bool isUser) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ..._criteria.map((criteria) => _buildScoreSlider(criteria, scores, isUser)),
            const SizedBox(height: 16),
            Text(
              'Total Score: ${_calculateTotalScore(scores)}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSlider(String criteria, Map<String, int> scores, bool isUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          criteria.toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Slider(
          value: scores[criteria]?.toDouble() ?? 0,
          min: 0,
          max: 10,
          divisions: 10,
          label: scores[criteria].toString(),
          onChanged: (value) {
            setState(() {
              if (isUser) {
                _userScores[criteria] = value.round();
              } else {
                _partnerScores[criteria] = value.round();
              }
            });
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication Scoring'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Rate your communication during this session',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  _buildScoreCard(
                    'Your Communication',
                    _userScores,
                    true,
                  ),
                  
                  _buildScoreCard(
                    '${widget.partner.name}\'s Communication',
                    _partnerScores,
                    false,
                  ),
                ],
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _saveScores,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save Scores & Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

