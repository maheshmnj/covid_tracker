import 'package:vaccine_tracker/models/center_model.dart';

import '../../constants/const.dart';
import 'api_provider.dart';

class VaccineProvider {
  ApiProvider apiProvider;

  VaccineProvider() {
    apiProvider = ApiProvider();
  }

  Future<List<CenterModel>> getVaccinesAvailabilty(
      String pinCode, String date) async {
    try {
      final Map data = await apiProvider
          .getRequest(AVAILABILITY_ENDPOINT + '?pincode=$pinCode&date=$date');
      final list = (data['centers'] as List)
          .map((e) => CenterModel.fromJson(e))
          .toList();
      return list;
    } catch (_) {
      throw _;
    }
  }
}
