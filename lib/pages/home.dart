import 'dart:async';
import 'package:intl/intl.dart';
import 'package:vaccine_tracker/models/center_model.dart';
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

  String selectedDate;
  DateFormat formatter;
  @override
  Widget build(BuildContext context) {
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
                        setState(() {});
                      },
                      onSearch: (pinCode) async {
                        _vaccineController.sink.add(null);
                        final centers =
                            await vaccineProvider.getVaccinesAvailabilty(
                                pinCode, selectedDate.toString());
                        _vaccineController.sink.add(centers);
                        _viewController.animateTo(100,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      height: height ?? MediaQuery.of(context).size.height),
                  if (snapshot.data == null)
                    LoadingWidget()
                  else if (snapshot.hasError)
                    Text('${snapshot.error}')
                  else if (snapshot.data.isEmpty)
                    Container()
                  else
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, x) {
                          return ExpansionTile(
                            title: Text(
                              '${snapshot.data[x].name}',
                            ),
                            subtitle: Text('${snapshot.data[x].address}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('from ${snapshot.data[x].from}'),
                                Text('To ${snapshot.data[x].to}')
                              ],
                            ),
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
