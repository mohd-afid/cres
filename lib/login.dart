import 'package:cres/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password, _name;
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool auth = true;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

/*  Future<String> signIn({ String email,  String password}) async {
    print("sign in");
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  Future<String> signUp({ String email,  String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);

        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }*/

  signup() async{
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _emailcontroller.text, password: _passwordcontroller.text);
      if (user != null) {
        // UserUpdateInfo updateuser = UserUpdateInfo();
        // updateuser.displayName = _name;
        //  user.updateProfile(updateuser);
        await _auth.currentUser.updateProfile(displayName: _name);
        // await Navigator.pushReplacementNamed(context,"/") ;

      }
    } catch (e) {
      showError(e.message);
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
   /* this.checkAuthentification();*/
  }

  login() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailcontroller.text, password: _passwordcontroller.text);
    } catch (e) {
      showError(e.message);
      print(e);
      print("fail");
      auth = false;
    }
    print("succ");
   if(auth == true ){
     setState(() {
       Navigator.push(context, MaterialPageRoute(builder: (context) => home(),));
     });

   }else{

   }

  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  navigateToSignUp() async {
   // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
               /* Container(
                  height: 400,
                  child: Image(
                    image: AssetImage("images/login.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),*/
                SizedBox(height: 300,),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextFormField(

                              /*validator: (input) {
                                if (input.isEmpty) return 'Enter Email';
                              }*/

                              controller: _emailcontroller,
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email)),
                              //onSaved: (input) => _email = input
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            /*  validator: (input) {
                                if (input.length < 6)
                                  return 'Provide Minimum 6 Character';
                              }*/
                              controller: _passwordcontroller,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                              //onSaved: (input) => _password = input
                          ),
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed:(){signup();} ,
                          child: const Text('Signup',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed:(){login();} ,
                          child: const Text('LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}