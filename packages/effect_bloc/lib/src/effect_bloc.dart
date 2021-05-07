import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

///
/// Bloc with side effects
///
abstract class EffectBloc<Event, State, Effect>
    extends EffectBlocBase<State, Effect> {
  EffectBloc(State initialState) : super(initialState);

  // TODO bloc implementation
}

///
/// Cubit with side effects
///
abstract class EffectCubit<State, Effect>
    extends EffectBlocBase<State, Effect> {
  EffectCubit(State initialState) : super(initialState);

  @override
  Future<void> close() {
    _closeEffect();
    return super.close();
  }
}

abstract class EffectBlocBase<State, Effect> extends BlocBase<State> {
  EffectBlocBase(State state) : super(state);

  StreamController<Effect>? __effectController;

  StreamController<Effect> get _effectController {
    return __effectController ??= StreamController<Effect>.broadcast();
  }

  /// The current side effects stream.
  Stream<Effect> get effectStream => _effectController.stream;

  void emitEffect(Effect effect) {
    if (_effectController.isClosed) return;
    onEffect(effect);
    _effectController.add(effect);
  }

  @mustCallSuper
  void onEffect(Effect effect) {}

  @override
  Future<void> close() {
    _closeEffect();
    return super.close();
  }

  Future<void> _closeEffect() async {
    await _effectController.close();
  }
}
