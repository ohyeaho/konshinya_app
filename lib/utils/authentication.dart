import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth auth;
  Authentication(this.auth);
  Stream<User?> get authState => auth.idTokenChanges();

  /// サインアップメソッド
  Future<dynamic> signUp({String? nickName, String? email, String? password}) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      User? user = result.user;
      user!.updateDisplayName(nickName);
      print('アカウント作成成功');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'パスワードが弱すぎます';
      } else if (e.code == 'email-already-in-use') {
        return 'このメールアドレスはすでに使われています';
      } else if (e.code == 'invalid-email') {
        return 'メールアドレスが無効です';
      } else {
        return 'エラーが発生しました';
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  /// サインインメソッド
  Future<dynamic> signIn({String? email, String? password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      print('ログイン成功');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'このメールアドレスのユーザーは見つかりませんでした';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'パスワードが間違っています';
      } else {
        return 'メールアドレスまたはパスワードが間違っています';
      }
    }
  }

  /// ログアウトメソッド
  Future signOut() async {
    await auth.signOut();
    print('ログアウト完了');
  }

  ///アカウント削除メソッド
  static Future deleteAuth() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      print('アカウント削除完了');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }
  }
}
