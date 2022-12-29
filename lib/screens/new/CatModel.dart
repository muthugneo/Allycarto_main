class CatModel {
  final String id;
  final String name;

  CatModel({this.id, this.name,});

  factory CatModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CatModel(
      id: json["id"].toString(),
      name: json["name"].toString(),
    );
  }

  static List<CatModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => CatModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(CatModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;

}
