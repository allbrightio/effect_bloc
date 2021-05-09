import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

///
/// Bloc with side effects
///
abstract class EffectBloc<Event, State, Effect> extends Bloc<State, State>
    with EffectBlocMixin<State, Effect> {
  EffectBloc(State initialState) : super(initialState);
}

///
/// Cubit with side effects
///
abstract class EffectCubit<State, Effect> extends Cubit<State>
    with EffectBlocMixin<State, Effect> {
  EffectCubit(State initialState) : super(initialState);
}

///
/// Base class of the effect bloc
///
abstract class EffectBlocBase<Effect> {
  Stream<Effect> get effectStream;

  void emitEffect(Effect effect);

  @mustCallSuper
  void onEffect(Effect effect);
}

///
/// Base class of the effect bloc
///
abstract class EffectBlocMixin<State, Effect>
    implements BlocBase<State>, EffectBlocBase<Effect> {
  StreamController<Effect>? __effectController;

  StreamController<Effect> get _effectController {
    return __effectController ??= StreamController<Effect>.broadcast();
  }

  /// The current side effects stream.
  @override
  Stream<Effect> get effectStream => _effectController.stream;

  @override
  void emitEffect(Effect effect) {
    if (_effectController.isClosed) return;
    onEffect(effect);
    _effectController.add(effect);
  }

  @mustCallSuper
  @override
  void onEffect(Effect effect) {}

  @mustCallSuper
  @override
  Future<void> close() async {
    await _closeEffect();
  }

  Future<void> _closeEffect() async {
    await _effectController.close();
  }
}
