import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _appwriteService = AppwriteService();
  bool _isLoading = false;
  bool _isLogin = true;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
    setState(() {
        _isLoading = true;
    });

    try {
      if (_isLogin) {
          // Login
          await _appwriteService.signIn(
            _emailController.text.trim(),
            _passwordController.text,
        );
      } else {
          // Sign up
          await _appwriteService.signUp(
            _emailController.text.trim(),
            _passwordController.text,
            'User', // Default name, will be updated in onboarding
          );
        }

      if (mounted) {
          // Check if user is onboarded
          final user = await _appwriteService.getUser();
          final userProfile = await _appwriteService.getUserById(user.$id);
          
          if (userProfile != null && userProfile.isOnboarded) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
        }
      } catch (e) {
        if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isLogin ? 'Login failed: ${e.toString()}' : 'Sign up failed: ${e.toString()}'),
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

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4DB6AC),
              Color(0xFF81C784),
            ],
          ),
      ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
        child: Padding(
                  padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
              children: [
                        const Icon(
                          Icons.favorite,
                          size: 64,
                          color: Color(0xFF4DB6AC),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome to Mend',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4DB6AC),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLogin ? 'Sign in to continue' : 'Create your account',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
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
                  controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                  obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (!_isLogin && value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                ),
                const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF4DB6AC),
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(_isLogin ? 'Sign In' : 'Sign Up'),
                ),
                        ),
                        const SizedBox(height: 16),
                TextButton(
                          onPressed: _toggleMode,
                          child: Text(
                            _isLogin 
                                ? 'Don\'t have an account? Sign Up' 
                                : 'Already have an account? Sign In',
                          ),
                        ),
                        if (!_isLogin) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'By signing up, you agree to our Terms of Service and Privacy Policy',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                ),
              ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
