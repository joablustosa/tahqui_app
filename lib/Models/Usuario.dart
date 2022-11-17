class Usuario {

  String _name;
  String _userId;
  String _nickname;
  String _email;
  String _documentNumber;
  String _birthDate;
  String _street;
  String _number;
  String _complement;
  String _neighborhood;
  String _phone;
  String _zipCode;
  int _cityId;
  String _password;

  Usuario(
      this._name,
      this._userId,
      this._nickname,
      this._email,
      this._documentNumber,
      this._birthDate,
      this._street,
      this._number,
      this._complement,
      this._neighborhood,
      this._phone,
      this._zipCode,
      this._cityId,
      this._password,
      );

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "name"              : this.name,
      "userId"              : this.userId,
      "nickname"         : this.nickname,
      "email"    : this.email,
      "documentNumber"            : this.documentNumber,
      "birthDate"     : this.birthDate,
      "street"       : this.street,
      "number"    : this.number,
      "complement"          : this.complement,
      "neighborhood"          : this.neighborhood,
      "phone"          : this.phone,
      "zipCode"          : this.zipCode,
      "cityId"          : this.cityId,
      "password"          : this.password
    };
    return map;
  }

  String verificaTipoUsuario(bool tipoUsuario){
    return tipoUsuario ? "excurseiro" : "viajante";
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get zipCode => _zipCode;

  set zipCode(String value) {
    _zipCode = value;
  }

  int get cityId => _cityId;

  set cityId(int value) {
    _cityId = value;
  }

  String get neighborhood => _neighborhood;

  set neighborhood(String value) {
    _neighborhood = value;
  }

  String get complement => _complement;

  set complement(String value) {
    _complement = value;
  }

  String get number => _number;

  set number(String value) {
    _number = value;
  }

  String get street => _street;

  set street(String value) {
    _street = value;
  }

  String get birthDate => _birthDate;

  set birthDate(String value) {
    _birthDate = value;
  }

  String get documentNumber => _documentNumber;

  set documentNumber(String value) {
    _documentNumber = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get nickname => _nickname;

  set nickname(String value) {
    _nickname = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }
}