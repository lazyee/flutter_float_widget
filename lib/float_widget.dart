import 'package:flutter/material.dart';

class FloatWidget extends StatefulWidget {
  final Widget child;
  final Widget floatChild;
  final FloatWidgetPosition position;
  FloatWidget(
      {Key? key,
      this.position = FloatWidgetPosition.bottomRight,
      required this.child,
      required this.floatChild})
      : super(key: key);

  @override
  _FloatWidgetState createState() => _FloatWidgetState();
}

class _FloatWidgetState extends State<FloatWidget> {
  GlobalKey<_FloatViewState> _floatViewStateGlobalKey =
      GlobalKey<_FloatViewState>();
  GlobalKey _childKey = GlobalKey();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0), () {
      _floatViewStateGlobalKey.currentState
          ?.setMaxSize(_childKey.currentContext?.size ?? Size.zero);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(key: _childKey, child: widget.child),
        _FloatView(
          position: widget.position,
          key: _floatViewStateGlobalKey,
          child: widget.floatChild,
        )
      ],
    );
  }
}

class _FloatView extends StatefulWidget {
  final Widget child;
  final FloatWidgetPosition position;
  _FloatView({Key? key, required this.child, required this.position})
      : super(key: key);

  @override
  _FloatViewState createState() => _FloatViewState();
}

class _FloatViewState extends State<_FloatView> {
  GlobalKey _containerKey = GlobalKey();
  double left = 0;
  double top = 0;
  Duration duration = Duration(milliseconds: 0);

  double offsetX = 0;
  double offsetY = 0;

  Size maxSize = Size(0, 0);
  DragUpdateDetails? updateDetails;

  void setMaxSize(Size size) {
    maxSize = size;
    Size currentSize = getCurrentSize();

    switch (widget.position) {
      case FloatWidgetPosition.topLeft:
        left = 0;
        top = 0;
        break;
      case FloatWidgetPosition.topRight:
        left = maxSize.width - currentSize.width;
        top = 0;
        break;
      case FloatWidgetPosition.bottomLeft:
        left = 0;
        top = maxSize.height - currentSize.height;
        break;
      case FloatWidgetPosition.bottomRight:
        left = maxSize.width - currentSize.width;
        top = maxSize.height - currentSize.height;
        break;
    }
    setState(() {});
  }

  void _onPanDown(DragDownDetails details) {
    offsetX = details.localPosition.dx;
    offsetY = details.localPosition.dy;
  }

  void _updatePosition(DragUpdateDetails details) {
    Size currentSize = getCurrentSize();

    duration = Duration(milliseconds: 0);
    updateDetails = details;
    left += details.delta.dx;
    top += details.delta.dy;

    if (left < 0) {
      left = 0;
    } else if (left + currentSize.width > maxSize.width) {
      left = maxSize.width - currentSize.width;
    }

    if (top < 0) {
      top = 0;
    } else if (top + currentSize.height > maxSize.height) {
      top = maxSize.height - currentSize.height;
    }

    setState(() {});
  }

  void _onPanEnd() {
    Size currentSize = getCurrentSize();
    duration = Duration(milliseconds: 100);
    if (left + currentSize.width / 2 >= maxSize.width / 2) {
      left = maxSize.width - currentSize.width;
    } else {
      left = 0;
    }
    setState(() {});
  }

  Size getCurrentSize() {
    double width = _containerKey.currentContext?.size?.width ?? 0;
    double height = _containerKey.currentContext?.size?.height ?? 0;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: left,
      top: top,
      child: GestureDetector(
        onPanDown: _onPanDown,
        onPanUpdate: _updatePosition,
        onPanCancel: _onPanEnd,
        onPanEnd: (details) => _onPanEnd(),
        child: Container(
          key: _containerKey,
          child: widget.child,
        ),
      ),
      duration: duration,
    );
  }
}

enum FloatWidgetPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
