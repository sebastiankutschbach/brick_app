import 'package:brick_app/application/cubit/login_page_cubit.dart';
import 'package:brick_app/injection.dart';
import 'package:brick_app/presentation/pages/overview_page.dart';
import 'package:brick_app/presentation/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => getIt<LoginPageCubit>(),
        child: BlocConsumer<LoginPageCubit, LoginPageState>(
          listener: (context, state) {
            if (state is LoginPageLoginSucceeded) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OverviewPage(),
                ),
              );
            } else if (state is LoginPageLoginFailed) {
              _showDialog(context, 'Failed to Login', state.failure.message);
            }
          },
          builder: (context, state) {
            final loginCubit = context.read<LoginPageCubit>();
            return Scaffold(
              appBar: BrickAppBar(
                const Text('Rebrickable Login'),
                showLogoutButton: false,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        children: [
                          TextField(
                            key: const Key('username'),
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                            onChanged: (value) =>
                                loginCubit.usernameChanged(value),
                          ),
                          TextField(
                            key: const Key('password'),
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            onChanged: (value) =>
                                loginCubit.passwordChanged(value),
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            key: const Key('login'),
                            onPressed: () {
                              loginCubit.login();
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
}

Future<void> _showDialog(
    BuildContext context, String title, String message) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
      );
    },
  );
}
