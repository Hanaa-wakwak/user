import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:grocery/helpers/project_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';


class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '$apiBase/payment_intents';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${ProjectConfiguration.stripeSecretKey}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: ProjectConfiguration.stripePublishableKey,
            merchantId: ProjectConfiguration.stripeMerchantId,
        )
    );
  }


  static Future<String> payWithCard(String amount) async {




    init();

    var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );
      var paymentIntent = await StripeService.createPaymentIntent(
          amount,

      );
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );

      if (response.status == 'succeeded') {

        print('Transaction successful');

        return response.toJson()["paymentIntentId"];
      } else {

        throw PlatformException(
          code: "0",
          message: "Transaction failed"
        );
      }

  }



  static Future<Map<String, dynamic>> createPaymentIntent(String amount) async {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': 'usd',
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse(StripeService.paymentApiUrl),
          body: body,
          headers: StripeService.headers
      );

      print(response.body);
      return jsonDecode(response.body);

  }
}