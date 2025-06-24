import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiBlocProviderTree extends StatelessWidget {
  final List<BlocProvider> providers;
  final Widget child;

  const MultiBlocProviderTree({
    Key? key,
    required this.providers,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: child,
    );
  }
}
