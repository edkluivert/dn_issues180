// Generated from ../lib/demos.dart: the same trees, in Flutter.
import 'dart:async';

import 'package:flutter/material.dart';

import 'helpers.dart';

// Each repro is the minimal tree from the issue; each fix is the same tree
// with the workaround. Keep them small so the team can read them here.

// #1 Row with Expanded under Align / Center --------------------------------

Widget _row() => Row(
  children: [
    box(red),
    const SizedBox(width: 8),
    const Expanded(child: Text('This Expanded text should fill the row')),
    const SizedBox(width: 8),
    box(blue),
  ],
);

Widget alignRowRepro(BuildContext _) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const Text('Align > Row', style: TextStyle(fontSize: 11, color: muted)),
    Align(alignment: Alignment.topCenter, child: _row()),
    const SizedBox(height: 10),
    const Text('Center > Row', style: TextStyle(fontSize: 11, color: muted)),
    Center(child: _row()),
  ],
);

Widget alignRowFixed(BuildContext _) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const Text(
      'Align > SizedBox(width: infinity) > Row',
      style: TextStyle(fontSize: 11, color: muted),
    ),
    Align(
      alignment: Alignment.topCenter,
      child: SizedBox(width: double.infinity, child: _row()),
    ),
  ],
);

// #2 Stack in-flow child gets no size ---------------------------------------

Widget _stackColumn() => Column(
  children: [
    Container(height: 10, color: red),
    Expanded(child: Container(color: blue)),
  ],
);

Widget stackRepro(BuildContext _) =>
    SizedBox(height: 46, child: Stack(children: [_stackColumn()]));

Widget stackFixed(BuildContext _) => SizedBox(
  height: 46,
  child: Stack(children: [Positioned.fill(child: _stackColumn())]),
);

// #3 SafeArea > Padding in a Scaffold body ----------------------------------

Widget _fillColumn() => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const Text(
      'Header. The blue area below is an Expanded and should fill the '
      'rest of the screen.',
    ),
    const SizedBox(height: 12),
    Expanded(child: Container(color: blue)),
  ],
);

Widget safePaddingReproScreen(BuildContext _) => Scaffold(
  backgroundColor: page,
  appBar: AppBar(title: const Text('#3 repro')),
  body: SafeArea(
    child: Padding(padding: const EdgeInsets.all(16), child: _fillColumn()),
  ),
);

Widget safePaddingFixedScreen(BuildContext _) => Scaffold(
  backgroundColor: page,
  appBar: AppBar(title: const Text('#3 workaround')),
  body: SafeArea(
    child: Container(
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      child: _fillColumn(),
    ),
  ),
);

// #4 Flexible(SingleChildScrollView) in a min Column ------------------------

const _body =
    'Body text inside the scroll view. In Flutter this shows, and so does '
    'the footer under it. This is the standard bottom sheet layout.';

Widget _sheet(Widget scroll) => Container(
  height: 200,
  alignment: Alignment.topCenter,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text('Title', style: TextStyle(fontWeight: FontWeight.w700)),
      Flexible(child: scroll),
      Container(height: 30, color: green, alignment: Alignment.center,
        child: const Text('Footer', style: TextStyle(color: Color(0xFFFFFFFF))),
      ),
    ],
  ),
);

Widget flexibleScrollRepro(BuildContext _) =>
    _sheet(const SingleChildScrollView(child: Text(_body)));

Widget flexibleScrollFixed(BuildContext _) => _sheet(
  ListView(shrinkWrap: true, children: const [Text(_body)]),
);

// #5 Horizontal scroll padding hidden at offset 0 ---------------------------

Widget _tile(int i) => Container(
  width: 70,
  height: 51,
  color: i.isEven ? blue : amber,
  alignment: Alignment.center,
  child: Text('$i', style: const TextStyle(color: Color(0xFFFFFFFF))),
);

Widget hScrollPaddingRepro(BuildContext _) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const Text(
      'padding: 20 left. Tile 0 should start 20 pt in.',
      style: TextStyle(fontSize: 11, color: muted),
    ),
    const SizedBox(height: 6),
    SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 3, 20, 6),
        itemCount: 8,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => _tile(i),
      ),
    ),
  ],
);

Widget hScrollPaddingFixed(BuildContext _) => SizedBox(
  height: 60,
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 3, 20, 6),
      child: Row(
        children: [
          for (var i = 0; i < 8; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _tile(i),
          ],
        ],
      ),
    ),
  ),
);

