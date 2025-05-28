import 'package:in_app_purchase/in_app_purchase.dart';
import '../helpers/pref.dart';

class InAppPurchaseService {
  void initialize() {
    InAppPurchase.instance.purchaseStream.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending status
        _showPendingUI();
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          // Grant access to subscription content
          _grantAccess();
        } else {
          // Handle invalid purchase
          _handleInvalidPurchase();
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
        _handleError(purchaseDetails.error);
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Verify the purchase with your backend or Google Play
    // For now, assuming all purchases are valid
    return true;
  }

  void _showPendingUI() {
    // Show a loading indicator or a pending status message
    print("Purchase is pending...");
  }

  void _grantAccess() async {
    // Unlock premium servers
    Pref.isUserPremium = true;
    print("Access to premium content granted.");
  }

  void _handleInvalidPurchase() {
    // Handle invalid purchase
    print("Invalid purchase. Please try again.");
  }

  void _handleError(IAPError? error) {
    // Handle error
    print("Purchase error: ${error?.message}");
  }
}
