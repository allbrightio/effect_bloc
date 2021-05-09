import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:effect_bloc/effect_bloc.dart';

typedef EffectBlocWidgetListener<E> = void Function(
    BuildContext context, E effect);

typedef EffectBlocWidgetBuilder<S> = Widget Function(
    BuildContext context, S state);

///
/// EffectBlocConsumerBase
///
class EffectBlocConsumerBase<E extends EffectBlocBase<T>, T>
    extends StatefulWidget {
  final EffectBlocWidgetListener<T> effectListener;
  final E? effect;
  final Widget child;

  const EffectBlocConsumerBase({
    Key? key,
    required this.child,
    required this.effect,
    required this.effectListener,
  }) : super(key: key);

  @override
  State<EffectBlocConsumerBase<E, T>> createState() =>
      _EffectBlocConsumerBaseState<E, T>();
}

class _EffectBlocConsumerBaseState<E extends EffectBlocBase<T>, T>
    extends State<EffectBlocConsumerBase<E, T>> {
  StreamSubscription<T>? _subscription;
  late E _effect;

  @override
  void initState() {
    super.initState();
    _effect = widget.effect ?? context.read<E>();
    _subscribe();
  }

  @override
  void didUpdateWidget(EffectBlocConsumerBase<E, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldEffect = oldWidget.effect;
    final currentEffect = widget.effect ?? context.read<E>();
    if (oldEffect != currentEffect) {
      _effect = currentEffect;
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _subscribe() {
    _subscription = _effect.effectStream.listen((state) {
      widget.effectListener(context, state);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}

///
/// EffectBlocConsumer
///
class EffectBlocConsumer<B extends BlocEffect<S, E>, S, E>
    extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // final effect = bloc as EffectBlocBase<E>;

    return EffectBlocConsumerBase<EffectBlocBase<E>, E>(
        child: BlocBuilder<B, S>(
          builder: builder,
          buildWhen: buildWhen,
          bloc: bloc,
        ),
        effect: bloc,
        effectListener: effectListener);
  }
}
