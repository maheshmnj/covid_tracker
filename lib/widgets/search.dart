import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              hintText: 'Search vaccine centers by pincode ',
              suffixIcon: IconButton(
                onPressed: () => isValid
                    ? widget.onSearch(widget.textEditingController.text)
                    : null,
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