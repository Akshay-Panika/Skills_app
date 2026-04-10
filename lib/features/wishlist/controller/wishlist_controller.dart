import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/wishlist_model.dart';
import '../repository/wishlist_repository.dart';

class WishlistController extends GetxController {
  var isLoading = true.obs;
  var services = <WishlistModel>[].obs;
  var count = 0.obs;

  final WishlistRepository repository;

  WishlistController([WishlistRepository? repo])
      : repository = repo ?? WishlistRepository();

  @override
  void onInit() {
    fetchWishlist();
    super.onInit();
  }

  Future<void> fetchWishlist() async {
    try {
      isLoading.value = true;
      final response = await repository.getWishlist();
      services.value = response.services;
      count.value = response.count;
    } catch (e) {
      debugPrint('Wishlist Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }}