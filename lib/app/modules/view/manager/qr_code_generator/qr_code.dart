// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../../../controllers/manager/qr_code_controller.dart';
//
// class QrGeneratorScreen extends StatelessWidget {
//   const QrGeneratorScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(QrGeneratorController());
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 1024;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Code Generator'),
//         centerTitle: true,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(isSmallScreen ? 20 : 40),
//               child: Container(
//                 constraints: const BoxConstraints(maxWidth: 1400),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 30,
//                       offset: const Offset(0, 15),
//                     ),
//                   ],
//                 ),
//                 padding: EdgeInsets.all(isSmallScreen ? 30 : 50),
//                 child: Column(
//                   children: [
//                     _buildHeader(),
//                     const SizedBox(height: 50),
//                     isSmallScreen
//                         ? Column(
//                             children: [
//                               _buildInputSection(controller),
//                               const SizedBox(height: 40),
//                               Obx(
//                                 () => controller.showQr.value
//                                     ? _buildQrDisplay(controller)
//                                     : _buildPlaceholder(),
//                               ),
//                             ],
//                           )
//                         : Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(35),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[50],
//                                     borderRadius: BorderRadius.circular(16),
//                                     border: Border.all(
//                                       color: Colors.grey[200]!,
//                                       width: 2,
//                                     ),
//                                   ),
//                                   child: _buildInputSection(controller),
//                                 ),
//                               ),
//                               const SizedBox(width: 50),
//                               Expanded(
//                                 flex: 3,
//                                 child: Obx(
//                                   () => controller.showQr.value
//                                       ? _buildQrDisplay(controller)
//                                       : _buildPlaceholder(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Column(
//       children: [
//         const Icon(Icons.qr_code_2, size: 80, color: Color(0xFF667eea)),
//         const SizedBox(height: 20),
//         const Text(
//           '🍽️ The Waiter App',
//           style: TextStyle(
//             fontSize: 36,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF333333),
//             letterSpacing: 0.5,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           'Professional QR Code Generator for Restaurant Tables',
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInputSection(QrGeneratorController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Table Configuration',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF333333),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Text(
//           'Enter the table number to generate a unique QR code',
//           style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//         ),
//         const SizedBox(height: 30),
//
//         // Table Number Input
//         TextField(
//           controller: controller.tableNumberController,
//           keyboardType: TextInputType.number,
//           style: const TextStyle(fontSize: 18),
//           decoration: InputDecoration(
//             labelText: 'Table Number',
//             labelStyle: const TextStyle(fontSize: 16),
//             hintText: 'e.g., 167',
//             prefixIcon: const Icon(
//               Icons.table_restaurant,
//               color: Color(0xFF667eea),
//               size: 28,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
//             ),
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 20,
//             ),
//           ),
//           onChanged: (value) => controller.updateUrl(),
//         ),
//         const SizedBox(height: 30),
//
//         // Generate Button
//         SizedBox(
//           width: double.infinity,
//           height: 55,
//           child: ElevatedButton.icon(
//             onPressed: controller.generateQr,
//             icon: const Icon(Icons.refresh, size: 24),
//             label: const Text(
//               'Generate QR Code',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               backgroundColor: const Color(0xFF667eea),
//               foregroundColor: Colors.white,
//               elevation: 2,
//             ),
//           ),
//         ),
//         const SizedBox(height: 40),
//
//         // Testing Section
//         Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.blue[50],
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.blue[200]!),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.science, color: Colors.blue[700], size: 22),
//                   const SizedBox(width: 10),
//                   Text(
//                     'Usage Guide',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[900],
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 '• Download QR codes for each table\n'
//                 '• Print and laminate for durability\n'
//                 '• Display at table locations\n'
//                 '• Customers scan to open menu',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.blue[800],
//                   height: 1.8,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildQrDisplay(QrGeneratorController controller) {
//     return Container(
//       padding: const EdgeInsets.all(40),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.grey[50]!, Colors.grey[100]!],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFF667eea), width: 3),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF667eea).withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // QR Code Header
//           Text(
//             'Table ${controller.tableNumberController.text}',
//             style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF333333),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'Scan to Order',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 30),
//
//           // QR Code Display
//           RepaintBoundary(
//             key: controller.qrKey,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(30),
//               child: QrImageView(
//                 data: controller.generatedUrl.value,
//                 version: QrVersions.auto,
//                 size: 320.0,
//                 backgroundColor: Colors.white,
//                 errorCorrectionLevel: QrErrorCorrectLevel.H,
//                 embeddedImage: null,
//                 embeddedImageStyle: const QrEmbeddedImageStyle(
//                   size: Size(60, 60),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 25),
//
//           // URL Display
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.grey[300]!),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.link, color: Colors.grey[600], size: 18),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Generated URL',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 SelectableText(
//                   controller.generatedUrl.value,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey[700],
//                     fontFamily: 'monospace',
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 30),
//
//           // Download Button
//           SizedBox(
//             width: double.infinity,
//             height: 55,
//             child: Obx(
//               () => ElevatedButton.icon(
//                 onPressed: controller.isGenerating.value
//                     ? null
//                     : controller.downloadQr,
//                 icon: controller.isGenerating.value
//                     ? const SizedBox(
//                         width: 22,
//                         height: 22,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.5,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.white,
//                           ),
//                         ),
//                       )
//                     : const Icon(Icons.download, size: 24),
//                 label: Text(
//                   controller.isGenerating.value
//                       ? 'Downloading...'
//                       : 'Download QR Code',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   backgroundColor: const Color(0xFF764ba2),
//                   foregroundColor: Colors.white,
//                   elevation: 2,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           // Info Note
//           Container(
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: Colors.amber[50],
//               border: Border.all(color: Colors.amber[700]!, width: 2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.info_outline, color: Colors.amber[700], size: 24),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'Customers can scan this QR code to open table ${controller.tableNumberController.text} menu in The Waiter app',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.amber[900],
//                       height: 1.5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Placeholder Widget (When no QR is generated)
//   Widget _buildPlaceholder() {
//     return Container(
//       padding: const EdgeInsets.all(60),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.grey[300]!,
//           width: 2,
//           style: BorderStyle.solid,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.qr_code_scanner, size: 120, color: Colors.grey[400]),
//           const SizedBox(height: 30),
//           Text(
//             'No QR Code Generated',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 15),
//           Text(
//             'Enter a table number and click\n"Generate QR Code" to create',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[500],
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../controllers/manager/qr_code_controller.dart';

