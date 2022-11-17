class UsuarioRetorno {

  UsuarioRetorno({
    required this.nickname,
    required this.phone,
    required this.birthDate,
    required this.street,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.zipCode,
    required this.cityId,
    required this.name,
    required this.documentNumber,
    required this.email,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.errorMessage,
    required this.token
  });

  String nickname;
  String phone;
  String birthDate;
  String street;
  String number;
  String complement;
  String neighborhood;
  String zipCode;
  int    cityId;
  String name;
  String documentNumber;
  String email;
  String code;
  String createdAt;
  String updatedAt;
  int    status;
  String errorMessage;
  String token;

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nickname": this.nickname,
      "phone": this.phone,
      "birthDate": this.birthDate,
      "street": this.street,
      "number": this.number,
      "complement": this.complement,
      "neighborhood": this.neighborhood,
      "zipCode": this.zipCode,
      "cityId": this.cityId,
      "name": this.name,
      "documentNumber": this.documentNumber,
      "email": this.email,
      "code": this.code,
      "createdAt": this.createdAt,
      "updatedAt": this.updatedAt,
      "status": this.status,
      "errorMessage": this.errorMessage,
      "token": this.token
    };
    return map;
  }

  String verificaTipoUsuario(bool tipoUsuario){
    return tipoUsuario ? "excurseiro" : "viajante";
  }

  factory UsuarioRetorno.fromJson(Map<String, dynamic> json) => UsuarioRetorno(
      nickname: json["nickname"] ?? "NickName",
      phone: json["phone"] ?? "Telefone",
      birthDate: json["birthDate"] ?? "Data de Aniversário",
      street: json["street"] ?? "Rua",
      number: json["number"] ?? "Número",
      complement: json["complement"] ?? "Complemento",
      neighborhood: json["neighborhood"] ?? "Bairro",
      zipCode: json["zipCode"] ?? "CEP",
      cityId: json["cityId"] ?? "Cidade",
      name: json["name"] ?? "Nome",
      documentNumber: json["documentNumber"] ?? "Documento",
      email: json["email"] ?? "E-mail",
      code: json["code"] ?? "#",
      createdAt: json["createdAt"] ?? "Criado em: ",
      updatedAt: json["updatedAt"] ?? "Atualizado em: ",
      status: json["status"] ?? "Status",
      errorMessage: json["errorMessage"] ?? "Mensagem",
      token: json["token"] ?? "Token"
  );
}