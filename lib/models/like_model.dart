class LikeModel {
  late String dateTime;
  late String uId;
  late String? image;
  late String name;
  late bool like;

  LikeModel(
      {required this.dateTime,
        required this.uId,
        this.image,
        required this.name,
        required this.like});


  LikeModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    uId = json['uId'];
    image = json['image'];
    name = json['name'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['uId'] = this.uId;
    data['image'] = this.image;
    data['name'] = this.name;
    data['like'] = this.like;
    return data;
  }
}
