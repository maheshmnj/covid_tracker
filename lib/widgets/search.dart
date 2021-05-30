import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vaccine_tracker/models/search_model.dart';

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
    final _search = Provider.of<SearchModel>(context, listen: false);
    return Consumer(
      builder: (BuildContext _, SearchModel searchModel, Widget child) =>
          Column(
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
                  widget.onSearch(x);
                } else {
                  isValid = false;
                }
                _search.zipCode = x;
              },
              decoration: InputDecoration(
                hintText: 'Enter pincode ',
                suffixIcon: IconButton(
                  onPressed: () {
                    final text = widget.textEditingController.text;
                    if (text.isNotEmpty && text.length == 6) {
                      widget.onSearch(text);
                    } else {
                      setState(() {
                        isValid = false;
                      });
                    }
                  },
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
      ),
    );
  }
}
