import 'package:flutter/material.dart';

/** 
 * Small helper widgets go here in this page
 * for custom large widgets consider creating 
 * a separate file under lib/widgets
 */

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
