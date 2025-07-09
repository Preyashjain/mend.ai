import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';
import '../models/user_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _appwriteService = AppwriteService();
  int _currentStep = 0;
  bool _isLoading = false;

  String gender = 'Male';
  List<String> relationshipGoals = [];
  List<String> currentChallenges = [];

  final List<String> relationshipGoalOptions = [
    'Communication',
    'Conflict resolution',
    'Intimacy',
    'Trust',
    'Shared decision-making',
    'Quality time together',
    'Financial planning',
    'Future planning',
  ];

  final List<String> currentChallengeOptions = [
    'Frequent arguments',
    'Feeling unheard or misunderstood',
    'Lack of quality time together',
    'Financial stress',
    'Differences in parenting styles',
    'Loss of intimacy',
    'External pressures (work, family)',
    'Trust issues',
    'Different life goals',
  ];

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
      final name = nameController.text.trim();
        final email = emailController.text.trim();
        final password = passwordController.text;

        // Create user account in Appwrite
        await _appwriteService.signUp(email, password, name);

        // Create user profile data
        final user = await _appwriteService.createUser(
          name: name,
          email: email,
          gender: gender,
          relationshipGoals: relationshipGoals,
          currentChallenges: currentChallenges,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome to Mend! Your invite code: ${user.partnerInviteCode}'),
              backgroundColor: const Color(0xFF4DB6AC),
            ),
          );
          
          // Navigate to invite screen
          Navigator.pushNamed(context, '/invite');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Let\'s get to know you',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tell us a bit about yourself to personalize your experience.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: nameController,
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
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
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
      ],
    );
  }

  Widget _buildRelationshipGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What are your relationship goals?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select all areas you\'d like to improve in your relationship.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: relationshipGoalOptions.map((goal) {
            final isSelected = relationshipGoals.contains(goal);
            return FilterChip(
              label: Text(goal),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    relationshipGoals.add(goal);
                  } else {
                    relationshipGoals.remove(goal);
                  }
                });
              },
              selectedColor: const Color(0xFF4DB6AC).withOpacity(0.3),
              checkmarkColor: const Color(0xFF4DB6AC),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCurrentChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What challenges are you currently facing?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select all that apply. This helps us provide better guidance.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: currentChallengeOptions.map((challenge) {
            final isSelected = currentChallenges.contains(challenge);
            return FilterChip(
              label: Text(challenge),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    currentChallenges.add(challenge);
                  } else {
                    currentChallenges.remove(challenge);
                  }
                });
              },
              selectedColor: const Color(0xFFE1BEE7).withOpacity(0.3),
              checkmarkColor: const Color(0xFF9C27B0),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Mend'),
        backgroundColor: const Color(0xFF4DB6AC),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_currentStep + 1) / 4,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4DB6AC)),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentStep == 0
                        ? _buildBasicInfo()
                        : _currentStep == 1
                            ? _buildRelationshipGoals()
                            : _buildCurrentChallenges(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: _previousStep,
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(),
                  ElevatedButton(
                    onPressed: _isLoading ? null : (_canProceed() ? _nextStep : null),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(_currentStep == 3 ? 'Complete' : 'Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return nameController.text.isNotEmpty && 
               emailController.text.isNotEmpty && 
               passwordController.text.isNotEmpty;
      case 1:
        return relationshipGoals.isNotEmpty;
      case 2:
        return currentChallenges.isNotEmpty;
      default:
        return true;
    }
  }
}
