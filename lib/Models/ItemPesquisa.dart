class ItemPesquisa {
  String? name;
  String? date;
  double? value;
  Company? company;

  ItemPesquisa({this.name, this.date, this.value, this.company});

  ItemPesquisa.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date = json['date'];
    value = json['value'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['date'] = this.date;
    data['value'] = this.value;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    return data;
  }
}

class Company {
  String? name;
  Address? address;

  Company({this.name, this.address});

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class Address {
  String? street;
  String? number;
  String? neighborhood;
  String? zipCode;
  City? city;

  Address(
      {this.street, this.number, this.neighborhood, this.zipCode, this.city});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    number = json['number'];
    neighborhood = json['neighborhood'];
    zipCode = json['zipCode'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['number'] = this.number;
    data['neighborhood'] = this.neighborhood;
    data['zipCode'] = this.zipCode;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    return data;
  }
}

class City {
  String? name;

  City({this.name});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}