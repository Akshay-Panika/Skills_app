// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// enum ScrollDirection { initial, up, down }
//
// class HomeScrollController extends GetxController with GetTickerProviderStateMixin {
//   final scrollController = ScrollController();
//   final scrollDirection = ScrollDirection.initial.obs;
//
//   // Animation ke liye
//   late AnimationController animationController;
//   late Animation<Offset> slideAnimation;
//
//   double _lastOffset = 0;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//
//     slideAnimation = Tween<Offset>(
//       begin: Offset.zero,        // visible
//       end: const Offset(0, 1.5), // neeche chhup jayega
//     ).animate(CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     scrollController.addListener(_onScroll);
//   }
//
//   void _onScroll() {
//     final current = scrollController.offset;
//
//     if (current <= 0) {
//       scrollDirection.value = ScrollDirection.initial;
//       animationController.reverse(); // show
//     } else if (current > _lastOffset) {
//       scrollDirection.value = ScrollDirection.down;
//       animationController.forward(); // hide
//     } else if (current < _lastOffset) {
//       scrollDirection.value = ScrollDirection.up;
//       animationController.reverse(); // show
//     }
//
//     _lastOffset = current;
//   }
//
//   @override
//   void onClose() {
//     animationController.dispose();
//     scrollController.removeListener(_onScroll);
//     scrollController.dispose();
//     super.onClose();
//   }
// }
//
// class HomeFilterController extends GetxController {
//   final isExpanded = false.obs;
//
//   void toggle() {
//     isExpanded.value = !isExpanded.value;
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ScrollDirection { initial, up, down }

class HomeScrollController extends GetxController with GetTickerProviderStateMixin {
  final scrollController = ScrollController();
  final scrollDirection = ScrollDirection.initial.obs;
  final isHeaderPinned = false.obs;

  static const double pinThreshold = 426;

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  double _lastOffset = 0;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1.5),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final current = scrollController.offset;

    // Header pin logic NEW
    isHeaderPinned.value = current >= pinThreshold;

    // Existing scroll direction logic
    if (current <= 0) {
      scrollDirection.value = ScrollDirection.initial;
      animationController.reverse();
    } else if (current > _lastOffset) {
      scrollDirection.value = ScrollDirection.down;
      animationController.forward();
    } else if (current < _lastOffset) {
      scrollDirection.value = ScrollDirection.up;
      animationController.reverse();
    }

    _lastOffset = current;
  }

  @override
  void onClose() {
    animationController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}