class QrGeneratorScreen extends StatelessWidget {
  const QrGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QrGeneratorController());

    return Scaffold(
      body: Column(
        children: [
          // Compact Fixed Header
          _buildAppBar(),

          // Main Content (No Scroll)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Panel - Input Section
                  Expanded(
                    flex: 2,
                    child: _buildInputSection(controller),
                  ),
                  const SizedBox(width: 24),

                  // Right Panel - QR Display
                  Expanded(
                    flex: 3,
                    child: Obx(() => controller.showQr.value
                        ? _buildQrDisplay(controller)
                        : _buildPlaceholder()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Icon(Icons.qr_code_2, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          const Text(
            '🍽️ The Waiter App - QR Code Generator',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(QrGeneratorController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Table Configuration',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate QR code for restaurant tables',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Table Number Input
          Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                controller.generateQr();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: TextField(
              controller: controller.tableNumberController,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 3,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Table Number',
                labelStyle: const TextStyle(fontSize: 14),
                hintText: 'e.g., 167',
                counterText: '',
                prefixIcon: const Icon(
                  Icons.table_restaurant,
                  color: Color(0xFF667eea),
                  size: 22,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              onChanged: (value) => controller.updateUrl(),
            ),
          ),
          const SizedBox(height: 20),

          // Generate Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: controller.generateQr,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Generate QR Code',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Compact Usage Guide
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Usage Guide',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Download QR codes for each table\n'
                      '• Print and laminate for durability\n'
                      '• Display at table locations\n'
                      '• Customers scan to open menu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[800],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrDisplay(QrGeneratorController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[50]!, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF667eea), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // QR Code Header
          Text(
            'Table ${controller.tableNumberController.text}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Scan to Order',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // QR Code Display
          RepaintBoundary(
            key: controller.qrKey,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: QrImageView(
                data: controller.generatedUrl.value,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Compact URL Display
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.link, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Generated URL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SelectableText(
                  controller.generatedUrl.value,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Download Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Obx(
                  () => ElevatedButton.icon(
                onPressed: controller.isGenerating.value
                    ? null
                    : controller.downloadQr,
                icon: controller.isGenerating.value
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
                    : const Icon(Icons.download, size: 20),
                label: Text(
                  controller.isGenerating.value
                      ? 'Downloading...'
                      : 'Download QR Code',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF764ba2),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  disabledBackgroundColor: Colors.grey[400],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Compact Info Note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              border: Border.all(color: Colors.amber[700]!, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber[700], size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Scan to open table ${controller.tableNumberController.text} menu',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber[900],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'No QR Code Generated',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Enter a table number and click\n"Generate QR Code" to create',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
