import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';

/// Route for menu page.
class MenuRoute extends StatefulWidget {
  /// Route for menu page.
  const MenuRoute();

  @override
  _MenuRouteState createState() => _MenuRouteState();
}

class _MenuRouteState extends State<MenuRoute> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                  child: Text(
                'MinePi Monitor',
                style: TextStyle(fontSize: 48),
              )),
              Container(height: 48),
              TextField(
                decoration: const InputDecoration(labelText: 'Identifier:'),
                controller: _textController,
              ),
              ElevatedButton(
                onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationRequested(
                        identifier: _textController.text)),
                child: const Text('Submit'),
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                if (state is AuthenticationLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AuthenticationError) {
                  return Text(state.message);
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
