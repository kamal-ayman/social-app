class MessageModel {
  late String? senderId;
  late String receiverId;
  late String message;
  late String time;
  late String? image;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.time,
    required this.image,
  });
  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = json['message'];
    time = json['time'];
    image = json['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'time': time,
      'image': image,
    };
  }
}
