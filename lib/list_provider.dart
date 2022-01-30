import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'history_mixin.dart';

final listProvider = StateNotifierProvider<ListNotifier, List<String>>(
  (_) => ListNotifier(),
);

class ListNotifier extends StateNotifier<List<String>>
    with HistoryMixin<List<String>> {
  ListNotifier() : super([]) {
    state = [];
  }

  void add(String value) {
    state = [...state, value];
  }

  void edit(int index, String value) {
    final tempState = state.toList();
    tempState.removeAt(index);
    tempState.insert(index, value);
    state = tempState;
  }

  void remove(int index) {
    final tempState = state.toList();
    tempState.removeAt(index);
    state = tempState;
  }
}
