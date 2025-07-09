import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';

enum Speaker { partnerA, partnerB, ai }

class SessionScreen extends StatefulWidget {
  final String partnerId;
  const SessionScreen({super.key, required this.partnerId});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final AppwriteService _appwriteService = AppwriteService();
  String? _sessionId;
  final List<String> _conversation = [];
  Speaker _currentSpeaker = Speaker.ai;
  int _score = 0;
  bool _loading = true;

  final List<String> _aiPrompts = [
    "Welcome to Mend. Let's begin your session.",
    "How do you both feel today?",
    "What triggered the recent conflict?",
    "Can you express your partner’s point of view?",
    "What's something you admire about your partner?",
    "What is one way you can reconnect this week?"
  ];
  int _promptIndex = 0;

  final TextEditingController _partnerAController = TextEditingController();
  final TextEditingController _partnerBController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    try {
      final user = await _appwriteService.getUser();
      final session = await _appwriteService.createSession(
        userId: user.$id,
        partnerId: widget.partnerId,
      );
      _sessionId = session.id;
      _subscribeToRealtime();
      _sendAIMessage(_aiPrompts[_promptIndex]);
    } catch (e) {
      debugPrint('Error starting session: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _subscribeToRealtime() {
    if (_sessionId == null) return;
    _appwriteService.subscribeToSession(_sessionId!, (type, data) {
      if (type == 'reflection') {
        setState(() => _conversation.add('AI: ${data['content']}'));
      } else if (type == 'score') {
        setState(() => _score = data['score']);
      }
    });
  }

  Future<void> _sendAIMessage(String message) async {
    if (_sessionId == null) return;
    _conversation.add('AI: $message');
    setState(() {});
    // For now, just add to conversation without saving to database
    await Future.delayed(const Duration(seconds: 4));
    setState(() => _currentSpeaker = Speaker.partnerA);
  }

  void _submitPartnerMessage(Speaker speaker, String message) async {
    if (_sessionId == null || message.trim().isEmpty) return;
    final label = speaker == Speaker.partnerA ? "Partner A" : "Partner B";
    _conversation.add("$label: $message");
    setState(() {});
    // For now, just add to conversation without saving to database
    if (speaker == Speaker.partnerA) {
      setState(() => _currentSpeaker = Speaker.partnerB);
    } else {
      _nextPrompt();
    }
  }

  void _nextPrompt() {
    if (_promptIndex < _aiPrompts.length - 1) {
      _promptIndex++;
      _currentSpeaker = Speaker.ai;
      _sendAIMessage(_aiPrompts[_promptIndex]);
    }
  }

  void _endSession() async {
    if (_sessionId == null) return;
    final summary = 'Session ended with ${_conversation.length} messages.';
    // For now, just navigate to scores without saving to database
    if (mounted) Navigator.pushNamed(context, '/scores');
  }

  @override
  void dispose() {
    _partnerAController.dispose();
    _partnerBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: _endSession,
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _conversation.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(_conversation[index]),
                    ),
                  ),
                ),
                if (_currentSpeaker == Speaker.partnerA)
                  _buildInputField(_partnerAController, Speaker.partnerA),
                if (_currentSpeaker == Speaker.partnerB)
                  _buildInputField(_partnerBController, Speaker.partnerB),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Score so far: $_score/10', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _currentSpeaker == Speaker.ai ? null : _nextPrompt,
                        child: const Text('Next Prompt'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildInputField(TextEditingController controller, Speaker speaker) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: speaker == Speaker.partnerA ? 'Partner A speaks...' : 'Partner B speaks...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _submitPartnerMessage(speaker, controller.text);
              controller.clear();
            },
          )
        ],
      ),
    );
  }
}
