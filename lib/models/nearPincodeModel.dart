class NearPincodeModel {
  int id;
  String dist_id;
  String pincode;
  String pincode_name;
  NearPincodeModel();
  NearPincodeModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"].toString() != null ? int.parse(json["id"].toString()) : null;
      dist_id = json["distri_id"].toString() != null ? json["distri_id"].toString() : null;
      pincode = json["pincode"] != null ? json["pincode"] : null;
      pincode_name = json["name"] != null ? json["name"] : null;
    } catch (e) {
      print("Exception - nearPincodeModel.dart - NearPincodeModel.fromJson():" + e.toString());
    }
  }
}

class NearPincodeModel2 {
  String status;
  String pincode;
  String googleapi;
  String message;
  NearPincodeModel2();
  NearPincodeModel2.fromJson(Map<String, dynamic> json) {
    try {
      status = json["status"] != null ? json["status"] : null;
      pincode = json["pincode"] != null ? json["pincode"] : null;
      googleapi = json["googleapi"] != null ? json["googleapi"] : null;
      message = json["message"] != null ? json["message"] : null;
    } catch (e) {
      print("Exception - nearPincodeModel.dart - NearPincodeModel.fromJson():" + e.toString());
    }
  }
}
