import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/score_model.dart';
import '../models/reflection_model.dart';
import '../models/session_model.dart';

// TODO: Fetch and display weekly summaries and trends
// TODO: Visualize communication scores with charts
// TODO: List saved reflections and exercises
// TODO: Polish UI for accessibility and motivation

class InsightsDashboardScreen extends StatefulWidget {
  const InsightsDashboardScreen({super.key});

  @override
  State<InsightsDashboardScreen> createState() => _InsightsDashboardScreenState();
}

class _InsightsDashboardScreenState extends State<InsightsDashboardScreen> {
  List<ScoreModel> _scores = [];
  List<ReflectionModel> _reflections = [];
  List<SessionModel> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // TODO: Load data from database
    // For now, using mock data
    _loadMockData();
  }

  void _loadMockData() {
    // Mock scores for the last 4 weeks
    _scores = [
      ScoreModel(
        id: '1',
        sessionId: 'session1',
        userId: 'user1',
        partnerId: 'partner1',
        userScores: {'empathy': 8, 'listening': 7, 'reception': 6, 'clarity': 8, 'respect': 9, 'responsiveness': 7, 'openMindedness': 8},
        partnerScores: {'empathy': 7, 'listening': 8, 'reception': 7, 'clarity': 6, 'respect': 8, 'responsiveness': 8, 'openMindedness': 7},
        userTotalScore: 53,
        partnerTotalScore: 51,
        userStrengths: ['Excellent respect', 'Good empathy'],
        userSuggestions: ['Continue developing reception'],
        partnerStrengths: ['Good listening', 'Good responsiveness'],
        partnerSuggestions: ['Work on improving clarity'],
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
      ),
      ScoreModel(
        id: '2',
        sessionId: 'session2',
        userId: 'user1',
        partnerId: 'partner1',
        userScores: {'empathy': 9, 'listening': 8, 'reception': 7, 'clarity': 9, 'respect': 9, 'responsiveness': 8, 'openMindedness': 9},
        partnerScores: {'empathy': 8, 'listening': 9, 'reception': 8, 'clarity': 7, 'respect': 9, 'responsiveness': 9, 'openMindedness': 8},
        userTotalScore: 59,
        partnerTotalScore: 58,
        userStrengths: ['Excellent empathy', 'Excellent clarity', 'Excellent respect'],
        userSuggestions: [],
        partnerStrengths: ['Excellent listening', 'Excellent responsiveness'],
        partnerSuggestions: ['Continue developing clarity'],
        timestamp: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ];

    // Mock reflections
    _reflections = [
      ReflectionModel(
        id: '1',
        sessionId: 'session1',
        userId: 'user1',
        partnerId: 'partner1',
        userReflection: 'I appreciated how my partner listened without interrupting.',
        partnerReflection: 'I felt heard and understood during our conversation.',
        sharedGratitude: ['Thank you for your patience', 'Thank you for being open'],
        bondingActivities: ['Take a walk together', 'Plan a date night'],
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        isCompleted: true,
      ),
    ];

    // Mock sessions
    _sessions = [
      SessionModel(
        id: 'session1',
        userId: 'user1',
        partnerId: 'partner1',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        status: 'completed',
        userScore: 53,
        partnerScore: 51,
      ),
      SessionModel(
        id: 'session2',
        userId: 'user1',
        partnerId: 'partner1',
        timestamp: DateTime.now().subtract(const Duration(days: 14)),
        status: 'completed',
        userScore: 59,
        partnerScore: 58,
      ),
    ];

    setState(() {});
  }

  double _getAverageScore(List<ScoreModel> scores, bool isUser) {
    if (scores.isEmpty) return 0;
    final totalScores = scores.map((score) => isUser ? score.userTotalScore : score.partnerTotalScore);
    return totalScores.reduce((a, b) => a + b) / totalScores.length;
  }

  Widget _buildProgressChart() {
    final userScores = _scores.map((score) => score.userTotalScore.toDouble()).toList();
    final partnerScores = _scores.map((score) => score.partnerTotalScore.toDouble()).toList();
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Communication Progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 10,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text('W${value.toInt() + 1}');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: userScores.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: const Color(0xFF4DB6AC),
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: partnerScores.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: const Color(0xFFF8BBD9),
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: const Color(0xFF4DB6AC),
                ),
                const SizedBox(width: 8),
                const Text('You'),
                const SizedBox(width: 24),
                Container(
                  width: 12,
                  height: 12,
                  color: const Color(0xFFF8BBD9),
                ),
                const SizedBox(width: 8),
                const Text('Partner'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummary() {
    final weeklySessions = _sessions.where((session) {
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      return session.timestamp.isAfter(weekAgo);
    }).length;

    final averageUserScore = _getAverageScore(_scores, true);
    final averagePartnerScore = _getAverageScore(_scores, false);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week\'s Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Sessions',
                    weeklySessions.toString(),
                    Icons.schedule,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Your Avg Score',
                    averageUserScore.toStringAsFixed(1),
                    Icons.person,
                    color: const Color(0xFF4DB6AC),
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Partner Avg Score',
                    averagePartnerScore.toStringAsFixed(1),
                    Icons.favorite,
                    color: const Color(0xFFF8BBD9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Theme.of(context).primaryColor, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color ?? Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReflectionsList() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Reflections',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all reflections
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_reflections.isEmpty)
              const Center(
                child: Text('No reflections yet. Complete a session to see your insights here.'),
              )
            else
              ..._reflections.map((reflection) => _buildReflectionItem(reflection)),
          ],
        ),
      ),
    );
  }

  Widget _buildReflectionItem(ReflectionModel reflection) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Session on ${reflection.timestamp.toString().split(' ')[0]}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            reflection.userReflection,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (reflection.bondingActivities.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Activities: ${reflection.bondingActivities.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildWeeklySummary(),
            _buildProgressChart(),
            _buildReflectionsList(),
          ],
        ),
      ),
    );
  }
}
