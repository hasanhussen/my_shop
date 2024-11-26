import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: auth.formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    key: const ValueKey('email'),
                    validator: (val) {
                      if (val!.isEmpty || !val.contains('@')) {
                        return 'Pleas enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => auth.email = val!,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                  ),
                  TextFormField(
                    key: const ValueKey('Password'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 7) {
                        return 'Password must be at least 7 characters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => auth.password = val!,
                    controller: auth.controller,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  if (!auth.isLogin)
                    TextFormField(
                      key: const ValueKey('confirmPassword'),
                      validator: (val) {
                        if (val != auth.controller.text) {
                          return 'Password do not match!';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      decoration:
                          const InputDecoration(labelText: 'confirmPassword'),
                      obscureText: true,
                    ),
                  const SizedBox(height: 12),
                  if (auth.isLoading) const CircularProgressIndicator(),
                  if (!auth.isLoading)
                    ElevatedButton(
                        onPressed: () {
                          Provider.of<Auth>(context, listen: false)
                              .submit(context);
                        },
                        child: Text(auth.isLogin ? 'Login' : 'Sign Up')),
                  if (!auth.isLoading)
                    TextButton(
                        onPressed: () {
                          auth.onTextButton();
                        },
                        child: Text(auth.isLogin
                            ? 'Create new account'
                            : 'I already have an account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
