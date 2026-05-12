import 'package:get/instance_manager.dart';
import 'package:test_payment/controllers/payment_controller.dart';
import 'package:test_payment/services/stripe_service.dart';

class PaymentBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<StripeService>(()=> StripeService());
    Get.lazyPut<PaymentController>(()=> PaymentController());
  }
}