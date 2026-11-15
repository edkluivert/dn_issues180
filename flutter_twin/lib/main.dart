import 'package:flutter/material.dart';

import 'demos.dart';
import 'helpers.dart';

void main() => runApp(const MaterialApp(home: Twin()));

/// The dn_issues repros, as-is, in real Flutter: what each should look like.
class Twin extends StatelessWidget {
  const Twin({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, WidgetBuilder)>[
      ('#1', alignRowRepro), ('#2', stackRepro), ('#4', flexibleScrollRepro),
      ('#5', hScrollPaddingRepro), ('#6', hListCrossRepro),
      ('#7', iconBoxRepro), ('#8', intrinsicRepro), ('#9', radiiRepro),
      ('#10', switcherRepro), ('#11', initialOffsetRepro),
      ('#12', layoutPaddingRepro), ('#18', iconsRepro), ('#25', shadowZRepro),
    ];
    return Scaffold(
      backgroundColor: page,
      appBar: AppBar(title: const Text('Flutter twin')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (label, b) in items) ...[
            Frame(label: 'FLUTTER $label', color: blue, child: b(context)),
            const SizedBox(height: 14),
          ],
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: safePaddingReproScreen)),
            child: const Text('#3 repro screen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LayoutHeightScreen())),
            child: const Text('#21 screen'),
          ),
          ElevatedButton(
            onPressed: () => overlayAfterPopRun(context),
            child: const Text('#13 run'),
          ),
        ],
      ),
    );
  }
}
