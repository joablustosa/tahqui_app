class CodigoModel {
  CodigoModel({
    required this.id,
    required this.codigo,
    required this.userId,
    required this.status,
  });

  late int id;
  late String codigo;
  late String userId;
  late int status;

  factory CodigoModel.fromJson(Map<String, dynamic> json) => CodigoModel(
    id: json["id"],
    codigo: json["codigo"],
    userId: json["userId"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "codigo": codigo,
    "userId": userId,
    "status": status,
  };

  CodigoModel.fromMap(Map map){
    this.id = map["id"];
    this.codigo = map["codigo"];
    this.userId = map["userId"];
    this.status = map["status"];
  }
}