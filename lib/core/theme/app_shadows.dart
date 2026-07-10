import 'package:flutter/material.dart';

/// Soft elevation system for the Visit Libya visual identity.
///
/// Heavy shadows and neon glows are intentionally excluded.
abstract final class AppShadows {
  static const List<BoxShadow> level1 = <BoxShadow>[
    BoxShadow(color: Color(0x0F0B1F33), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> level2 = <BoxShadow>[
    BoxShadow(color: Color(0x1A0B1F33), blurRadius: 16, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> level3 = <BoxShadow>[
    BoxShadow(color: Color(0x240B1F33), blurRadius: 24, offset: Offset(0, 10)),
  ];
}