// #6 Horizontal list items and the cross axis -------------------------------

Widget _card(String text) => Container(
  width: 110,
  padding: const EdgeInsets.all(8),
  color: amber,
  child: Text(text),
);

Widget hListCrossRepro(BuildContext _) => SizedBox(
  height: 90,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
      _card('Short'),
      const SizedBox(width: 8),
      _card('A longer card that wraps onto more lines'),
      const SizedBox(width: 8),
      _card('Mid length'),
    ],
  ),
);

Widget hListCrossFixed(BuildContext _) => SizedBox(
  height: 90,
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card('Short'),
        const SizedBox(width: 8),
        _card('A longer card that wraps onto more lines'),
        const SizedBox(width: 8),
        _card('Mid length'),
      ],
    ),
  ),
);

// #7 Fixed-size Container does not centre an Icon ---------------------------

Widget iconBoxRepro(BuildContext _) => Row(
  children: [
    Container(
      width: 32,
      height: 32,
      color: blue,
      child: const Icon(Icons.star, size: 16, color: Color(0xFFFFFFFF)),
    ),
    const SizedBox(width: 12),
    const Text('The star should be centred'),
  ],
);

Widget iconBoxFixed(BuildContext _) => Row(
  children: [
    Container(
      width: 32,
      height: 32,
      color: blue,
      alignment: Alignment.center,
      child: const Icon(Icons.star, size: 16, color: Color(0xFFFFFFFF)),
    ),
    const SizedBox(width: 12),
    const Text('alignment: Alignment.center'),
  ],
);

// #8 IntrinsicHeight shrinks width -----------------------------------------

Widget _intrinsicRow() => IntrinsicHeight(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: Container(
          color: blue,
          padding: const EdgeInsets.all(6),
          child: const Text('Tile A, two\nlines'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Container(
          color: amber,
          padding: const EdgeInsets.all(6),
          child: const Text('Tile B'),
        ),
      ),
    ],
  ),
);

Widget intrinsicRepro(BuildContext _) => Column(children: [_intrinsicRow()]);

Widget intrinsicFixed(BuildContext _) => Column(
  children: [SizedBox(width: double.infinity, child: _intrinsicRow())],
);

// #9 Mixed corner radii -----------------------------------------------------

Widget radiiRepro(BuildContext _) => ClipRRect(
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(40),
    bottom: Radius.circular(6),
  ),
  child: Container(height: 100, color: blue),
);

Widget radiiFixed(BuildContext _) => ClipRRect(
  borderRadius: BorderRadius.circular(6),
  child: ClipRRect(
    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
    child: Container(height: 100, color: blue),
  ),
);

// #10 AnimatedSwitcher adds no size ----------------------------------------

Widget switcherRepro(BuildContext _) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const Text('Above'),
    AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: const ValueKey(1),
        height: 40,
        color: blue,
        alignment: Alignment.center,
        child: const Text(
          'Switcher child (40 pt)',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
      ),
    ),
    const Text('Below: should sit under the blue bar'),
  ],
);

// #11 initialScrollOffset ignored --------------------------------------------

Widget initialOffsetRepro(BuildContext _) => SizedBox(
  height: 150,
  child: ListView.builder(
    controller: ScrollController(initialScrollOffset: 400),
    itemCount: 40,
    itemBuilder: (_, i) => Container(
      height: 40,
      alignment: Alignment.centerLeft,
      child: Text('Row $i  (should open at row 10)'),
    ),
  ),
);

class _JumpAfterLayout extends StatefulWidget {
  const _JumpAfterLayout();

  @override
  State<_JumpAfterLayout> createState() => _JumpAfterLayoutState();
}

class _JumpAfterLayoutState extends State<_JumpAfterLayout> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) _controller.jumpTo(400);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 150,
    child: ListView.builder(
      controller: _controller,
      itemCount: 40,
      itemBuilder: (_, i) => Container(
        height: 40,
        alignment: Alignment.centerLeft,
        child: Text('Row $i  (jumpTo after the first frame)'),
      ),
    ),
  );
}

Widget initialOffsetFixed(BuildContext _) => const _JumpAfterLayout();

// #12 LayoutBuilder includes the parent's padding ---------------------------

