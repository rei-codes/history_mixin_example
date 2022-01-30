import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'list_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final provider = ref.watch(listProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return CustomDialog(
                    onConfirm: (text) => provider.add(text),
                  );
                },
              );
            },
            child: const Text('add'),
          ),
        ],
      ),
      body: Consumer(
        builder: (_, ref, __) {
          final list = ref.watch(listProvider);
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) {
              return Row(
                children: [
                  Expanded(child: Text(list[index])),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return CustomDialog(
                            hintText: list[index],
                            onConfirm: (text) => provider.edit(index, text),
                          );
                        },
                      );
                    },
                    child: const Text('edit'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => provider.remove(index),
                    child: const Text('remove'),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: provider.undo,
            child: const Text('undo'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: provider.redo,
            child: const Text('redo'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: provider.reset,
            child: const Text('reset'),
          ),
        ],
      ),
    );
  }
}

class CustomDialog extends HookWidget {
  const CustomDialog({
    Key? key,
    required this.onConfirm,
    this.hintText = 'your text',
  }) : super(key: key);

  final String hintText;
  final void Function(String text) onConfirm;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: hintText),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    onConfirm(controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text('confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
