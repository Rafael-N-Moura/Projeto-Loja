class Address {
  Address(
      {this.street,
      this.number,
      this.complement,
      this.district,
      this.zipCode,
      this.city,
      this.state,
      this.lat,
      this.long,
      this.telefone});

  String street;
  String number;
  String complement;
  String district;
  String zipCode;
  String city;
  String state;
  String telefone;

  double lat;
  double long;

  Address.fromMap(Map<String, dynamic> map) {
    street = map['street'] as String;
    number = map['number'] as String;
    complement = map['complement'] as String;
    district = map['district'] as String;
    zipCode = map['zipCode'] as String;
    city = map['city'] as String;
    state = map['state'] as String;
    lat = map['lat'] as double;
    long = map['long'] as double;
    telefone = map['telefone'] as String;
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'number': number,
      'complement': complement,
      'district': district,
      'zipCode': zipCode,
      'city': city,
      'state': state,
      'lat': lat,
      'long': long,
      'telefone': telefone,
    };
  }
}
