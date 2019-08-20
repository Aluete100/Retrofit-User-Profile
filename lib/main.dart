import 'package:flutter/material.dart';
import 'auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
            title: Text('Flutter Demo Home Page'),
            backgroundColor: Colors.amber),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoginButton(),
              UserProfile()
            ],
          ),
        ),
      ),
    );
  }
}


class UserProfile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile>{
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Text(_profile.toString()),
        ),
        Text(_profile.toString())
      ],
    );
  }

}


class LoginButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot){
        if (snapshot.hasData){
          return MaterialButton(
            onPressed: () => authService.signOut(),
            color: Colors.red,
            textColor: Colors.black,
            child: Text('Log Out'),
          );
        }else{
          return MaterialButton(
            onPressed: () => authService.googleSignIn(),
            color: Colors.white,
            textColor: Colors.black,
            child: Text('Login with Google'),
          );
        }
      },
    );
  }

}
