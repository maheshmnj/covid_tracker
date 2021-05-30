import 'package:flutter/material.dart';
import 'search.dart';

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
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 30)));
    return date;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool expanded = widget.height == size.height ? true : false;
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
            alignment: Alignment.bottomRight,
            child: AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: expanded ? 0 : 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 16.0),
                  child: Text(
                    'showing results for ${widget.initialDate}',
                    style: TextStyle(fontSize: 16),
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
                IconButton(
                    onPressed: () async {
                      final date = await selectDate();
                      widget.onDateSelected(date);
                    },
                    icon: Icon(Icons.calendar_today))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
