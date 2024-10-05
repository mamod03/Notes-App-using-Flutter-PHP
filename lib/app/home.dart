import 'package:flutter/material.dart';
import 'package:getx_test/app/notes/add.dart';
import 'package:getx_test/app/notes/edit.dart';
import 'package:getx_test/components/cardnote.dart';
import 'package:getx_test/components/crud.dart';
import 'package:getx_test/constant/linkapi.dart';
import 'package:getx_test/main.dart';
import 'package:getx_test/model/notemodel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  final Crud _crud = Crud();
  getNotes() async {
    var response = await _crud
        .postRequest(linkViewNotes, {"id": sharedPref.getString('id')});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNotes()));
        },
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  sharedPref.clear();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
                },
                icon: const Icon(Icons.exit_to_app))
          ],
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.black,
          title: const Text(
            "Home",
          )),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
                future: getNotes(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['status'] == 'fail') {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            'No Notes Exist',
                            style: TextStyle(fontSize: 30),
                          )),
                          Icon(
                            Icons.emoji_people_outlined,
                            size: 70,
                          )
                        ],
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        Data dat = Data(
                            id: snapshot.data['data'][i]['notes_id']
                                .toString());

                        return Dismissible(
                            onDismissed: (direction) async {
                              String nid =
                                  snapshot.data['data'][i]["notes_title"];
                              var response =
                                  await _crud.postRequest(linkDeleteNotes, {
                                'id': snapshot.data['data'][i]["notes_id"]
                                    .toString(),
                                "imagename": snapshot.data['data'][i]
                                        ["notes_image"]
                                    .toString()
                              });
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 39, 75),
                                        content: ListTile(
                                          textColor: Colors.white,
                                          iconColor: Colors.green,
                                          title: Text(
                                            'The Note with title "$nid" has been deleted !',
                                          ),
                                          trailing: Icon(Icons.done_all),
                                        )));
                              }
                            },
                            key: Key(dat.id),
                            child: CardNotes(
                              ontap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditNotes(
                                        notes: snapshot.data['data'][i])));
                              },
                              notemodel:
                                  noteModel.fromJson(snapshot.data['data'][i]),
                            ));
                      },
                      itemCount: snapshot.data['data'].length,
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const Center(child: CircularProgressIndicator());
                })
          ],
        ),
      ),
    );
  }
}

class Data {
  final String id;

  Data({required this.id});
}
