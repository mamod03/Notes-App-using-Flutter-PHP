import 'package:flutter/material.dart';
import 'package:getx_test/constant/linkapi.dart';
import 'package:getx_test/model/notemodel.dart';

class CardNotes extends StatelessWidget {
  void Function() ontap;
  final noteModel notemodel;
  CardNotes({super.key, required this.ontap, required this.notemodel});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Image.network(
                  "$linkImageRoot/${notemodel.notesImage}",
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                )),
            Expanded(
                flex: 2,
                child: ListTile(
                  title: Text("${notemodel.notesTitle}"),
                  subtitle: Text("${notemodel.notesContent}"),
                ))
          ],
        ),
      ),
    );
  }
}
