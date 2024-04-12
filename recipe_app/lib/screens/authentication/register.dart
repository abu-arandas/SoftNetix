import 'package:flutter/material.dart';

import '/models/user.dart';

import '/constants.dart';

import '/controllers/authentication.dart';

import '/screens/authentication/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController name = TextEditingController();
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
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Resigter',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Let’s help you set up your account, it won’t take long.',
                  ),
                  const SizedBox(height: 64),

                  // Form
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            'Name',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: name,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '* required';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 16),

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
                            onEditingComplete: () => validator(),
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
                        const Text('already have an account'),
                        TextButton(
                          onPressed: () =>
                              page(context: context, page: const Login()),
                          child: const Text('login'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void validator() {
    if (formKey.currentState!.validate()) {
      AuthenticationController.register(
        context: context,
        user: UserModel(
          id: '',
          name: name.text,
          email: email.text,
          password: password.text,
        ),
      );
    }
  }
}
