class WishlistToggleModel {
  final int user;
  final int service;

  WishlistToggleModel({
    required this.user,
    required this.service,
  });

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "service": service,
    };
  }
}