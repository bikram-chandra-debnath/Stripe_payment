import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:test_payment/bindings/payment_binding.dart';
import 'package:test_payment/secrite/stripe_key.dart';
import 'package:test_payment/views/payment_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKey;
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Payment test',
      initialRoute: '/payment',
      getPages: [
        GetPage(
          name: "/payment",
          page: () => PaymentView(),
          binding: PaymentBinding(),
        ),
      ],
    );
  }
}
