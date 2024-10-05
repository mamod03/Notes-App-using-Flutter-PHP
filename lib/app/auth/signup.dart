import 'package:flutter/material.dart';
import 'package:getx_test/components/crud.dart';
import 'package:getx_test/components/customtextform.dart';
import 'package:getx_test/components/valid.dart';
import 'package:getx_test/constant/linkapi.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Crud _crud = Crud();
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController username = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  signUp() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequest(linkSignUp, {
        'username': username.text,
        'email': email.text,
        'password': pass.text
      });
      isLoading = false;
      setState(() {});
      print(response['status']);
      print('====================');
      if (response['status'] == 'success') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('success', (route) => false);
      } else {
        print('signup failed');
      }
    } else
      print('Signup failed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black,
          title: Text("Signup"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: [
                    Form(
                      key: formstate,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Image.asset(
                              'images/user-profile.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          CustomTextFormSign(
                            valid: (val) {
                              return validInput(val!, 8, 20);
                            },
                            hint: "Username",
                            mycontroller: username,
                          ),
                          CustomTextFormSign(
                            valid: (val) {
                              return validInput(val!, 10, 40);
                            },
                            hint: "Email",
                            mycontroller: email,
                          ),
                          CustomTextFormSign(
                            valid: (val) {
                              return validInput(val!, 8, 20);
                            },
                            hint: "Password",
                            mycontroller: pass,
                          ),
                          MaterialButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10),
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () async {
                              await signUp();
                            },
                            child: Text("Signup"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      '/login', (route) => false),
                              child: Text("Login"))
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
