import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:effect_bloc/effect_bloc.dart';

typedef EffectBlocWidgetListener<E> = void Function(
    BuildContext context, E effect);

class EffectBlocConsumer<B extends EffectBlocBase<S, E>, S, E>
    extends StatefulWidget {
  final BlocWidgetBuilder<S> builder;
  final EffectBlocWidgetListener<E> effectListener;
  final BlocBuilderCondition<S>? buildWhen;

  final B? bloc;

  const EffectBlocConsumer({
    Key? key,
    required this.builder,
    required this.effectListener,
    this.bloc,
    this.buildWhen,
  }) : super(key: key);

  @override
  State<EffectBlocConsumer<B, S, E>> createState() =>
      _EffectBlocConsumerState<B, S, E>();
}

class _EffectBlocConsumerState<B extends EffectBlocBase<S, E>, S, E>
    extends State<EffectBlocConsumer<B, S, E>> {
  late B _bloc;

  StreamSubscription<E>? _subscription;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _subscribe();
  }

  @override
  void didUpdateWidget(EffectBlocConsumer<B, S, E> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      _bloc = currentBloc;
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: widget.builder,
      buildWhen: widget.buildWhen,
      bloc: widget.bloc,
    );
  }

  void _subscribe() {
    _subscription = _bloc.effectStream.listen((state) {
      widget.effectListener(context, state);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
