class CommentModel {
  String productId;
  String commentId;
  String userId;
  String username;
  String text;
  double rate;
  String rateDescription;
  String rateDescriptionEn;
  String imageUrl;
  String dateTime;

  CommentModel(
      {this.userId,
        this.username,
        this.commentId,
        this.rateDescription,
        this.rateDescriptionEn,
        this.imageUrl,
        this.dateTime,
        this.rate,
        this.text,
        this.productId});

  CommentModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    dateTime = json['dateTime'];
    commentId = json['commentId'];
    rate = json['rate'];
    username = json['username'];
    productId = json['productId'];
    rateDescription = json['rateDescription'];
    rateDescriptionEn = json['rateDescriptionEn'];
    imageUrl = json['imageUrl'];
    text = json['text'];
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'commentId': commentId,
      'dateTime': dateTime,
      'rate': rate,
      'rateDescription': rateDescription,
      'rateDescriptionEn': rateDescriptionEn,
      'username': username,
      'imageUrl': imageUrl,
      'text': text,
      'productId': productId,
    };
  }
}
