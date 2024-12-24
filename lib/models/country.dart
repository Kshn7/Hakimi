class Country {
  String code;
  String name;
  Country(this.code, this.name);

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(json['code'], json['name']);
  }
}
