import 'package:dartnative/dartnative.dart';

import 'demos.dart';
import 'issue.dart';

/// The UI issues from dartnative_issues.txt (found on DartNative 1.5.0
/// while porting LevelSchool), plus #25 from 1.8.0. Each one was run in
/// Flutter 3.44.5 (flutter_twin/) to confirm Flutter draws it differently.
/// The issues that are not UI (APIs, plugins, docs, build) are listed in
/// the README; numbers match dartnative_issues.txt, so there are gaps.
final sections = <IssueSection>[
  IssueSection('Layout', [
    Issue(
      number: 1,
      status: Status.fixed,
      title: 'A Row with Expanded collapses under Align or Center',
      flutter: 'Align passes loose constraints; the Row (mainAxisSize.max) '
          'takes the full width and the Expanded fills it.',
      dartnative: 'The Row hugs its content and the Expanded child gets 0 '
          'width, so its text disappears. Hit in the app toast.',
      workaround: 'SizedBox(width: double.infinity) between the Align and '
          'the Row.',
      note: '1.6.0 changelog: "A Row … take the whole width under a Center '
          'or in a Stack". Column, Stack, Container(alignment:) and '
          'Positioned(left: 0, right: 0) above a Row always worked.',
      repro: alignRowRepro,
      fixed: alignRowFixed,
    ),
    const Issue(
      number: 2,
      status: Status.fixed,
      title: "A Stack's in-flow child gets no size",
      flutter: 'In SizedBox(height: 46) > Stack > Column(Expanded), the '
          'Column gets 46 pt and the Expanded fills.',
      dartnative: 'The Column renders 0 high. A Scaffold body '
          'Stack[SingleChildScrollView, Positioned] went blank; an '
          'OverlayEntry rooted in a Stack of Positioned rendered 0×0.',
      workaround: 'Wrap the in-flow child in Positioned.fill.',
      repro: stackRepro,
      fixed: stackFixed,
    ),
    const Issue(
      number: 3,
      status: Status.still,
      title: 'SafeArea > Padding in a Scaffold body is content height',
      flutter: 'The Padding/Column fills the screen; Expanded takes the '
          'rest.',
      dartnative: 'The Padding/Column measured 111 pt (its content); the '
          'Expanded got 0. SafeArea > Column without Padding works.',
      workaround: 'Container(height: double.infinity, padding: …) instead '
          'of Padding.',
      reproScreen: safePaddingReproScreen,
      fixedScreen: safePaddingFixedScreen,
    ),
    const Issue(
      number: 4,
      status: Status.still,
      title: 'Flexible(SingleChildScrollView) in a min Column collapses',
      flutter: 'The scroll view takes its content height, up to the space '
          'left. The standard bottom sheet layout.',
      dartnative: 'The scroll view gets 0 pt; the body and the footer '
          'after it vanish.',
      workaround: 'Flexible(child: ListView(shrinkWrap: true, children: '
          '[body])).',
      repro: flexibleScrollRepro,
      fixed: flexibleScrollFixed,
    ),
    const Issue(
      number: 5,
      status: Status.still,
      title: 'Horizontal scroll padding is hidden at offset 0',
      flutter: 'With padding left 20, the first item starts 20 pt in.',
      dartnative: 'The first item starts at x = 0; the padding seems to '
          'become a native content inset scrolled out of view. Same with '
          'SingleChildScrollView(padding:).',
      workaround: "Put a Padding inside the scroll view's child.",
      repro: hScrollPaddingRepro,
      fixed: hScrollPaddingFixed,
    ),
    const Issue(
      number: 6,
      status: Status.fixed,
      title: "Horizontal list items don't fill the cross axis",
      flutter: 'Items of a horizontal ListView are as tall as the list.',
      dartnative: 'Tiles had uneven heights (seen with a Row in a '
          'horizontal SingleChildScrollView).',
      workaround: 'Row(crossAxisAlignment: CrossAxisAlignment.stretch).',
      note: '1.6.0 changelog: "In a Row with CrossAxisAlignment.stretch … '
          'The same holds in a horizontal ListView."',
      repro: hListCrossRepro,
      fixed: hListCrossFixed,
    ),
    const Issue(
      number: 7,
      status: Status.still,
      title: 'A fixed-size Container does not centre an Icon',
      flutter: 'The child gets tight constraints, so the glyph is centred.',
      dartnative: 'The icon sits at the top, off-centre. Hit in 23 places, '
          'including the bottom navigation bar.',
      workaround: 'alignment: Alignment.center on the Container.',
      repro: iconBoxRepro,
      fixed: iconBoxFixed,
    ),
    const Issue(
      number: 8,
      status: Status.fixed,
      title: "IntrinsicHeight shrinks its child's width too",
      flutter: 'The Row is full width and as tall as its tallest child.',
      dartnative: 'The Row hugs its content; the Expanded tiles are a few '
          'points wide.',
      workaround: 'SizedBox(width: double.infinity, child: '
          'IntrinsicHeight(…)).',
      note: '1.6.0 changelog: "A Row inside an IntrinsicHeight, in a Column '
          'that centres its children, takes the whole width".',
      repro: intrinsicRepro,
      fixed: intrinsicFixed,
    ),
    const Issue(
      number: 9,
      status: Status.still,
      title: 'Mixed corner radii collapse to one radius',
      flutter: 'BorderRadius.vertical(top: 40, bottom: 6) gives 40 pt top '
          'corners and 6 pt bottom corners.',
      dartnative: 'All four corners use the top radius (layer.cornerRadius '
          '+ maskedCorners). DecoratedBox documents the same.',
      workaround: 'Two nested ClipRRects, one per radius.',
      repro: radiiRepro,
      fixed: radiiFixed,
    ),
    const Issue(
      number: 10,
      status: Status.changed,
      statusNote: 'The text below no longer overlaps, but the child loses its 40 pt height and full width: it is only as big as its text.',
      title: 'AnimatedSwitcher adds no size of its own (documented)',
      flutter: 'The switcher is as big as its child; "Below" sits under '
          'the blue bar.',
      dartnative: 'Its children are positioned absolutely, so in a Column '
          'it collapses and the text below overlaps.',
      workaround: 'A hand-written switcher: a Stack whose incoming child '
          'stays in flow.',
      repro: switcherRepro,
    ),
  ]),
  IssueSection('Widgets and APIs', [
    const Issue(
      number: 11,
      status: Status.still,
      title: 'ScrollController(initialScrollOffset:) is ignored',
      flutter: 'The list opens at offset 400 (row 10).',
      dartnative: 'The list opens at offset 0.',
      workaround: 'jumpTo after the first frame.',
      repro: initialOffsetRepro,
      fixed: initialOffsetFixed,
    ),
    const Issue(
      number: 12,
      status: Status.still,
      statusNote: 'Worse than first reported: both LayoutBuilders report the full screen width (440 on this phone), though the frame is narrower.',
      title: "LayoutBuilder constraints include the parent's padding",
      flutter: 'Inside Container(padding: horizontal 6), maxWidth is the '
          'width minus 12.',
      dartnative: "maxWidth was the Container's full width.",
      note: 'Compare the inner and expected numbers below.',
      repro: layoutPaddingRepro,
    ),
    Issue(
      number: 13,
      status: Status.still,
      statusNote: 'Same assert and stack trace on 1.8.0.',
      title: 'Removing an OverlayEntry after its screen is gone asserts',
      flutter: 'entry.remove() works whenever it is called.',
      dartnative: "Debug builds assert: 'setState() called after "
          "dispose()' in _RootOverlayLayerState._changed "
          '(overlay.dart:306) via OverlayEntry.remove.',
      note: 'Tap Run: a screen inserts a toast with rootOverlay: true, '
          'pops itself, and the toast removes itself 2 s later. Watch the '
          '`dn run` console.',
      runLabel: 'Run (watch the console)',
      run: overlayAfterPopRun,
    ),
    const Issue(
      number: 18,
      status: Status.still,
      title: 'Icons are Material Symbols Rounded (outlined)',
      flutter: 'Icons.home_rounded and friends are the filled Material '
          'Icons glyphs.',
      dartnative: 'They render as outlined Material Symbols, so every icon '
          'in a ported app changes.',
      workaround: "Ship Flutter's MaterialIcons-Regular.otf with the "
          'original code points (LevelSchool: '
          'lib/core/constants/app_icons.dart).',
      repro: iconsRepro,
    ),
    const Issue(
      number: 21,
      status: Status.still,
      statusNote: 'maxHeight 840 against a laid-out height of 720: the 120 pt header is not subtracted.',
      title: 'LayoutBuilder constraints larger than the space given',
      flutter: 'Inside Column > Expanded > LayoutBuilder, maxHeight equals '
          'the Expanded height.',
      dartnative: 'maxHeight was larger than the area the Expanded got (a '
          'centred mind map ended up ~70 pt low).',
      workaround: 'Read the size from findRenderObject() after layout.',
      reproScreen: _layoutHeight,
    ),
  ]),
  IssueSection('Found on 1.8.0 (Android)', [
    const Issue(
      number: 25,
      foundIn: '1.8.0',
      status: Status.still,
      statusNote: 'Seen on the Pixel 9 Pro emulator (Android 16).',
      title: 'Android: a box with two BoxShadows covers the Stack children '
          'after it',
      flutter: 'Stack children paint in order: the camera badge is on top '
          'of the avatar, whatever its shadow.',
      dartnative: 'On Android, when the avatar\'s decoration has two or '
          'more BoxShadows, the avatar covers the badge placed after it in '
          'the Stack. With one BoxShadow (even with a spreadRadius) the '
          'badge stays on top.',
      workaround: 'Give the badge BoxShadow(color: Color(0x01000000), '
          'blurRadius: 32), larger than the avatar\'s. A shadow with alpha 0 '
          'does not work.',
      note: 'Found in LevelSchool: its card shadow (--sh2) has two layers, '
          'and the profile photo hid its camera badge. Look at this one on '
          'Android.',
      repro: shadowZRepro,
      fixed: shadowZFixed,
    ),
  ]),
];

Widget _layoutHeight(BuildContext _) => const LayoutHeightScreen();
