class Chat {
  String? receiver;
  String? text;
  String? sender;

  Chat({
    this.receiver,
    this.text,
    this.sender,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    receiver = json['receiver'];
    sender = json['sender'];

    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiver'] = this.receiver;
    data['sender'] = this.sender;
    data['text'] = this.text;

    return data;
  }
}
