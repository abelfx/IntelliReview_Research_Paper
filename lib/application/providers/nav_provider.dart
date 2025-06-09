// lib/application/providers/nav_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the currently selected nav bar index
final navIndexProvider = StateProvider<int>((_) => 0);
