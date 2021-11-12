
class WatchedModel {
  String productId;
  String watchedId;
  String userId;
  String title;
  String description;
  double price;
  String imageUrl;

  WatchedModel(
      {this.userId,
        this.watchedId,
        this.description,
        this.title,
        this.price,
        this.imageUrl,
        this.productId});

  WatchedModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    title = json['title'];
    productId = json['productId'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    watchedId = json['watchedId'];
    description = json['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'watchedId': watchedId,
      'title': title,
      'userId': userId,
      'price': price,
      'imageUrl': imageUrl,
      'productId': productId,
      'description': description,
    };
  }
}