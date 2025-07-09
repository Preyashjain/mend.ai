import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/appwrite_service.dart';

class PartnerInviteScreen extends StatefulWidget {
  const PartnerInviteScreen({super.key});

  @override
  State<PartnerInviteScreen> createState() => _PartnerInviteScreenState();
}

class _PartnerInviteScreenState extends State<PartnerInviteScreen> {
  final TextEditingController _partnerNameController = TextEditingController();
  String? _generatedCode;
  String? _inviteMessage;
  bool _loading = false;

  final _appwriteService = AppwriteService();

  @override
  void initState() {
    super.initState();
    _loadCurrentUserInviteCode();
  }

  Future<void> _loadCurrentUserInviteCode() async {
    setState(() {
      _loading = true;
    });

    try {
      // Get current user from Appwrite
      final currentUser = await _appwriteService.getUser();
      
      // Get user profile data
      final userProfile = await _appwriteService.getUserById(currentUser.$id);
      
      if (userProfile != null && userProfile.partnerInviteCode != null) {
        setState(() {
          _generatedCode = userProfile.partnerInviteCode;
          _generateInviteMessage(userProfile.name, _partnerNameController.text.trim());
        });
      }
    } catch (e) {
      debugPrint('Error loading user invite code: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _generateInviteMessage(String userName, String partnerName) {
    if (_generatedCode != null) {
      setState(() {
        _inviteMessage = '''Hi $partnerName,

I just downloaded Mend, an app designed to help couples communicate better and strengthen their relationship. I'd love for you to join me!

Use this code to join our space: $_generatedCode

Download Mend and let's work together to build an even stronger relationship.

Love,
$userName''';
      });
    }
  }

  void _shareInvite() {
    if (_inviteMessage != null) {
      Clipboard.setData(ClipboardData(text: _inviteMessage!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invite message copied to clipboard!'),
          backgroundColor: Color(0xFF4DB6AC),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Your Partner'),
        backgroundColor: const Color(0xFF4DB6AC),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.favorite,
                      size: 64,
                      color: Color(0xFFE1BEE7),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mend works best with your partner!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Send them a personalized invite to join your relationship space.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _partnerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Partner\'s Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_add),
                        hintText: 'Enter your partner\'s name',
                      ),
                      onChanged: (value) {
                        if (_generatedCode != null) {
                          _generateInviteMessage('Your partner', value);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    if (_loading)
                      const Center(
                                child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4DB6AC)),
                                ),
                              )
                    else if (_generatedCode != null && _inviteMessage != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF4DB6AC),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Invite Ready!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4DB6AC),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Your invite code:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4DB6AC).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF4DB6AC)),
                                ),
                                child: Text(
                                  _generatedCode!,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4DB6AC),
                                    letterSpacing: 2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Personalized message:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  _inviteMessage!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (_generatedCode != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareInvite,
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy Message'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4DB6AC),
                        side: const BorderSide(color: Color(0xFF4DB6AC)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Continue'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
