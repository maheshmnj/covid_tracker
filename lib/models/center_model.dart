import 'package:json_annotation/json_annotation.dart';
// import 'education_model.dart';
part 'center_model.g.dart';

///
///
/// define a schema for your class and annotate
/// and then run
/// ```flutter pub run build_runner build ```
/// to watch the file changes and generate the outpur
/// ```flutter pub run build_runner watch ```
@JsonSerializable(nullable: false)
class CenterModel {
  final int center_id;
  final String name;
  final String address;
  final String state_name;
  final String district_name;
  final String block_name;
  final int pincode;
  final int lat;
  final int long;
  final String from;
  final String to;
  final String fee_type;
  final List<Sessions> sessions;

  CenterModel(
      this.center_id,
      this.name,
      this.address,
      this.state_name,
      this.district_name,
      this.block_name,
      this.pincode,
      this.lat,
      this.long,
      this.from,
      this.to,
      this.fee_type,
      this.sessions);
  factory CenterModel.fromJson(Map<String, dynamic> json) =>
      _$CenterModelFromJson(json);
  Map<String, dynamic> toJson() => _$CenterModelToJson(this);
}

@JsonSerializable(nullable: false)
class Sessions {
  final String session_id;
  final String date;
  final int available_capacity;
  final int min_age_limit;
  final String vaccine;
  final List<String> slots;
  final int available_capacity_dose1;
  final int available_capacity_dose2;

  Sessions(
      this.session_id,
      this.date,
      this.available_capacity,
      this.min_age_limit,
      this.vaccine,
      this.slots,
      this.available_capacity_dose1,
      this.available_capacity_dose2);
  factory Sessions.fromJson(Map<String, dynamic> json) =>
      _$SessionsFromJson(json);
  Map<String, dynamic> toJson() => _$SessionsToJson(this);
}
