import 'package:dartnative/dartnative.dart';

/// What the issue does on the DartNative this app was last checked on.
enum Status {
  fixed('FIXED IN 1.8.0', Color(0xFF16A34A), Color(0xFFDCFCE7)),
  still('STILL IN 1.8.0', Color(0xFFDC2626), Color(0xFFFEE2E2)),
  changed('CHANGED IN 1.8.0', Color(0xFFB45309), Color(0xFFFEF3C7));

  const Status(this.label, this.color, this.fill);

  final String label;
  final Color color;
  final Color fill;
}

/// One issue from dartnative_issues.txt.
class Issue {
  const Issue({
    required this.number,
    required this.title,
    required this.flutter,
    required this.dartnative,
    this.workaround,
    this.note,
    this.repro,
    this.fixed,
    this.reproScreen,
    this.fixedScreen,
    this.runLabel,
    this.run,
    this.status,
    this.statusNote,
  });

  final int number;
  final String title;

  /// What the same code does in Flutter.
  final String flutter;

  /// What DartNative did when the issue was written down.
  final String dartnative;
  final String? workaround;

  /// Anything else: changelog lines, where it was hit, the error text.
  final String? note;

  /// The failing widget tree, drawn inline in a frame.
  final WidgetBuilder? repro;

  /// The same tree with the workaround applied.
  final WidgetBuilder? fixed;

  /// For layout that needs a whole screen (Scaffold, SafeArea, keyboard).
  final WidgetBuilder? reproScreen;
  final WidgetBuilder? fixedScreen;

  /// A button that runs something (watch the `dn run` console).
  final String? runLabel;
  final void Function(BuildContext context)? run;

  /// Checked on DartNative 1.8.0 (iPhone 17 Pro Max simulator, iOS 26.1,
  /// unless [statusNote] says otherwise). Null: not checked.
  final Status? status;
  final String? statusNote;

  bool get isLive =>
      repro != null || reproScreen != null || run != null;
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});

  final Status status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: status.fill,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: status.color,
        ),
      ),
    );
  }
}

class IssueSection {
  const IssueSection(this.title, this.issues);

  final String title;
  final List<Issue> issues;
}

// ---- Shared look ------------------------------------------------------------

const ink = Color(0xFF111827);
const muted = Color(0xFF6B7280);
const line = Color(0xFFE5E7EB);
const page = Color(0xFFF7F7F8);
const red = Color(0xFFEF4444);
const green = Color(0xFF16A34A);
const blue = Color(0xFF3B82F6);
const amber = Color(0xFFF59E0B);

/// A coloured square used in the repros.
Widget box(Color color, {double size = 24}) =>
    Container(width: size, height: size, color: color);

/// A labelled, outlined area a repro is drawn in.
class Frame extends StatelessWidget {
  const Frame({
    required this.label,
    required this.color,
    required this.child,
    super.key,
  });

  final String label;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ],
    );
  }
}

/// The issue's page: what Flutter does, what DartNative did, then the
/// repro and the workaround side by side, live.
class IssueScreen extends StatelessWidget {
  const IssueScreen({required this.issue, super.key});

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    final i = issue;
    return Scaffold(
      brightness: Brightness.light,
      backgroundColor: page,
      appBar: AppBar(title: Text('#${i.number}')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          Text(
            i.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ),
          const SizedBox(height: 10),
          if (i.status != null)
            Row(children: [StatusChip(i.status!)]),
          if (i.statusNote != null) ...[
            const SizedBox(height: 4),
            Text(
              i.statusNote!,
              style: const TextStyle(fontSize: 12, color: muted),
            ),
          ],
          const SizedBox(height: 14),
          _Fact('Flutter', i.flutter),
          _Fact('DartNative (1.5.0, when found)', i.dartnative),
          if (i.workaround != null) _Fact('Workaround', i.workaround!),
          if (i.note != null) _Fact('Note', i.note!),
          if (i.repro != null) ...[
            const SizedBox(height: 8),
            Frame(label: 'REPRO', color: red, child: i.repro!(context)),
          ],
          if (i.fixed != null) ...[
            const SizedBox(height: 14),
            Frame(
              label: 'WORKAROUND',
              color: green,
              child: i.fixed!(context),
            ),
          ],
          if (i.reproScreen != null)
            _Button(
              'Open repro screen',
              red,
              () => Navigator.push(
                context,
                PageRoute(builder: i.reproScreen!),
              ),
            ),
          if (i.fixedScreen != null)
            _Button(
              'Open workaround screen',
              green,
              () => Navigator.push(
                context,
                PageRoute(builder: i.fixedScreen!),
              ),
            ),
          if (i.run != null)
            _Button(i.runLabel ?? 'Run', blue, () => i.run!(context)),
          if (i.fixed != null || i.fixedScreen != null) ...[
            const SizedBox(height: 16),
            const Text(
              'If the repro looks like the workaround, this DartNative '
              'version has fixed it.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
          ],
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.text);

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: muted,
            ),
          ),
          const SizedBox(height: 3),
          Text(text, style: const TextStyle(fontSize: 14, color: ink)),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button(this.label, this.color, this.onTap);

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
