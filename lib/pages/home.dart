import 'package:covid_tracker/models/center_model.dart';
import 'package:covid_tracker/services/api/vaccine_provider.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VaccineProvider vaccineProvider = VaccineProvider();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CenterModel>>(
        future: vaccineProvider.getVaccinesAvailabilty(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CenterModel>> snapshot) {
          if (snapshot.data == null) {
            return LoadingWidget();
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, x) {
                    return ExpansionTile(
                      title: Text('${snapshot.data[x].name}'),
                    );
                  },
                ),
              )
            ],
          );
        });
  }
}
