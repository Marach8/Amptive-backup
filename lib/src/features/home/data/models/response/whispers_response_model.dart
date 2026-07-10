class WhispersResponseModel {
  const WhispersResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory WhispersResponseModel.fromJson(Map<String, dynamic> json) {
    return WhispersResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'] != null
          ? WhispersData.fromJson(json['data'])
          : null,
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final WhispersData? data;
}

class WhispersData {
  const WhispersData({
    this.whispers,
  });

  factory WhispersData.fromJson(Map<String, dynamic> json) {
    return WhispersData(
      whispers: (json['messages'] as List<dynamic>?)
          ?.map((dynamic e) => Whisper.fromJson(e))
          .toList(),
    );
  }

  final List<Whisper>? whispers;
}

class Whisper {
  const Whisper({
    this.id,
    this.userId,
    this.message,
    this.timestamp,
  });

  factory Whisper.fromJson(Map<String, dynamic> json) {
    return Whisper(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }

  final String? id, userId, message, timestamp;
}
