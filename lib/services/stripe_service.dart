import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:test_payment/secrite/stripe_key.dart';

class StripeService extends GetxService {
  static const String baseUrl = "https://api.stripe.com";

  Future<Map<String,dynamic>?> createPaymetntIntent(String amount, String currency) async {
    try {
      final body = {
        "amount": (int.parse(amount) * 100).toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };
      final response = await post(
        Uri.parse("$baseUrl/v1/payment_intents"),
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body,
      );

      final data = jsonDecode(response.body);
      return data;
    } catch (error) {
      debugPrint("Error is : $error");
    }
    return null;
  }

  // Initialze Payment sheet

  Future<bool> initPaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: " Software Store ",
          style: ThemeMode.system,
        ),
      );
      return true;
    } catch (error) {
      debugPrint("error is : $error");
      return false;
    }
  }

  // Present Payment sheet

  Future<PaymentResult> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return PaymentResult.success;
    } on StripeException catch (e) {
      // recheck
      if (e.error.code == FailureCode.Canceled) {
        return PaymentResult.cancelled;
      } else {
        return PaymentResult.failed;
      }
    }
  }
}

enum PaymentResult { success, cancelled, failed }
