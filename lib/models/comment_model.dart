class CommentModel {
  late String dateTime;
  late String uId;
  late String? image;
  late String? postImage;
  late String name;
  late String text;

  CommentModel(
      {required this.dateTime,
        required this.uId,
        this.image,
        this.postImage,
        required this.name,
        required this.text});

  CommentModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    name = json['name'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['uId'] = this.uId;
    data['image'] = this.image;
    data['postImage'] = this.postImage;
    data['name'] = this.name;
    data['text'] = this.text;
    return data;
  }
}
