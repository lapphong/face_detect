import 'package:flutter/material.dart';

extension Ctx on BuildContext {
  Size get sizeDevice => MediaQuery.of(this).size;

  double get width => sizeDevice.width - horizontal * 2.5;

  Size get frameSize => Size(sizeDevice.width, sizeDevice.height - kToolbarHeight - padding);

  double get horizontal => sizeDevice.width > 375 ? 24 : 12;

  double get padding => MediaQuery.of(this).padding.top;

  // Returns the rectangle that represents the overlay area for QR code scanning.
  Rect get overlayRect => Rect.fromCenter(
    center: Offset(sizeDevice.width / 2, sizeDevice.height / 2 - kToolbarHeight),
    width: width,
    height: width,
  );
}
