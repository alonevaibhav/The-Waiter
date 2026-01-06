// import 'package:get/get.dart';
//
// /// GetX Controller for managing deep link state
// class DeepLinkController extends GetxController {
//   /// Observable state
//   final Rxn<String> pendingTableIdRx = Rxn<String>();
//   final RxBool isProcessedRx = false.obs;
//
//   /// Getters (safe access)
//   String? get pendingTableId => pendingTableIdRx.value;
//   bool get isProcessed => isProcessedRx.value;
//   bool get hasPendingDeepLink => pendingTableIdRx.value != null;
//
//   /// Store table ID from deep link
//   void setPendingDeepLink(String tableId) {
//     print('🔗 DeepLinkController: Setting pending tableId: $tableId');
//     pendingTableIdRx.value = tableId;
//     isProcessedRx.value = false;
//   }
//
//   /// Mark as processed to prevent re-navigation
//   void markAsProcessed() {
//     print('✅ DeepLinkController: Marked as processed');
//     isProcessedRx.value = true;
//   }
//
//   /// Clear the pending deep link
//   void clearPendingDeepLink() {
//     print('🗑️ DeepLinkController: Clearing pending deep link');
//     pendingTableIdRx.value = null;
//     isProcessedRx.value = false;
//   }
//
//   /// Reset for testing
//   void reset() {
//     pendingTableIdRx.value = null;
//     isProcessedRx.value = false;
//   }
//
//   @override
//   void onClose() {
//     pendingTableIdRx.close();
//     isProcessedRx.close();
//     super.onClose();
//   }
// }


import 'dart:developer' as developer;
import 'package:get/get.dart';

/// GetX Controller for managing deep link state
class DeepLinkController extends GetxController {
  /// Observable state for table ID
  final Rxn<String> pendingTableIdRx = Rxn<String>();

  /// Observable state for business ID (restaurant ID)
  final Rxn<String> pendingBusinessIdRx = Rxn<String>();

  /// Track if the deep link has been processed
  final RxBool isProcessedRx = false.obs;

  /// Getters (safe access)
  String? get pendingTableId => pendingTableIdRx.value;
  String? get pendingBusinessId => pendingBusinessIdRx.value;
  bool get isProcessed => isProcessedRx.value;
  bool get hasPendingDeepLink => pendingTableIdRx.value != null || pendingBusinessIdRx.value != null;

  /// Store table ID and business ID from deep link
  void setPendingDeepLink({String? tableId, String? businessId}) {
    developer.log('🔗 Setting pending deeplink', name: 'DeepLinkController');
    developer.log('   Table ID: $tableId', name: 'DeepLinkController');
    developer.log('   Business ID: $businessId', name: 'DeepLinkController');

    if (tableId != null) {
      pendingTableIdRx.value = tableId;
    }
    if (businessId != null) {
      pendingBusinessIdRx.value = businessId;
    }
    isProcessedRx.value = false;
  }

  /// Mark as processed to prevent re-navigation
  void markAsProcessed() {
    developer.log('✅ Marked as processed', name: 'DeepLinkController');
    isProcessedRx.value = true;
  }

  /// Clear the pending deep link
  void clearPendingDeepLink() {
    developer.log('🗑️ Clearing pending deep link', name: 'DeepLinkController');
    pendingTableIdRx.value = null;
    pendingBusinessIdRx.value = null;
    isProcessedRx.value = false;
  }

  /// Reset for testing
  void reset() {
    pendingTableIdRx.value = null;
    pendingBusinessIdRx.value = null;
    isProcessedRx.value = false;
  }

  @override
  void onClose() {
    pendingTableIdRx.close();
    pendingBusinessIdRx.close();
    isProcessedRx.close();
    super.onClose();
  }
}