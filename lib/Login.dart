import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sale_app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LocalAuthentication auth;
  bool supportState = false;

  @override
  void initState() {
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
      (bool isSupported) {
        setState(() {
          supportState = isSupported;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (supportState)
            Text('This device is supported')
          else
            Text('This device is not supported'),
          Divider(height: 100),
          ElevatedButton(
            onPressed: () {
              getAvailableBiometrics();
            },
            child: Text('Get available biometrics'),
          ),
          Divider(height: 100),
          ElevatedButton(
            onPressed: () {
              authenticate();
            },
            child: Text('Authenticate'),
          ),
        ],
      ),
    );
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType> biometrics = await auth.getAvailableBiometrics();
    print('List of biometrics: $biometrics');
    if (!mounted) {
      return;
    }
  }

  Future<void> authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'localizedReason',
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print('$authenticated');
      if (authenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
