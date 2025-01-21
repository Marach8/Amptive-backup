class GenericResponseModel {

  GenericResponseModel({
    this.isSuccessful,
    this.responseMessage,
    this.entityData
  });

  bool? isSuccessful;
  String? responseMessage;
  dynamic entityData;

  GenericResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccessful = json['success'];
    responseMessage = json['message'];
    entityData = json['entity'];
  }
}