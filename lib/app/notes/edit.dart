import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getx_test/components/crud.dart';
import 'package:getx_test/components/customtextform.dart';
import 'package:getx_test/components/valid.dart';
import 'package:getx_test/constant/linkapi.dart';
import 'package:image_picker/image_picker.dart';

class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({super.key, required this.notes});

  @override
  State<EditNotes> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EditNotes> {
  Crud curd = Crud();
  File? myfile;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  bool isLoading = false;
  editnotes() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response;
      if (myfile == null) {
        response = await curd.postRequest(
          linkEditNotes,
          {
            'title': title.text,
            'content': content.text,
            'id': widget.notes['notes_id'].toString(),
            'imagename': widget.notes['notes_image'].toString()
          },
        );
      } else {
        response = await curd.postRequestWithFile(
            linkEditNotes,
            {
              'title': title.text,
              'content': content.text,
              'id': widget.notes['notes_id'].toString(),
              'imagename': widget.notes['notes_image'].toString()
            },
            myfile!);
      }
      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {}
    }
  }

  @override
  void initState() {
    title.text = widget.notes['notes_title'];
    content.text = widget.notes['notes_content'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
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
                        await editnotes();
                      },
                      child: Text('Save Changes'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
