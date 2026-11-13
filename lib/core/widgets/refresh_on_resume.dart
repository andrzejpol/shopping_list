import 'package:flutter/widgets.dart';

class RefreshOnResume extends StatefulWidget {
  final VoidCallback onResume;
  final Duration minBackgroundTime;
  final Widget child;

  const RefreshOnResume({
    super.key,
    required this.onResume,
    this.minBackgroundTime = const Duration(seconds: 30),
    required this.child,
  });

  @override
  State<RefreshOnResume> createState() => _RefreshOnResumeState();
}

class _RefreshOnResumeState extends State<RefreshOnResume> {
  late final AppLifecycleListener _listener;
  DateTime? _hiddenAt;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onHide: () => _hiddenAt = DateTime.now(),
      onShow: _handleShow,
    );
  }

  void _handleShow() {
    final hiddenAt = _hiddenAt;
    _hiddenAt = null;
    if (hiddenAt == null) return;

    final timeInBackground = DateTime.now().difference(hiddenAt);
    if (timeInBackground >= widget.minBackgroundTime) {
      widget.onResume();
    }
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
