import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ScrollDirection { initial, up, down }

class HomeScrollController extends GetxController
    with GetTickerProviderStateMixin {

  final ScrollController scrollController = ScrollController();

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
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (!scrollController.hasListeners) {
      scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final current = scrollController.offset;

    isHeaderPinned.value = current >= pinThreshold;

    if (current <= 0) {
      scrollDirection.value = ScrollDirection.initial;
      if (!animationController.isDismissed) {
        animationController.reverse();
      }
    } else if (current > _lastOffset) {
      scrollDirection.value = ScrollDirection.down;
      if (!animationController.isCompleted) {
        animationController.forward();
      }
    } else if (current < _lastOffset) {
      scrollDirection.value = ScrollDirection.up;
      if (!animationController.isDismissed) {
        animationController.reverse();
      }
    }

    _lastOffset = current;
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);

    /// IMPORTANT:
    /// dispose mat karo if controller app lifetime me reuse ho raha hai
    /// scrollController.dispose();

    animationController.dispose();

    super.onClose();
  }
}