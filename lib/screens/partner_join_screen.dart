import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:appwrite/appwrite.dart'; // 🛠️ REQUIRED for Query
import '../services/appwrite_service.dart';

class PartnerJoinScreen extends StatefulWidget {
  const PartnerJoinScreen({super.key});

  @override
  State<PartnerJoinScreen> createState() => _PartnerJoinScreenState();
}

class _PartnerJoinScreenState extends State<PartnerJoinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final AppwriteService _appwriteService = AppwriteService();

  String gender = 'Male';
  bool _loading = false;

  Future<void> _joinWithCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      final code = _codeController.text.trim().toUpperCase();
      final name = _nameController.text.trim();

      // 1️⃣ Find existing user with matching invite code
      final partnerUser = await _appwriteService.getUserByInviteCode(code);

      if (partnerUser == null) {
        throw Exception('Invalid code. Please check and try again.');
      }

      // 2️⃣ Create new user (this partner)
      final newUser = await _appwriteService.createUser(
        name: name,
        email: '${name.toLowerCase().replaceAll(' ', '')}@mend.local',
        gender: gender,
      );

      // 3️⃣ Connect partners
      await _appwriteService.connectPartners(
        newUser.id,
        partnerUser.id,
        newUser.name,
        partnerUser.name,
        newUser.gender,
        partnerUser.gender,
      );

      // 4️⃣ Create session between them
      await _appwriteService.createSession(
        userId: newUser.id,
        partnerId: partnerUser.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully joined! Welcome to Mend.'),
            backgroundColor: Color(0xFF4DB6AC),
          ),
        );
        Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Your Partner'),
        backgroundColor: const Color(0xFF4DB6AC),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.favorite_border, size: 64, color: Color(0xFFE1BEE7)),
                      const SizedBox(height: 16),
                      const Text('Join your partner\'s space', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Enter the invite code your partner shared with you.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: 'Invite Code',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.key),
                          hintText: 'Enter 6-character code',
                        ),
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the invite code';
                          }
                          if (value.length != 6) {
                            return 'Code must be 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: gender,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.people),
                        ),
                        items: ['Male', 'Female', 'Non-binary', 'Prefer not to say']
                            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      Card(
                        color: const Color(0xFF4DB6AC).withOpacity(0.1),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Color(0xFF4DB6AC)),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'By joining, you\'ll be connected to your partner\'s Mend space for better communication and relationship growth.',
                                  style: TextStyle(color: Color(0xFF4DB6AC)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _joinWithCode,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Join Partner'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
