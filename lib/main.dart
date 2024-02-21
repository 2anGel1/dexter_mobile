import 'package:dexter_mobile/providers/programmationprovider.dart';
import 'package:dexter_mobile/providers/reservationprovider.dart';
import 'package:dexter_mobile/providers/propertyprovider.dart';
import 'package:dexter_mobile/providers/rapportsprovider.dart';
import 'package:dexter_mobile/providers/searchprovider.dart';
import 'package:dexter_mobile/providers/reservdetail.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:dexter_mobile/providers/homeprovider.dart';
import 'package:dexter_mobile/routes/routemanager.dart';
import 'package:dexter_mobile/api/firebase_api.dart';
import 'package:dexter_mobile/firebase_options.dart';
import 'package:dexter_mobile/services/localnotification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FireBaseApi().initNotifications();
  initializeDateFormatting('fr_FR', null).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService().showNotification(message);
    });
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProgrammationProvider()),
          ChangeNotifierProvider(create: (context) => ReservDetailProvider()),
          ChangeNotifierProvider(create: (context) => ReservationProvider()),
          ChangeNotifierProvider(create: (context) => PropertyProvider()),
          ChangeNotifierProvider(create: (context) => RapportsProvider()),
          ChangeNotifierProvider(create: (context) => SearchProvider()),
          ChangeNotifierProvider(create: (context) => HomeProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
        ],
        child: const MaterialApp(
          title: 'Dexter Mobile',
          debugShowCheckedModeBanner: false,
          initialRoute: RouteManager.splash,
          onGenerateRoute: RouteManager.generateRoute,
        ));
  }
}
