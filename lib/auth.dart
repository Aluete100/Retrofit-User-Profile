import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  AuthService(){
      user = Observable(_auth.onAuthStateChanged);

      profile = user.switchMap((FirebaseUser u){
        if (u != null){
          return _db.collection('Users').document(u.uid).snapshots().map((snap) => snap.data);
        }else{
          return Observable.just({});
        }
      });

  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    updateUserData(user);
    print("signed in " + user.displayName);

    loading.add(false);

    return user;

  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('Users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
    }, merge: true);

  }

  void signOut(){
    _auth.signOut();
  }


}


final AuthService authService = AuthService();