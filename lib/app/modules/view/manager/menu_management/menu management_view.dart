import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_waiter/app/modules/view/manager/menu_management/widget/menu_m_filterbar.dart';
import 'package:the_waiter/app/modules/view/manager/menu_management/widget/menu_m_header.dart';
import 'package:the_waiter/app/modules/view/manager/menu_management/widget/menu_m_menu.dart';
import '../../../../core/widgets/ui_state.dart';
import '../manager.controller/menu_controller.dart';

class MenuManagementView extends StatelessWidget {
  const MenuManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller once
    final ManagerMenuController controller = Get.put(ManagerMenuController());

    return Column(
      children: [
        buildHeader(context),
        buildFiltersBar(context),
        Expanded(
          child: AsyncStateBuilder<ManagerMenuController>(
            controller: controller,
            isLoading: controller.isLoading,
            errorMessage: controller.errorMessage,
            isEmpty: (controller) => controller.filteredItems.isEmpty,
            observeData: [
              controller.filteredItems,
              controller.selectedCategory,
              controller.searchQuery,
            ],
            loadingText: 'Loading menu items...',
            emptyStateText: 'No Menu Items Found',
            onRetry: controller.loadMenuItems,
            onRefresh: () async {
              controller.loadMenuItems();
              controller.loadCategories();
            },
            builder: (_) => MenuGridView(),
          ),
        ),
      ],
    );
  }
}
