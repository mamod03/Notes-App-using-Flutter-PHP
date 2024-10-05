import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getx_test/components/crud.dart';
import 'package:getx_test/components/customtextform.dart';
import 'package:getx_test/components/valid.dart';
import 'package:getx_test/constant/linkapi.dart';
import 'package:getx_test/main.dart';
import 'package:image_picker/image_picker.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddNotes> {
  File? myfile;
  Crud curd = Crud();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  bool isLoading = false;
  addnotes() async {
    if (myfile == null) {
      return ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          backgroundColor: Color.fromARGB(255, 53, 85, 105),
          leading: Icon(
            Icons.warning,
            color: Colors.red,
          ),
          contentTextStyle: TextStyle(color: Colors.white),
          content: Text(
            'Please Select an Image!',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                },
                child: Text(
                  'Dismiss',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ))
          ]));
    }
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await curd.postRequestWithFile(
          linkAddNotes,
          {
            'title': title.text,
            'content': content.text,
            'id': sharedPref.getString('id')
          },
          myfile!);
      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    CustomTextFormSign(
                        action: TextInputAction.next,
                        hint: 'title',
                        mycontroller: title,
                        valid: (val) {
                          return validInput(val!, 5, 20);
                        }),
                    CustomTextFormSign(
                        action: TextInputAction.done,
                        hint: 'content',
                        mycontroller: content,
                        valid: (val) {
                          return validInput(val!, 10, 255);
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      textColor: Colors.white,
                      color: myfile == null ? Colors.blue : Colors.green,
                      onPressed: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          XFile? xfile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          Navigator.of(context).pop();
                                          myfile = File(xfile!.path);
                                          setState(() {});
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'From Gallery',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          XFile? xfile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera);
                                          Navigator.of(context).pop();
                                          myfile = File(xfile!.path);
                                          setState(() {});
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'From Camera',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                      },
                      child: Text('Upload Image'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        await addnotes();
                      },
                      child: Text('Add Note'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
