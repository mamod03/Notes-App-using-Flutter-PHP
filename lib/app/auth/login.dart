import 'package:flutter/material.dart';
import 'package:getx_test/components/crud.dart';
import 'package:getx_test/components/customtextform.dart';
import 'package:getx_test/components/valid.dart';
import 'package:getx_test/constant/linkapi.dart';
import 'package:getx_test/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  // ignore: unnecessary_new
  Crud crud = new Crud();
  bool isLoading = false;
  login() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await crud
          .postRequest(linkLogin, {'email': email.text, 'password': pass.text});
      isLoading = false;
      setState(() {});
      print(response['status']);
      if (response['status'] == 'success') {
        sharedPref.setString('id', response['data']['id'].toString());
        sharedPref.setString('username', response['data']['username']);
        sharedPref.setString('email', response['data']['email']);
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed , credintals wrong')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black,
          title: Text("Login"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
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
                              return validInput(val!, 8, 40);
                            },
                            hint: "Email",
                            mycontroller: email,
                          ),
                          CustomTextFormSign(
                            valid: (val) {
                              return validInput(val!, 8, 40);
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
                              await login();
                            },
                            child: Text("Login"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      'signup', (route) => false),
                              child: Text("Sign Up "))
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }
}
