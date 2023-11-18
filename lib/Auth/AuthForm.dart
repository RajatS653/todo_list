import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //-------------------------------------
  final _FormKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _username = '';
  bool IsLoginPage = false;

  //--------------------------------
  googleLogin() async {
    print("GoogleSignIn called");
    GoogleSignIn _GoogleSignIn = GoogleSignIn();
    try {
      var Result = await _GoogleSignIn.signIn();
      if (Result == null) {
        return;
      }
      final UserData = await Result.authentication;
      final Credential = GoogleAuthProvider.credential(
        accessToken: UserData.accessToken,
        idToken: UserData.idToken,

      );

      if (IsLoginPage) {
        try {
          var FinalResult =
              await FirebaseAuth.instance.signInWithCredential(Credential);

          print("result $Result");
          print(FinalResult.user!.displayName);
          print(FinalResult.user!.email);
          print(FinalResult.user!.photoURL);
          Fluttertoast.showToast(msg: 'Logged In', backgroundColor: Colors.white, textColor: Colors.black);
        } catch (error) {
          print("Error signing in with Google: $error");
        }
      } else {
        try {
          var FinalResult =
              await FirebaseAuth.instance.signInWithCredential(Credential);
          String uid = FinalResult.user!.uid;
          // Store user data in FireStore
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'email': FinalResult.user!.email,
            'username': FinalResult.user!.displayName
          });
          print("Data stored in Firebase");
          Fluttertoast.showToast(msg: 'Signed In', backgroundColor: Colors.white, textColor: Colors.black);
        } catch (error) {
          print("Error creating a new account with Google: $error");
        }
      }
    } catch (error) {
      print(error);
    }
  }

  void StartAuthentication() {
    if (_FormKey.currentState != null) {
      print("_FormKey validate");
      final isValid = _FormKey.currentState!.validate();

      // Ensure that the keyboard is closed when the form is submitted
      FocusScope.of(context).unfocus();

      if (isValid) {
        // If the form data is valid, save it
        _FormKey.currentState!.save();

        // Call your SubmitForm function with the saved data
        SubmitForm(_email, _password, _username);
      }
    } else {
      print("form key is null");
    }
  }

  SubmitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    try {
      if (IsLoginPage) {
        final userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Fluttertoast.showToast(msg: 'Logged In', backgroundColor: Colors.white, textColor: Colors.black);
        // You can access the authenticated user via userCredential.user
      } else {
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String uid = userCredential.user!.uid;
        // Store user data in FireStore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'email': email, 'username': username, 'password': password});
        print("Data store in firebase");
        Fluttertoast.showToast(msg: 'Signed In', backgroundColor: Colors.white, textColor: Colors.black);
      }
    } catch (err) {
      print("Error storing data in firebase:  $err");
      Fluttertoast.showToast(msg: "$err", backgroundColor: Colors.white, textColor: Colors.black);
    }

  }

  @override
  Widget build(BuildContext context) {
    return ListView(physics: BouncingScrollPhysics(), children: [
      Form(
        key: _FormKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 90),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide()),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.roboto()),
                ),
                SizedBox(
                  height: 20,
                ),
                if (!IsLoginPage)
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide()),
                      labelText: "Enter Username",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide()),
                    labelText: "Enter Password",
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        StartAuthentication();
                      },
                      child: IsLoginPage
                          ? Text(
                              "Log In",
                              style: GoogleFonts.roboto(fontSize: 20),
                            )
                          : Text(
                              "Sign Up",
                              style: GoogleFonts.roboto(fontSize: 20),
                            )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        IsLoginPage = !IsLoginPage;
                      });
                    },
                    child: IsLoginPage
                        ? Text("Not a member ?")
                        : Text("Already a member ?"),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    googleLogin();
                  },
                  child: Container(
                    height: 45,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage("Assets/Google_Signin.png"),
                            fit: BoxFit.fill)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
