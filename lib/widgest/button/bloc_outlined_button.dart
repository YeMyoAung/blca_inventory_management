import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomOutlinedButton<State extends Object,
    Bloc extends StateStreamable<State>> extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    required Function()? onPressed,
    required this.label,
    this.icon,
    this.style,
  })  : useBloc = false,
        _onPressed = onPressed,
        buildWhen = null,
        listenWhen = null,
        placeholder = null,
        _blocOnPressed = null,
        listener = null;

  const CustomOutlinedButton.bloc({
    super.key,
    required Function(Bloc bloc)? onPressed,
    required this.label,
    this.icon,
    this.style,
    this.listenWhen,
    this.buildWhen,

    ///bloc_state (loading,succesr,error)
    ///Function(bloc_state)
    /// bloc_state == loading return loading widget
    /// bloc_state == error return error widget
    /// bloc_state == success return null
    this.placeholder,
    this.listener,
  })  : useBloc = true,
        _blocOnPressed = onPressed,
        _onPressed = null;

  ///new
  final bool useBloc;

  final String label;
  final IconData? icon;
  final ButtonStyle? style;

  /// useBloc = False
  final Function()? _onPressed;

  /// useBloc = True
  final bool Function(State, State)? buildWhen, listenWhen;
  final Widget? Function(State state)? placeholder;
  final Function(Bloc bloc)? _blocOnPressed;
  final void Function(BuildContext, Bloc, State)? listener;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        if (icon != null) ...[
          const SizedBox(
            width: 5,
          ),
          Icon(icon),
        ],
      ],
    );

    if (!useBloc) {
      return OutlinedButton(
        style: style,
        onPressed: _onPressed,
        child: child,
      );
    }

    final bloc = context.read<Bloc>();
    return OutlinedButton(
      style: style,
      onPressed: () {
        _blocOnPressed?.call(bloc);
      },
      child: BlocConsumer<Bloc, State>(
        buildWhen: buildWhen,
        builder: (_, state) {
          return placeholder?.call(state) ?? child;
        },
        listener: (BuildContext context, State state) {
          listener?.call(context, bloc, state);
        },
        listenWhen: listenWhen,
      ),
    );
  }
}
