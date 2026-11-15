# dn_issues

A small DartNative app with the UI issues we hit while porting LevelSchool
from Flutter, so the DartNative team can see each one running. Open an issue
to see what Flutter does, what DartNative did, and the repro next to the
workaround.

```sh
dn pub get
dn run
```

Issue numbers match `dartnative_issues.txt`, the list sent with the port
(DartNative 1.5.0). Only the UI issues are in the app, so the numbers have
gaps. The rest are listed below.

## How the issues were checked

- Each repro was also run in real Flutter: `flutter_twin/` is the same code
  with Flutter imports. All of the issues below draw differently in Flutter.
- Every chip in the app is from DartNative 1.8.0 on the iPhone 17 Pro Max
  simulator (iOS 26.1), except #25, which is Android only and was seen on a
  Pixel 9 Pro emulator (Android 16).

| # | Issue | DartNative 1.8.0 |
|---|-------|------------------|
| 1 | A Row with Expanded collapses under Align or Center | Fixed |
| 2 | A Stack's in-flow child gets no size | Fixed |
| 3 | SafeArea > Padding in a Scaffold body is content height | Still there |
| 4 | Flexible(SingleChildScrollView) in a min Column collapses | Still there |
| 5 | Horizontal scroll padding is hidden at offset 0 | Still there |
| 6 | Horizontal list items don't fill the cross axis | Fixed |
| 7 | A fixed-size Container does not centre an Icon | Still there |
| 8 | IntrinsicHeight shrinks its child's width too | Fixed |
| 9 | Mixed corner radii collapse to one radius | Still there |
| 10 | AnimatedSwitcher adds no size of its own | Changed: no overlap now, but the child loses its height and width |
| 11 | ScrollController(initialScrollOffset:) is ignored | Still there |
| 12 | LayoutBuilder constraints include the parent's padding | Still there: both report the screen width (Flutter: 385 / 373, DartNative: 440 / 440) |
| 13 | Removing an OverlayEntry after its screen is gone asserts | Still there (same stack trace; no error in Flutter) |
| 18 | Icons are Material Symbols Rounded (outlined) | Still there |
| 21 | LayoutBuilder constraints larger than the space given | Still there (Flutter: 718 / 718, DartNative: 840 / 720) |
| 25 | Android: a box with two BoxShadows covers the Stack children after it | Still there (found on 1.8.0; one BoxShadow is fine, iOS is fine) |

## Not in the app

These are not UI issues, or they could not be confirmed here.

- **#14** CoreGraphics "NaN" warnings logged about 18 times at startup
  (source not isolated).
- **#15** Missing Flutter APIs: Material/Ink, TextFormField, several
  InputDecoration fields, TextField.onTapOutside, SafeArea.minimum,
  Row/Column `spacing:`, AnimationController.unbounded/animateWith,
  SpringSimulation, some Curves, ThemeData extensions,
  ColorScheme.fromSeed, Text.rich/WidgetSpan, BorderRadius.horizontal,
  ColorFilter, Color.alphaBlend, TransformationController, `dart:ui`
  from app code, Semantics(toggled:/liveRegion:).
- **#16** dartnative_svg rejects an `<svg>` without `xmlns` ("[DNSvg]
  configure: failed to load svg"). Not compared here because flutter_svg
  is not in the twin.
- **#17** dartnative_shared_preferences can't read keys saved by Flutter's
  shared_preferences (`flutter.` prefix, native string arrays).
- **#19** dartnative_compressor 1.0.1 fails to link on iOS (undefined
  CoreMedia `CMTime` symbols).
- **#20** Changing `Scaffold.resizeToAvoidBottomInset` while the keyboard
  is up leaves the next step's Expanded at 0 pt. Seen in LevelSchool; not
  re-checked here because it needs the software keyboard.
- **#22** No system text-to-speech plugin (only
  dartnative_supertonic_tts).
- **#23** No one-call camera capture like image_picker's
  `ImageSource.camera`.
- **#24** The "Flutter vs DartNative" guide still describes 1.0.
- **#26** (1.8.0) dartnative_home_widget and dartnative_live_activities
  ship iOS binaries built with the iOS 27.2 SDK. On Xcode 26.1 the app fails
  to link (`Undefined symbol … AppIntents.AppIntent.allowedExecutionTargets`).
  The plugin pages only give the iOS minimum.
- **#27** (1.8.0) An older Android project that keeps
  `GeneratedPluginRegistrant.java` under `src/main/java` can also get a stale
  copy in `build/app/dn_registrant/java`, and the build fails with
  "duplicate class". Deleting `build/app/dn_registrant` fixes it.
