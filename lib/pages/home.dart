import 'dart:async';
import 'dart:ui';
import 'package:covid_tracker/models/center_model.dart';
import 'package:covid_tracker/services/api/vaccine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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
  final _vaccineController = StreamController<List<CenterModel>>.broadcast();

  @override
  void dispose() {
    // TODO: implement dispose
    _vaccineController.close();
    _scrollController.dispose();
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
        setState(() {
          height = MediaQuery.of(context).size.height / 1.5;
        });
      }
    }
  }

  double height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<CenterModel>>(
          initialData: [],
          stream: _vaccineController.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<CenterModel>> snapshot) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  HeaderBuilder(
                      onSearch: (pinCode) async {
                        _vaccineController.sink.add(null);
                        final centers = await vaccineProvider
                            .getVaccinesAvailabilty(pinCode);
                        _vaccineController.sink.add(centers);
                      },
                      height: height ?? MediaQuery.of(context).size.height / 2),
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
                            subtitle: Text(
                                '${snapshot.data[x].from}-${snapshot.data[x].to}'),
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

class HeaderBuilder extends StatefulWidget {
  final Function onDateSelected;
  final Function(String) onSearch;
  final double height;

  const HeaderBuilder(
      {Key key, this.onDateSelected, this.onSearch, this.height})
      : super(key: key);
  @override
  _HeaderBuilderState createState() => _HeaderBuilderState();
}

class _HeaderBuilderState extends State<HeaderBuilder> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.orange[200],
          ),
          Align(
              alignment: Alignment.center,
              child: AnimatedPadding(
                duration: Duration(seconds: 1),
                padding: EdgeInsets.only(
                    bottom: widget.height == size.height / 1.5 ? 200 : 120),
                child: Text('COVID TRACKER',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              )),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: SearchBuilder(
                        textEditingController: controller,
                        onSearch: (pin) => widget.onSearch(pin))),
                SizedBox(
                  width: 8,
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.calendar_today))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBuilder extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(String) onSearch;
  const SearchBuilder({Key key, this.textEditingController, this.onSearch})
      : super(key: key);
  @override
  _SearchBuilderState createState() => _SearchBuilderState();
}

class _SearchBuilderState extends State<SearchBuilder> {
  bool isValid = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: TextField(
            controller: widget.textEditingController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              LengthLimitingTextInputFormatter(6)
            ],
            onChanged: (x) {
              if (x.length == 6 || x.isEmpty) {
                isValid = true;
              } else {
                isValid = false;
              }
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Search covid centers by pincode ',
              suffixIcon: IconButton(
                onPressed: () =>
                    widget.onSearch(widget.textEditingController.text),
                icon: Icon(
                  Icons.search,
                  size: 28,
                ),
              ),
              contentPadding: EdgeInsets.all(16),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
        !isValid
            ? Container(
                height: 20,
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Enter a valid pincode',
                  style: TextStyle(color: Colors.red),
                ),
              )
            : SizedBox(
                height: 20,
              )
      ],
    );
  }
}
