
class Product {
  String id;
  String title;
  String titleEn;
  String description;
  String descriptionEn;
  double price;
  String imageUrl;
  String productCategoryName;
  String productCategoryNameEn;
  bool isPopular;
  int quantity;

  Product(
      {this.id,
        this.title,
        this.titleEn,
        this.descriptionEn,
        this.productCategoryNameEn,
        this.description,
        this.price,
        this.imageUrl,
        this.productCategoryName,
        this.isPopular,
        this.quantity,
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    titleEn = json['titleEn'];
    description = json['description'];
    descriptionEn = json['descriptionEn'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    productCategoryName = json['productCategoryName'];
    productCategoryNameEn = json['productCategoryNameEn'];
    isPopular = json['isPopular'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'titleEn': titleEn,
      'description': description,
      'descriptionEn': descriptionEn,
      'productCategoryNameEn': productCategoryNameEn,
      'price': price,
      'imageUrl': imageUrl,
      'productCategoryName': productCategoryName,
      'isPopular': isPopular,
      'quantity': quantity,
    };
  }
}