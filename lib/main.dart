import 'package:dartnative/dartnative.dart';

import 'dartnative_plugin_registrant.dart';
import 'issue.dart';
import 'issues.dart';

void main() {
  // Platform bindings + plugin FFI symbols. Always the first line of main().
  DartNativePluginRegistrant.registerAll();
  SystemChrome.defaultStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  runApp(const IssuesHome());
}

/// Every issue, grouped as in dartnative_issues.txt. LIVE marks the ones
/// with a repro you can look at; the rest are notes.
class IssuesHome extends StatelessWidget {
  const IssuesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      brightness: Brightness.light,
      backgroundColor: page,
      appBar: AppBar(title: const Text('DartNative issues')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          const Text(
            'UI issues found while porting LevelSchool from Flutter '
            '(DartNative 1.5.0), plus one on 1.8.0. Each page shows what '
            'Flutter does, what DartNative did, and the repro next to the '
            'workaround. Every repro was run in Flutter 3.44.5 '
            '(flutter_twin/ in this repo) to confirm the difference. The '
            'chips say what each does on DartNative 1.8.0.',
            style: TextStyle(fontSize: 13, color: muted),
          ),
          for (final section in sections) ...[
            const SizedBox(height: 22),
            Text(
              section.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: muted,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < section.issues.length; i++) ...[
                    if (i > 0) Container(height: 1, color: line),
                    _IssueRow(issue: section.issues[i]),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IssueRow extends StatelessWidget {
  const _IssueRow({required this.issue});

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRoute(builder: (_) => IssueScreen(issue: issue)),
      ),
      child: Container(
        color: const Color(0x00000000),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '${issue.number}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: muted,
                ),
              ),
            ),
            Expanded(
              child: Text(
                issue.title,
                style: const TextStyle(fontSize: 15, color: ink),
              ),
            ),
            if (issue.status != null) ...[
              const SizedBox(width: 8),
              StatusChip(issue.status!),
            ] else if (issue.isLive)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: blue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
