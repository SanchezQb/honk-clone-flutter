class Conversation {
  List<Participant>? participants;
  String? id;

  Conversation({this.participants, this.id});

  Conversation.fromJson(Map<String, dynamic> json) {
    if (json['participants'] != null) {
      participants = [];
      json['participants'].forEach((v) {
        participants!.add(new Participant.fromJson(v));
      });
    }
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.participants != null) {
      data['participants'] = this.participants!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class Participant {
  String? id;
  String? username;
  String? name;
  String? password;
  String? createdAt;
  String? updatedAt;

  Participant({
    this.id,
    this.username,
    this.name,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  Participant.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    name = json['name'];
    password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['password'] = this.password;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
