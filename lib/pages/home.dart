import 'dart:async';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vaccine_tracker/models/center_model.dart';
import 'package:vaccine_tracker/models/search_model.dart';
import 'package:vaccine_tracker/services/api/vaccine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vaccine_tracker/widgets/header.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VaccineProvider vaccineProvider = VaccineProvider();
  ScrollController _scrollController = ScrollController();
  ScrollController _viewController = ScrollController();
  final _vaccineController = StreamController<List<CenterModel>>.broadcast();

  @override
  void dispose() {
    // TODO: implement dispose
    _vaccineController.close();
    _scrollController.dispose();
    _viewController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        height = MediaQuery.of(context).size.height / 3;
      });
    } else {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_scrollController.offset ==
            _scrollController.position.minScrollExtent) {
          setState(() {
            height = MediaQuery.of(context).size.height / 1;
          });
        }
      }
    }
  }

  double height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(scrollListener);
    formatter = DateFormat('dd-MM-yyyy');
    selectedDate = formatter.format(DateTime.now());
  }

  void executeSearch(String pinCode) async {
    if (pinCode.isNotEmpty && pinCode.length == 6) {
      removeFocus(context);
      showCircularIndicator(context);
      _search.zipCode = pinCode;
      _vaccineController.sink.add(null);
      final centers = await vaccineProvider.getVaccinesAvailabilty(
          pinCode, selectedDate.toString());
      stopCircularIndicator(context);
      _vaccineController.sink.add(centers);
      _viewController.animateTo(100,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  String selectedDate;
  DateFormat formatter;
  SearchModel _search;
  @override
  Widget build(BuildContext context) {
    _search = Provider.of(context, listen: false);
    return Scaffold(
      body: StreamBuilder<List<CenterModel>>(
          initialData: [],
          stream: _vaccineController.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<CenterModel>> snapshot) {
            return SingleChildScrollView(
              controller: _viewController,
              child: Column(
                children: [
                  HeaderBuilder(
                      initialDate: selectedDate,
                      onDateSelected: (x) {
                        selectedDate = formatter.format(x);
                        _search.date = selectedDate;
                        executeSearch(_search.zipCode ?? '');
                        setState(() {});
                      },
                      onSearch: (pinCode) => executeSearch(pinCode),
                      height: height ?? MediaQuery.of(context).size.height),
                  if (snapshot.hasError)
                    Text('${snapshot.error}')
                  else if (snapshot.data == null || snapshot.data.isEmpty)
                    Container()
                  else
                    Container(
                      height: MediaQuery.of(context).size.height / 1.1,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, x) {
                          final vaccineLocation = snapshot.data[x];
                          final sessions = snapshot.data[x].sessions[0];
                          return ExpansionTile(
                            title: Text(
                              '${vaccineLocation.name}',
                            ),
                            subtitle: Text('${vaccineLocation.address}'),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Min age: ${sessions.min_age_limit}'),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            'Available Capacity: ${sessions.available_capacity}'),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            'Available Capacity Dose1: ${sessions.available_capacity_dose1}'),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                            'Available Capacity Dose2: ${sessions.available_capacity_dose2}')
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${sessions.vaccine} '),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 2,
                                  children: sessions.slots
                                      .map((e) => InputChip(
                                            label: Text(e),
                                            onPressed: () {},
                                            backgroundColor: Colors
                                                .blueAccent[100]
                                                .withOpacity(0.5),
                                          ))
                                      .toList(),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    )
                ],
              ),
            );
          }),
    );
  }
}
