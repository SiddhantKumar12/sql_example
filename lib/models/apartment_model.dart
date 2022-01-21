class ApartmentDetail {
  int? id;
  String? ownerName;
  String? phoneNumber;
  // String? apartmentNumber;
  // String? vehicleNumber;
  // String? maintenanceCharges;

  ApartmentDetail({
    this.id,
    this.ownerName,
    this.phoneNumber,
    // this.apartmentNumber,
    //
    // this.vehicleNumber,
    // this.maintenanceCharges
  });

  static const tblApartmentDetail = 'Apartment';
  static const colId = 'id';
  static const colownerName = 'ownerName';
  static const colphoneNumber = 'phoneNumber';

  ApartmentDetail.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    ownerName = map[colownerName];
    phoneNumber = map[colphoneNumber];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
