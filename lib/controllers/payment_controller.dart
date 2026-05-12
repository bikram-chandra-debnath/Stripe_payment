import 'package:get/get.dart';
import 'package:test_payment/services/stripe_service.dart';

class PaymentController extends GetxController {
  final StripeService stripeService = Get.find<StripeService>();

  final isLoading = false.obs;
  final paymentStatus = " ".obs;

  Future<void> makePayment({
    required String amount,
    required String currency,
  }) async {
    try {
      isLoading.value = true;
      paymentStatus.value = "";

      final clientSecret = await stripeService.createPaymetntIntent(
        amount,
        currency,
      );

      if (clientSecret == null) {
        handleError("Failed to create payment intent.");
        return;
      }
      final initialzed = await stripeService.initPaymentSheet(clientSecret['client_secret']);

      if (!initialzed) {
        handleError("Failed to initialize payment sheet.");
        return;
      }

      final result = await stripeService.presentPaymentSheet();

      switch (result) {
        case PaymentResult.success:
          Get.snackbar(
            "Payment Successful",
            "Your payment was processed successfully.",
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
        case PaymentResult.cancelled:
          Get.snackbar(
            "Cancelled",
            "Your payment was cancelled.",
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
        case PaymentResult.failed:
          handleError("Payment failed. Please try again.");
          break;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void handleError(String message) {
    paymentStatus.value = "failed";

    Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
  }
}
