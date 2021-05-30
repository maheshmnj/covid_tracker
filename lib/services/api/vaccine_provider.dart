import 'package:covid_tracker/models/center_model.dart';

import '../../constants/const.dart';
import 'api_provider.dart';

class VaccineProvider {
  ApiProvider apiProvider;

  VaccineProvider() {
    apiProvider = ApiProvider();
  }

  Future<List<CenterModel>> getVaccinesAvailabilty() async {
    try {
      final Map data = await apiProvider.getRequest(
          AVAILABILITY_ENDPOINT + '?pincode=431602&date=30-05-2021');
      final list = (data['centers'] as List)
          .map((e) => CenterModel.fromJson(e))
          .toList();
      return list;
    } catch (_) {
      throw _;
    }
  }
}
