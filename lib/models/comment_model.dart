class CommentModel {
  String productId;
  String commentId;
  String userId;
  String username;
  String text;
  String imageUrl;
  String dateTime;

  CommentModel(
      {this.userId,
        this.username,
        this.commentId,
        this.imageUrl,
        this.dateTime,
        this.text,
        this.productId});

  CommentModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    dateTime = json['dateTime'];
    commentId = json['commentId'];
    username = json['username'];
    productId = json['productId'];
    imageUrl = json['imageUrl'];
    text = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'commentId': commentId,
      'dateTime': dateTime,
      'username': username,
      'imageUrl': imageUrl,
      'text': text,
      'productId': productId,
    };
  }
}
