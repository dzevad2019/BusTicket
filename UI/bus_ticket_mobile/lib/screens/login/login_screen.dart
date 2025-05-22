import 'package:bus_ticket_mobile/helpers/constants.dart';
import 'package:bus_ticket_mobile/screens/home/home_page.dart';
import 'package:bus_ticket_mobile/screens/registration/registration_screen.dart';
import 'package:bus_ticket_mobile/utils/authorization.dart';
import 'package:bus_ticket_mobile/utils/notification_handler.dart';
import 'package:bus_ticket_mobile/utils/signalr_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/auth_request.dart';
import '../../providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = "login";


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TokenResponse? tokenResponse;

void _auth() async {
  // create the client
  var uri = new Uri(scheme: "https", host: "10.0.2.2", port: 7297);
  var issuer = await Issuer.discover(uri);
  var client = new Client(issuer, "flutter");

  // create a function to open a browser with an url
  urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  // create an authenticator
  var authenticator = new Authenticator(client,
      scopes: ["openid", "ApiOne"], port: 4000, urlLancher: urlLauncher);

  // starts the authentication
  var c = await authenticator.authorize();
  tokenResponse = await c.getTokenResponse();

  // close the webview when finished
  closeInAppWebView();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool result = await LoginProvider.login(AuthRequest(_usernameController.text, _passwordController.text));

      if (result) {
        final plugin = FlutterLocalNotificationsPlugin();
        final handler = NotificationHandler(plugin);
        await handler.initialize();

        final signalRService = SignalRService('${Constants.apiUrl}/hubs/notifications');
        await signalRService.startConnection(Authorization.token!);

        await signalRService.joinGroup('user_${Authorization.id}');

        signalRService.registerNotificationHandler((notification) async {
          await handler.showNotification(notification);
        });

        //Provider.of<SignalRService>(context, listen: false).updateService(signalRService);

        Navigator.pushReplacementNamed(context, HomePage.routeName);
      } else {
        setState(() {
          _errorMessage = "Pogrešno korisničko ime ili lozinka";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Došlo je do greške. Pokušajte ponovo.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor,
              theme.primaryColorLight,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo i naslov
                Image.asset(
                  'assets/images/bus_logo_2.png',
                  height: 150,
                ),
                //const SizedBox(height: 24),
                //Text(
                //  'BusTicket',
                //  style: TextStyle(
                //    fontSize: 32,
                //    fontWeight: FontWeight.bold,
                //    color: Colors.white,
                //  ),
                //),
                //const SizedBox(height: 1),
                Text(
                  'Prijavite se za putovanje',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 32),

                // Login forma
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Email polje
                          TextFormField(
                            controller: _usernameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email, color: theme.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Unesite email adresu';
                              }
                              if (!value.contains('@')) {
                                return 'Unesite validnu email adresu';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Lozinka polje
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Lozinka",
                              prefixIcon: Icon(Icons.lock, color: theme.primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: theme.primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Unesite lozinku';
                              }
                              if (value.length < 6) {
                                return 'Lozinka mora imati najmanje 6 znakova';
                              }
                              return null;
                            },
                          ),
                          //const SizedBox(height: 8),
//
                          //// Zaboravljena lozinka
                          //Align(
                          //  alignment: Alignment.centerRight,
                          //  child: TextButton(
                          //    onPressed: () {
                          //      // TODO: Implementirati reset lozinke
                          //    },
                          //    child: Text(
                          //      'Zaboravili ste lozinku?',
                          //      style: TextStyle(color: theme.primaryColor),
                          //    ),
                          //  ),
                          //),
                          const SizedBox(height: 24),

                          // Login dugme
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                              onPressed: _isLoading ? null : _login,
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                                  : Text(
                                'PRIJAVI SE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Registracija opcija
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Nemate račun? ',
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'Registrujte se',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}