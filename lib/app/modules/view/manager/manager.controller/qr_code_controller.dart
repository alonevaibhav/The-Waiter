import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:html' as html;

/// Controller for QR Code Generation (Web-optimized)
class QrGeneratorController extends GetxController {
  final tableNumberController = TextEditingController(text: '167');
  final RxString generatedUrl = 'https://the-waiter-1.vercel.app?id=167'.obs;
  final RxBool isGenerating = false.obs;
  final RxBool showQr = true.obs;

  final GlobalKey qrKey = GlobalKey();
  static const String baseUrl = 'https://the-waiter-1.vercel.app';

  @override
  void onInit() {
    super.onInit();
    updateUrl();
  }

  void updateUrl() {
    final tableNumber = tableNumberController.text.trim();
    if (tableNumber.isNotEmpty) {
      generatedUrl.value = '$baseUrl?id=$tableNumber';
      showQr.value = true;
    }
  }

  void generateQr() {
    updateUrl();
    Get.snackbar(
      'Success',
      'QR Code Generated!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> downloadQr() async {
    try {
      isGenerating.value = true;

      final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Could not find QR code widget');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) {
        throw Exception('Failed to convert QR code to image');
      }

      final tableNumber = tableNumberController.text.trim();
      final fileName = 'table_${tableNumber}_qr_code.png';

      _downloadFile(pngBytes, fileName);

      Get.snackbar(
        'Success',
        'QR Code downloaded!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download QR code: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isGenerating.value = false;
    }
  }

  void _downloadFile(Uint8List bytes, String filename) {
    final blob = html.Blob([bytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  void onClose() {
    tableNumberController.dispose();
    super.onClose();
  }
}
