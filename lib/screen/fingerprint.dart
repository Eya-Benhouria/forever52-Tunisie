import 'package:flutter/material.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mightyweb/screen/DataScreen.dart';
import 'package:flutter/services.dart';

class PassCodeScreen extends StatefulWidget {
  PassCodeScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _PassCodeScreenState createState() => new _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  bool isFingerprint = false;

  Future<Null> biometrics() async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate');
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    if (authenticated) {
      setState(() {
        isFingerprint = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var myPass = [1, 2, 3, 4];
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                  child: LockScreen(
                      title: "Application locked ",
                      passLength: myPass.length,
                      bgImage: "",
                      fingerPrintImage: Image.asset(
                        "assets/fingerprint.png",
                        height: 40,
                        width: 40,
                        color: Color(0xFFda277e),
                      ),
                      showFingerPass: true,
                      fingerFunction: biometrics,
                      fingerVerify: isFingerprint,
                      borderColor: Color(0xFFda277e),
                      showWrongPassDialog: true,
                      wrongPassContent: "Wrong pass please try again.",
                      wrongPassTitle: "Opps!",
                      wrongPassCancelButtonText: "Cancel",
                      passCodeVerify: (passcode) async {
                        for (int i = 0; i < myPass.length; i++) {
                          if (passcode[i] != myPass[i]) {
                            return false;
                          }
                        }

                        return true;
                      },
                      onSuccess: () {
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (BuildContext context) {
                          return DataScreen();
                        }));
                      }))),
          Container(
            height: 140,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text('CREATE PIN',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFda277e),
                    primary: Color(0xFFda277e),
                    onSurface: Colors.yellow,
                    side: BorderSide(color: Color(0xFFda277e), width: 2),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    minimumSize: Size(150, 40),
                  ),
                  onPressed: () {
                    print('Pressed');
                  },
                ),
                TextButton(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text('Reset PIN',
                        style: TextStyle(
                            color: Color(0xFFda277e),
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                  style: TextButton.styleFrom(
                    primary: Color(0xFFda277e),
                    onSurface: Colors.yellow,
                    side: BorderSide(color: Color(0xFFda277e), width: 2),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    minimumSize: Size(150, 40),
                  ),
                  onPressed: () {
                    print('Pressed');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
