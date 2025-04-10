import 'package:super_store_e_commerce_flutter/imports.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // total height and width of screen
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppNameWidget(),
              const SizedBox(height: 100),
              CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'example@example.com',
                  prefixIcon: Icons.email),
              const SizedBox(height: 20.0),
              CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Password',
                  prefixIcon: Icons.lock),
              const SizedBox(height: 10.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      // Show a dialog to get email for password reset
                      _showForgotPasswordDialog(context);
                    },
                    child: const TextBuilder(
                      text: 'Forgot Password',
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: MaterialButton(
                  height: 60,
                  color: Colors.black,
                  minWidth: size.width * 0.8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () async {
                    if (_emailController.text.trim().isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      final success = await authProvider.signIn(
                          _emailController.text.trim(),
                          _passwordController.text);

                      if (success && mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const Home()),
                            (route) => false);
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text(authProvider.error ?? 'Login failed')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please enter email and password')));
                    }
                  },
                  child: const TextBuilder(
                    text: 'Login',
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextBuilder(
                    text: "Don't have an account? ",
                    color: Colors.black,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const Register()));
                    },
                    child: const TextBuilder(
                      text: 'Sign Up',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Show dialog for password reset
  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: resetEmailController,
          decoration: const InputDecoration(
            hintText: 'Enter your email',
            labelText: 'Email',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (resetEmailController.text.trim().isNotEmpty) {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                final success = await authProvider
                    .resetPassword(resetEmailController.text.trim());

                // Close the dialog
                Navigator.pop(context);

                // Show message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Password reset link sent to your email'
                        : authProvider.error ?? 'Failed to send reset link'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your email')),
                );
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
