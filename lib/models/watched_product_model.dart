
class WatchedModel {
  String productId;
  String watchedId;
  String userId;
  String title;
  String titleEn;
  String description;
  String descriptionEn;
  double price;
  String imageUrl;

  WatchedModel(
      {this.userId,
        this.watchedId,
        this.description,
        this.descriptionEn,
        this.title,
        this.titleEn,
        this.price,
        this.imageUrl,
        this.productId});

  WatchedModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    title = json['title'];
    titleEn = json['titleEn'];
    descriptionEn = json['descriptionEn'];
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
      'titleEn': titleEn,
      'userId': userId,
      'price': price,
      'imageUrl': imageUrl,
      'descriptionEn': descriptionEn,
      'productId': productId,
      'description': description,
    };
  }
}