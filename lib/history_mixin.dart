import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin HistoryMixin<T> on StateNotifier<T> {
  List<T> _history = [];

  int _undoIndex = 0;

  bool get _canUndo => _undoIndex + 1 < _history.length;

  bool get _canRedo => _undoIndex > 0;

  @override
  set state(T value) {
    _clearRedoHistory();
    _history.insert(0, value);
    super.state = value;
  }

  void undo() {
    if (_canUndo) {
      super.state = _history[++_undoIndex];
    }
  }

  void redo() {
    if (_canRedo) {
      super.state = _history[--_undoIndex];
    }
  }

  void reset() {
    if (_history.isNotEmpty) {
      final initialState = _history.last;
      _history.clear();
      super.state = initialState;
      _history.insert(0, initialState);
      _undoIndex = 0;
    }
  }

  void _clearRedoHistory() {
    _history = _history.sublist(_undoIndex, _history.length);
    _undoIndex = 0;
  }
}
