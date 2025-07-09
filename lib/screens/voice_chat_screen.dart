import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';

class VoiceChatScreen extends StatefulWidget {
  final String partnerId;
  final UserModel currentUser;
  final UserModel partner;

  const VoiceChatScreen({
    super.key,
    required this.partnerId,
    required this.currentUser,
    required this.partner,
  });

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  bool _isJoined = false;
  bool _isMuted = false;
  bool _isInterrupted = false;
  String _currentSpeaker = 'user'; // 'user' or 'partner'
  final List<String> _aiPrompts = [];
  final List<String> _interruptions = [];
  int _sessionDuration = 0;
  late SessionModel _session;
  bool _isRecording = false;

  // Color coding for speakers
  Color get _userColor => widget.currentUser.gender == widget.partner.gender 
      ? const Color(0xFF1976D2) // Darker blue for same gender
      : const Color(0xFF4DB6AC); // Light blue
  
  Color get _partnerColor => widget.currentUser.gender == widget.partner.gender
      ? const Color(0xFFC2185B) // Darker pink for same gender
      : const Color(0xFFF8BBD9); // Light pink

  @override
  void initState() {
    super.initState();
    _startSession();
    _startTimer();
    _joinSession();
  }

  void _startSession() {
    _session = SessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.currentUser.id,
      partnerId: widget.partnerId,
      timestamp: DateTime.now(),
    );
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _sessionDuration++;
        });
        _startTimer();
      }
    });
  }

  void _joinSession() {
    // Simulate joining session
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isJoined = true;
          _addAIPrompt('What is the main concern you\'d like to address today?');
        });
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  void _detectInterruption() {
    // Simulate interruption detection
    if (_currentSpeaker == 'partner' && _isJoined) {
      setState(() {
        _isInterrupted = true;
        _interruptions.add('User interrupted partner');
      });
      
      // Flash red and show warning
      _showInterruptionWarning();
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isInterrupted = false;
          });
        }
      });
    }
  }

  void _showInterruptionWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please let ${widget.partner.name} finish their thought before responding.'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addAIPrompt(String prompt) {
    setState(() {
      _aiPrompts.add(prompt);
    });
  }

  void _switchSpeaker() {
    setState(() {
      _currentSpeaker = _currentSpeaker == 'user' ? 'partner' : 'user';
    });
  }

  Widget _buildAudioVisualization() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(20, (index) {
          final height = _isRecording 
              ? (20 + (index % 3) * 10).toDouble()
              : 10.0;
          return Container(
            width: 4,
            height: height,
            decoration: BoxDecoration(
              color: _currentSpeaker == 'user' ? _userColor : _partnerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isInterrupted 
          ? Colors.red.withOpacity(0.1)
          : _currentSpeaker == 'user' 
              ? _userColor.withOpacity(0.1)
              : _partnerColor.withOpacity(0.1),
      appBar: AppBar(
        title: Text('Session with ${widget.partner.name}'),
        actions: [
          IconButton(
            icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
            onPressed: _toggleMute,
          ),
        ],
      ),
      body: Column(
        children: [
          // Session info
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration: ${_sessionDuration ~/ 60}:${(_sessionDuration % 60).toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _currentSpeaker == 'user' ? _userColor : _partnerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _currentSpeaker == 'user' ? 'You speaking' : '${widget.partner.name} speaking',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Main chat area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Audio visualization
                  _buildAudioVisualization(),

                  // AI Prompts
                  if (_aiPrompts.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Guidance:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ..._aiPrompts.map((prompt) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(prompt),
                          )),
                        ],
                      ),
                    ),

                  const Spacer(),

                  // Controls
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: _detectInterruption,
                          icon: const Icon(Icons.warning),
                          tooltip: 'Test interruption',
                        ),
                        IconButton(
                          onPressed: _switchSpeaker,
                          icon: const Icon(Icons.swap_horiz),
                          tooltip: 'Switch speaker',
                        ),
                        IconButton(
                          onPressed: () => _addAIPrompt('How do you feel about what your partner just said?'),
                          icon: const Icon(Icons.psychology),
                          tooltip: 'Add AI prompt',
                        ),
                        IconButton(
                          onPressed: _toggleRecording,
                          icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
                          color: _isRecording ? Colors.red : null,
                          tooltip: 'Toggle recording',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // End session and go to scoring
                    Navigator.pushReplacementNamed(context, '/scoring', arguments: _session.id);
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('End Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Pause session
                  },
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
