
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_toggle.dart';
import '../../../../core/theme/app_theme.dart';
import '../../user/user_dashboard.dart';
import '../menu_management/menu management_view.dart';
import '../qr_code_generator/qr_code.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});
  final selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar - Fixed width (like LoginScreen's left panel)
          Container(
            width: 280,
            color: isDark ? AppTheme.darkSurface : const Color(0xFF1E293B),
            child: Column(
              children: [
                // Logo/Header
                Container(
                  height: 80,
                  padding: EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restaurant,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Restaurant',
                          style: TextStyle(
                            color: isDark ? AppTheme.darkTextPrimary : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  color: isDark ? const Color(0xFF3D4A5C) : Colors.white24,
                  height: 1,
                ),

                // Menu Items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildMenuItem(0, Icons.dashboard, 'Dashboard', isDark),
                      _buildMenuItem(1, Icons.restaurant_menu, 'Menu Management', isDark),
                      _buildMenuItem(2, Icons.qr_code_2, 'QR Generator', isDark),
                      _buildMenuItem(3, Icons.insert_invitation, 'Item', isDark),
                      _buildMenuItem(7, Icons.settings, 'Settings', isDark),
                    ],
                  ),
                ),

                // User Profile
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark ? const Color(0xFF3D4A5C) : Colors.white24,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primary,
                        child: Text(
                          'HO',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Hotel Owner',
                              style: TextStyle(
                                color: isDark ? AppTheme.darkTextPrimary : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              'owner@hotel.com',
                              style: TextStyle(
                                color: isDark ? AppTheme.darkTextSecondary : Colors.white70,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area (like LoginScreen's right panel)
          Expanded(
            child: Obx(() {
              switch (selectedIndex.value) {
                case 0:
                  return DashboardHomeView();
                case 1:
                  return MenuManagementView();
                case 2:
                  return QrGeneratorScreen();
                  case 3:
                  return UserDashboard();
                default:
                  return DashboardHomeView();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String title, bool isDark) {
    return Obx(
          () => ListTile(
        leading: Icon(
          icon,
          color: selectedIndex.value == index
              ? AppTheme.primary
              : (isDark ? AppTheme.darkTextSecondary : Colors.white70),
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selectedIndex.value == index
                ? (isDark ? AppTheme.darkTextPrimary : Colors.white)
                : (isDark ? AppTheme.darkTextSecondary : Colors.white70),
            fontWeight: selectedIndex.value == index
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        selected: selectedIndex.value == index,
        selectedTileColor: AppTheme.primary.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        onTap: () => selectedIndex.value = index,
      ),
    );
  }
}

// ============================================
// DASHBOARD HOME VIEW - PROPER WEB LAYOUT
// ============================================

class DashboardHomeView extends StatelessWidget {
  const DashboardHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? AppTheme.darkBackground : AppTheme.background,
      child: Column(
        children: [
          // Header
          _buildHeader(context),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards - 4 columns
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '₹45,230',
                          'Total Revenue',
                          Icons.trending_up,
                          AppTheme.success,
                          '+12.5%',
                          isDark,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: _buildStatCard(
                          '156',
                          'Orders Today',
                          Icons.shopping_bag,
                          AppTheme.secondary,
                          '+8 new',
                          isDark,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: _buildStatCard(
                          '12/20',
                          'Active Tables',
                          Icons.table_bar,
                          AppTheme.warning,
                          '60% occupied',
                          isDark,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: _buildStatCard(
                          '48',
                          'Menu Items',
                          Icons.restaurant_menu,
                          AppTheme.accent,
                          '5 special',
                          isDark,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  // Quick Access Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurface : AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Access',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickActionCard(
                                'Manage Menu',
                                Icons.restaurant_menu,
                                AppTheme.primary,
                                isDark,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _buildQuickActionCard(
                                'View Orders',
                                Icons.list_alt,
                                AppTheme.secondary,
                                isDark,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _buildQuickActionCard(
                                'Table Status',
                                Icons.table_bar,
                                AppTheme.success,
                                isDark,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _buildQuickActionCard(
                                'Staff Schedule',
                                Icons.people,
                                AppTheme.accent,
                                isDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Welcome back! Here\'s what\'s happening today.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                ),
              ),
            ],
          ),

          // Theme Toggle
          ThemeToggleButton(),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String value,
      String title,
      IconData icon,
      Color color,
      String subtitle,
      bool isDark,
      ) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      String title,
      IconData icon,
      Color color,
      bool isDark,
      ) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}