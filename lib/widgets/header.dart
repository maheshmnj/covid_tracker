import 'package:flutter/material.dart';
import 'package:vaccine_tracker/models/search_model.dart';
import '../exports.dart';
import 'search.dart';
import 'package:intl/intl.dart';

class HeaderBuilder extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Function(String) onSearch;
  final double height;
  final String initialDate;

  const HeaderBuilder(
      {Key key,
      this.onDateSelected,
      this.onSearch,
      this.initialDate,
      this.height})
      : super(key: key);
  @override
  _HeaderBuilderState createState() => _HeaderBuilderState();
}

class _HeaderBuilderState extends State<HeaderBuilder> {
  TextEditingController controller = TextEditingController();

  Future<DateTime> selectDate() async {
    final date = showDatePicker(
        context: context,
        initialDate: selected,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 30)));
    return date;
  }

  DateFormat formatter = DateFormat('dd-MM-yyyy');
  String selectedDate;
  SearchModel search;
  DateTime selected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = DateTime.now();
    search = SearchModel(dt: widget.initialDate);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool expanded = widget.height >= size.height ? true : false;
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
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: widget.height < size.height ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 16),
                  child: Text(
                    '${widget.initialDate}',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Align(
              alignment: Alignment.center,
              child: AnimatedPadding(
                duration: Duration(seconds: 1),
                padding: EdgeInsets.only(bottom: expanded ? 200 : 120),
                child: Text('VACCINE TRACKER',
                    style: TextStyle(
                        fontSize: size.width > kMOBILE
                            ? size.width * 0.032
                            : size.width * 0.06,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              )),
          Container(
            height: 100,
            width: size.width < kMOBILE ? size.width / 1.4 : size.width / 2,
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
                GestureDetector(
                    onTap: () async {
                      selected = await selectDate();
                      if (selected != null) {
                        setState(() {
                          selectedDate = formatter.format(selected);
                        });
                        search.date = selectedDate;
                        widget.onDateSelected(selected);
                      }
                    },
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        selectedDate ?? formatter.format(DateTime.now()),
                        style: TextStyle(fontSize: 16),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
