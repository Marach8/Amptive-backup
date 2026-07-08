class LiveListenersResponseModel {
  const LiveListenersResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LiveListenersResponseModel.fromJson(Map<String, dynamic> json) {
    return LiveListenersResponseModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'] != null
          ? LiveListenersData.fromJson(json['data'])
          : null,
    );
  }

  final bool? status;
  final int? statusCode;
  final String? message;
  final LiveListenersData? data;
}

class LiveListenersData {
  const LiveListenersData({
    this.participants,
    this.viewerCount,
  });

  factory LiveListenersData.fromJson(Map<String, dynamic> json) {
    return LiveListenersData(
      participants: (json['participants'] as List<dynamic>?)
          ?.map((dynamic e) => LiveParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewerCount: json['viewer_count'] as int?,
    );
  }

  final List<LiveParticipant>? participants;
  final int? viewerCount;
}

class LiveParticipant {
  const LiveParticipant({
    this.name,
    this.id,
  });

  factory LiveParticipant.fromJson(Map<String, dynamic> json) {
    return LiveParticipant(
      name: json['name'],
      id: json['id'],
    );
  }

  final String? name;
  final String? id;
}