Widget layoutPaddingRepro(BuildContext _) => LayoutBuilder(
  builder: (_, outer) => Container(
    color: const Color(0xFFDBEAFE),
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: LayoutBuilder(
      builder: (_, inner) => Text(
        'outer maxWidth ${outer.maxWidth.toStringAsFixed(1)}\n'
        'inner maxWidth ${inner.maxWidth.toStringAsFixed(1)}\n'
        'expected inner: ${(outer.maxWidth - 12).toStringAsFixed(1)} '
        '(outer minus 2 × 6 padding)',
      ),
    ),
  ),
);

// #13 OverlayEntry removed after its screen is gone -------------------------

void overlayAfterPopRun(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const _OverlayThenPop()),
  );
}

class _OverlayThenPop extends StatefulWidget {
  const _OverlayThenPop();

  @override
  State<_OverlayThenPop> createState() => _OverlayThenPopState();
}

class _OverlayThenPopState extends State<_OverlayThenPop> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final entry = OverlayEntry(
        builder: (_) => Positioned(
          left: 24,
          right: 24,
          bottom: 60,
          child: Container(
            padding: const EdgeInsets.all(14),
            color: ink,
            child: const Text(
              'Toast: removes itself in 2 s, after its screen is gone',
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
          ),
        ),
      );
      Overlay.of(context, rootOverlay: true).insert(entry);
      // Like a toast that hides itself on a timer.
      Timer(const Duration(seconds: 2), entry.remove);
      Timer(const Duration(milliseconds: 600), () {
        if (mounted) Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: page,
    appBar: AppBar(title: const Text('#13: going back…')),
    body: const Center(child: Text('This screen pops itself.')),
  );
}

// #18 Icons are Material Symbols outlined -----------------------------------

Widget iconsRepro(BuildContext _) => const Row(
  children: [
    Icon(Icons.home_rounded, size: 32, color: ink),
    SizedBox(width: 12),
    Icon(Icons.star_rounded, size: 32, color: ink),
    SizedBox(width: 12),
    Icon(Icons.favorite_rounded, size: 32, color: ink),
    SizedBox(width: 12),
    Expanded(child: Text('Flutter draws these filled')),
  ],
);

// #21 LayoutBuilder larger than the space given -----------------------------

class LayoutHeightScreen extends StatefulWidget {
  const LayoutHeightScreen({super.key});

  @override
  State<LayoutHeightScreen> createState() => _LayoutHeightScreenState();
}

class _LayoutHeightScreenState extends State<LayoutHeightScreen> {
  final _key = GlobalKey();
  double? _actual;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _key.currentContext?.findRenderObject();
      final size = box is RenderBox ? box.size : null;
      if (size != null && mounted) setState(() => _actual = size.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: page,
      appBar: AppBar(title: const Text('#21')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 120,
            color: amber,
            alignment: Alignment.center,
            child: const Text('Header, 120 pt'),
          ),
          Expanded(
            child: LayoutBuilder(
              key: _key,
              builder: (_, box) => Container(
                color: const Color(0xFFDBEAFE),
                alignment: Alignment.center,
                child: Text(
                  'LayoutBuilder maxHeight: ${box.maxHeight.toStringAsFixed(1)}\n'
                  'Laid-out height: ${_actual?.toStringAsFixed(1) ?? '…'}\n'
                  'They should be equal.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// #25 Android: BoxShadow is elevation, so a shadowed sibling covers --------

Widget _avatar() => DecoratedBox(
  decoration: const BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(color: Color(0x4D000000), blurRadius: 30, offset: Offset(0, 8)),
    ],
  ),
  child: Container(
    width: 80,
    height: 80,
    alignment: Alignment.center,
    decoration: const BoxDecoration(color: blue, shape: BoxShape.circle),
    child: const Text(
      'ME',
      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 24),
    ),
  ),
);

Widget _badge({required List<BoxShadow>? shadow}) => Positioned(
  right: 0,
  bottom: 0,
  child: Container(
    width: 30,
    height: 30,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: ink,
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFFFFFFFF), width: 2.5),
      boxShadow: shadow,
    ),
    child: const Icon(Icons.photo_camera, size: 14, color: Color(0xFFFFFFFF)),
  ),
);

Widget shadowZRepro(BuildContext _) => Center(
  child: Stack(children: [_avatar(), _badge(shadow: null)]),
);

Widget shadowZFixed(BuildContext _) => Center(
  child: Stack(
    children: [
      _avatar(),
      _badge(
        shadow: const [BoxShadow(color: Color(0x01000000), blurRadius: 32)],
      ),
    ],
  ),
);
