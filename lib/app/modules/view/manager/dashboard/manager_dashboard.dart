import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../menu_management/menu management_view.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});
  final selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar - Fixed width
          _buildSidebar(),

          // Main Content - Takes remaining space
          Expanded(
            child: Obx(() {
              switch (selectedIndex.value) {
                case 0:
                  return DashboardHomeView();
                case 1:
                  return MenuManagementView();
                default:
                  return DashboardHomeView();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280, // Increased width for better text spacing
      color: Color(0xFF1E293B),
      child: Column(
        children: [
          // Logo/Header - Fixed height
          Container(
            height: 80,
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(Icons.restaurant, color: Colors.orange, size: 32),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Restaurant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: Colors.white24, height: 1),

          // Menu Items - Scrollable
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(0, Icons.dashboard, 'Dashboard'),
                _buildMenuItem(1, Icons.restaurant_menu, 'Menu Management'),
                _buildMenuItem(2, Icons.shopping_bag, 'Orders'),
                _buildMenuItem(3, Icons.table_bar, 'Tables'),
                _buildMenuItem(4, Icons.people, 'Staff'),
                _buildMenuItem(5, Icons.inventory, 'Inventory'),
                _buildMenuItem(6, Icons.analytics, 'Reports'),
                _buildMenuItem(7, Icons.settings, 'Settings'),
              ],
            ),
          ),

          // User Profile - Fixed at bottom
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white24)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text('HO', style: TextStyle(color: Colors.white)),
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'owner@hotel.com',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
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
    );
  }

  Widget _buildMenuItem(int index, IconData icon, String title) {
    return Obx(
      () => ListTile(
        leading: Icon(
          icon,
          color: selectedIndex.value == index ? Colors.orange : Colors.white70,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selectedIndex.value == index ? Colors.white : Colors.white70,
            fontWeight: selectedIndex.value == index
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        selected: selectedIndex.value == index,
        selectedTileColor: Colors.orange.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        onTap: () => selectedIndex.value = index,
      ),
    );
  }
}

// ============================================
// DASHBOARD HOME VIEW - RESPONSIVE WEB LAYOUT
// ============================================

class DashboardHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF1F5F9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Fixed height
          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Stats Cards Row
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate card width based on available space
                      final cardWidth = (constraints.maxWidth - 48) / 4;

                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Revenue',
                              '₹45,230',
                              Icons.trending_up,
                              Colors.green,
                              '+12.5%',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Orders Today',
                              '156',
                              Icons.shopping_bag,
                              Colors.blue,
                              '+8 new',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Active Tables',
                              '12/20',
                              Icons.table_bar,
                              Colors.orange,
                              '60% occupied',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Menu Items',
                              '48',
                              Icons.restaurant_menu,
                              Colors.purple,
                              '5 special',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24),

                  // Quick Access Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Access',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildQuickActionCard(
                              'Manage Menu',
                              Icons.restaurant_menu,
                              Colors.orange,
                            ),
                            _buildQuickActionCard(
                              'View Orders',
                              Icons.list_alt,
                              Colors.blue,
                            ),
                            _buildQuickActionCard(
                              'Table Status',
                              Icons.table_bar,
                              Colors.green,
                            ),
                            _buildQuickActionCard(
                              'Staff Schedule',
                              Icons.people,
                              Colors.purple,
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
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dashboard Overview',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Welcome back! Here\'s what\'s happening today.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {},
                tooltip: 'Notifications',
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text('Quick Action'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      constraints: BoxConstraints(minHeight: 150),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 180,
        height: 120,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
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
