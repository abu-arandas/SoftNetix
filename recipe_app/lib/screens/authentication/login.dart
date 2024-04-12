import 'package:flutter/material.dart';

import '/constants.dart';

import '/controllers/authentication.dart';

import '/screens/authentication/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.png',
                    color: Colors.black,
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  'Sign In',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your email and Password to get access',
                ),
                const SizedBox(height: 16),

                // Form
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '* required';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return '* enter a valid email';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => obscureText = !obscureText),
                              icon: Icon(obscureText
                                  ? Icons.remove_red_eye
                                  : Icons.lock),
                            ),
                          ),
                          controller: password,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '* required';
                            } else if (value.length < 6) {
                              return '* must be 6 characters';
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmitted: (value) => validator(),
                        ),
                        const SizedBox(height: 16),

                        // Login
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () => validator(),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(400, 50),
                            ),
                            child: const Text('Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Register
                Container(
                  padding: const EdgeInsets.all(16),
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('don\'t have an account'),
                      TextButton(
                        onPressed: () =>
                            page(context: context, page: const Register()),
                        child: const Text('register'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void validator() {
    if (formKey.currentState!.validate()) {
      AuthenticationController.login(
        context: context,
        email: email.text,
        password: password.text,
      );
    }
  }
}
