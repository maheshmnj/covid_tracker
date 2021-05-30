import 'package:flutter/cupertino.dart';

import '../widgets/widgets.dart';

class SearchModel extends ChangeNotifier {
  String _date;
  String _zipCode;

  SearchModel({String dt, String zp}) {
    _date = dt;
    _zipCode = zp;
  }
  String get zipcode => _zipCode;
  String get date => _date;
  set zipCode(String zip) {
    _zipCode = zip;
    notifyListeners();
  }

  set date(String dt) {
    _date = dt;
    notifyListeners();
  }
}
