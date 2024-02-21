import 'package:cinetpay/cinetpay.dart';
import 'package:dexter_mobile/providers/authprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CinetPay extends StatefulWidget {
  CinetPay(
      {super.key,
      required this.transId,
      required this.cost,
      required this.description,
      required this.channel});

  String transId;
  String description;
  String channel;
  int cost;

  @override
  State<CinetPay> createState() => _CinetPayState();
}

class _CinetPayState extends State<CinetPay> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    return CinetPayCheckout(
        title: 'Guichet de paiement',
        configData: const <String, dynamic>{
          'apikey': '971408392655f1a56284615.67795424',
          'site_id': '5866028',
          'notify_url': 'https://mondomaine.com/notify/'
        },
        paymentData: <String, dynamic>{
          'transaction_id': "vjyC", //widget.transId.toString(),
          'amount': widget.cost,
          'currency': 'XOF',
          'channels': widget.channel,
          'description': widget.description,
          'customer_name': user.firstName.toUpperCase(),
          'customer_city': 'city',
          'customer_email': user.email,
          'customer_surname': user.lastName.toUpperCase(),
          'customer_address': 'address',
          'customer_country': "CI",
          'customer_zip_code': "zip_code",
          'customer_phone_number': user.phone.toString()
        },
        waitResponse: (response) {
          debugPrint("CINETPAY RESPONSE\n");
          print(response);
        },
        onError: (error) {
          debugPrint("CINETPAY ERROR\n");
          print(error);
        });
  }
}
