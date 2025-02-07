import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_track/core/router/app_router.dart';
import 'package:order_track/core/utils/size_config.dart';
import 'package:order_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:order_track/features/auth/presentation/widgets/auth_button.dart';
import 'package:order_track/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:order_track/features/auth/presentation/widgets/set_base_url_widget.dart';
import 'package:order_track/features/client/presentation/bloc/client_bloc.dart';
import 'package:order_track/features/distributor/presentation/bloc/distributor_orders_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      //* allocator
      // _emailTextController.text = "israel.leonf92@gmail.com";
      // _passwordTextController.text = "Testing2017*";
      //* distributor
      // _emailTextController.text = "distributor@gmail.com";
      // _passwordTextController.text = "distributor@gmail.com";
      //* client
      _emailTextController.text = "client@gmail.com";
      _passwordTextController.text = "client@gmail.com";
    }
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Form(
            key: _formKey,
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  switch (state.user.role) {
                    case 'allocator':
                      context.go(AppRoutes.allocatorHome);
                      break;
                    case 'distributor':
                      //* Dispatch an event to DistributorOrdersBloc to fetch orders for the logged-in user
                      context
                          .read<DistributorOrdersBloc>()
                          .add(GetDistributorOrdersEvent(state.user.id));
                      context.go(AppRoutes.distributorHome);
                      break;
                    case 'client':
                      //* Dispatch an event to ClientBloc to fetch orders for the logged-in user
                      context
                          .read<ClientBloc>()
                          .add(GetClientOrdersEvent(state.user.id));
                      context.go(AppRoutes.clientHome);
                      break;
                  }
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.failure.message)),
                  );
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Bienvenido!',
                            style: TextStyle(
                              fontSize: 34.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        AuthTextField(
                          hint: "Correo electrónico",
                          controller: _emailTextController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                        SizedBox(height: 8.h),
                        AuthTextField(
                          hint: "Contraseña",
                          obscureText: true,
                          controller: _passwordTextController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onSignIn(context),
                        ),
                        SizedBox(height: 8.h),
                        state is AuthLoading
                            ? CircularProgressIndicator()
                            : AuthButton(
                                text: "Sign In",
                                onPressed: () => _onSignIn(context),
                              ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SetBaseUrlWidget(),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onSignIn(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          LoginEvent(
            email: _emailTextController.text,
            password: _passwordTextController.text,
          ),
        );
  }
}
