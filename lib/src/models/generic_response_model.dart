class GenericResponseModel {
  GenericResponseModel(
      {this.isSuccessful, this.responseMessage, this.entityData});

  GenericResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccessful = json['success'];
    responseMessage = json['message'];
    entityData = json['entity'];
  }

  bool? isSuccessful;
  String? responseMessage;
  dynamic entityData;
}
