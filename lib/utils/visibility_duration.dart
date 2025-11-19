import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter/material.dart';

class VisibilityDuration extends StatefulWidget {
  final Widget child;
  final String keyId;
  final Map<String, dynamic>? data;
  final Function(
    String keyId,
    Duration duration,
    Map<String, dynamic>? data,
  )? onVisibleForDuration;

  const VisibilityDuration({
    Key? key,
    required this.child,
    required this.keyId,
    this.onVisibleForDuration,
    this.data,
  }) : super(key: key);

  @override
  _VisibilityDurationState createState() => _VisibilityDurationState();
}

class _VisibilityDurationState extends State<VisibilityDuration> {
  DateTime? _visibleStartTime;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.keyId),
      onVisibilityChanged: (info) {
        final isCurrentlyVisible =
            info.visibleFraction > 0.5; // 可见比例 > 50% 认为可见
        if (isCurrentlyVisible && !_isVisible) {
          // 刚变为可见
          _visibleStartTime = DateTime.now();
          _isVisible = true;
        } else if (!isCurrentlyVisible && _isVisible) {
          // 刚变为不可见
          _isVisible = false;
          if (_visibleStartTime != null) {
            final duration = DateTime.now().difference(_visibleStartTime!);
            if (duration.inSeconds >= 2) {
              // 停留时间 ≥ 2 秒
              widget.onVisibleForDuration
                  ?.call(widget.keyId, duration, widget.data);
            }
          }
          _visibleStartTime = null;
        }
      },
      child: widget.child,
    );
  }
}

// return VisibilityDuration(
// keyId: widget.skuId,
// data: widget.browseQoList?.toJson(),
// child: itemWidget,
// onVisibleForDuration: (keyId, duration,backData) =>
// VisibilityManage.onVisibleForDuration(
// keyId,
// duration,
// data: backData
// ),
// );