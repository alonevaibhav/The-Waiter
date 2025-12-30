
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_toggle.dart';
import '../../../core/widgets/ui_state.dart';
import '../../../route/app_routes.dart';
import 'api_cache_storage.dart';
import 'controller.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    Get.put(ApiCacheStorage());
    final controller = Get.put(UsersController());
    final connectivityController = Get.find<ConnectivityController>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
        title: Text(
          'Users Directory',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          // Cache Status Indicator
          Obx(() {
            if (controller.isFromCache.value) {
              return Padding(
                padding: EdgeInsets.only(right: AppTheme.space8),
                child: Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.storage, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'CACHED',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.orange.shade600,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
              );
            }
            return SizedBox.shrink();
          }),

          // Connectivity Status Indicator
          Obx(() => Padding(
            padding: EdgeInsets.only(right: AppTheme.space8),
            child: Center(
              child: _buildConnectivityIndicator(
                context,
                connectivityController,
                isDark,
              ),
            ),
          )),

          // Cache Menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'cache_info':
                  _showCacheInfo(context, controller);
                  break;
                case 'clear_cache':
                  _showClearCacheDialog(context, controller);
                  break;
                case 'force_refresh':
                  controller.fetchUsers(forceRefresh: true);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'cache_info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Cache Info'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_cache',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, size: 20),
                    SizedBox(width: 12),
                    Text('Clear Cache'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'force_refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 12),
                    Text('Force Refresh'),
                  ],
                ),
              ),
            ],
          ),

          ThemeToggleIconButton(),
        ],
      ),
      body: AsyncStateBuilder<UsersController>(
        controller: controller,
        isLoading: controller.isLoading,
        errorMessage: controller.errorMessage,
        isEmpty: (ctrl) => ctrl.users.isEmpty,
        onRetry: controller.refreshUsers,
        onRefresh: controller.refreshUsers,
        observeData: [controller.users],
        scaleFactor: 0.85,
        loadingText: 'Loading users...',
        emptyStateText: 'No Users Found',
        errorTitle: 'Failed to Load Users',
        builder: (ctrl) {
          return Column(
            children: [
              // Connectivity Test Panel
              _buildConnectivityTestPanel(context, connectivityController, isDark),

              // Cache Status Banner (when showing cached data)
              Obx(() {
                if (ctrl.isFromCache.value) {
                  return _buildCacheBanner(context, controller, isDark);
                }
                return SizedBox.shrink();
              }),

              // Offline Banner
              Obx(() {
                if (!connectivityController.isConnected) {
                  return _buildOfflineBanner(context, isDark);
                }
                return SizedBox.shrink();
              }),

              ElevatedButton(
                onPressed: () {
                  // NavigationService.pushToPermission();
                  null;
                },
                child: const Text('Go to Permission'),
              ),

              // User List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(AppTheme.space16),
                  itemCount: ctrl.users.length,
                  itemBuilder: (context, index) {
                    return _buildUserCard(
                      context,
                      ctrl.users[index],
                      index,
                      isDark,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // Floating Action Button
      floatingActionButton: Obx(() {
        if (controller.isFromCache.value) {
          // Show refresh button when viewing cached data
          return FloatingActionButton.extended(
            onPressed: () => controller.fetchUsers(forceRefresh: true),
            icon: Icon(Icons.refresh),
            label: Text('Refresh Now'),
            backgroundColor: Colors.orange,
          );
        } else {
          // Show test connection button when showing live data
          return FloatingActionButton.extended(
            onPressed: () => _showConnectivityTestDialog(
              context,
              connectivityController,
              isDark,
            ),
            icon: Icon(Icons.wifi_find),
            label: Text('Test Connection'),
            backgroundColor: AppTheme.primary,
          );
        }
      }),
    );
  }
















  // ==========================================
  // CACHE STATUS BANNER
  // ==========================================

  Widget _buildCacheBanner(
      BuildContext context,
      UsersController controller,
      bool isDark,
      ) {
    final cacheInfo = controller.getCacheInfo();
    final cacheAge = cacheInfo['cache_age_minutes'] as int;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.space16,
        vertical: AppTheme.space12,
      ),
      color: Colors.orange.shade100,
      child: Row(
        children: [
          Icon(Icons.storage, color: Colors.orange.shade800, size: 20),
          SizedBox(width: AppTheme.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Viewing Cached Data',
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Cached $cacheAge ${cacheAge == 1 ? 'minute' : 'minutes'} ago',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => controller.fetchUsers(forceRefresh: true),
            icon: Icon(Icons.refresh, size: 16, color: Colors.orange.shade900),
            label: Text(
              'Refresh',
              style: TextStyle(color: Colors.orange.shade900),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // OFFLINE BANNER
  // ==========================================

  Widget _buildOfflineBanner(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.space12),
      color: Colors.red.shade600,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 18),
          SizedBox(width: AppTheme.space8),
          Text(
            'No Internet Connection',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CACHE INFO DIALOG
  // ==========================================

  void _showCacheInfo(BuildContext context, UsersController controller) {
    final cacheInfo = controller.getCacheInfo();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
        title: Row(
          children: [
            Icon(Icons.storage, color: AppTheme.primary),
            SizedBox(width: 12),
            Text('Cache Information'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Has Cache:', cacheInfo['has_cache'].toString(), isDark),
            SizedBox(height: 8),
            _buildInfoRow('Users Count:', cacheInfo['users_count'].toString(), isDark),
            SizedBox(height: 8),
            _buildInfoRow(
              'Cache Age:',
              '${cacheInfo['cache_age_minutes']} minutes',
              isDark,
            ),
            SizedBox(height: 8),
            _buildInfoRow('Is Fresh:', cacheInfo['is_fresh'].toString(), isDark),
            SizedBox(height: 8),
            if (cacheInfo['cached_at'] != null)
              _buildInfoRow('Cached At:', cacheInfo['cached_at'], isDark),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              controller.clearCache();
            },
            icon: Icon(Icons.delete_sweep, size: 18),
            label: Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // CLEAR CACHE DIALOG
  // ==========================================

  void _showClearCacheDialog(BuildContext context, UsersController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 12),
            Text('Clear Cache'),
          ],
        ),
        content: Text(
          'Are you sure you want to clear the users cache? This will fetch fresh data from the server.',
          style: TextStyle(
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              controller.clearCache();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  // Connectivity Indicator in AppBar
  Widget _buildConnectivityIndicator(
      BuildContext context,
      ConnectivityController controller,
      bool isDark,
      ) {
    return GestureDetector(
      onTap: () => _showConnectivityTestDialog(context, controller, isDark),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.space12,
          vertical: AppTheme.space8,
        ),
        decoration: BoxDecoration(
          color: controller.isConnected
              ? AppTheme.success.withOpacity(0.1)
              : AppTheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: controller.isConnected ? AppTheme.success : AppTheme.error,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              controller.isConnected ? Icons.wifi : Icons.wifi_off,
              size: 16,
              color: controller.isConnected ? AppTheme.success : AppTheme.error,
            ),
            SizedBox(width: AppTheme.space4),
            Text(
              controller.isConnected ? 'Online' : 'Offline',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: controller.isConnected ? AppTheme.success : AppTheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Connectivity Test Panel (Collapsible)
  Widget _buildConnectivityTestPanel(
      BuildContext context,
      ConnectivityController controller,
      bool isDark,
      ) {
    return Obx(() => Container(
      margin: EdgeInsets.all(AppTheme.space16),
      padding: EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: isDark ? AppTheme.darkShadowMedium : AppTheme.shadowMedium,
        border: Border.all(
          color: controller.isConnected
              ? AppTheme.success.withOpacity(0.3)
              : AppTheme.error.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                controller.isConnected ? Icons.check_circle : Icons.error,
                color: controller.isConnected ? AppTheme.success : AppTheme.error,
                size: 28,
              ),
              SizedBox(width: AppTheme.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.isConnected
                          ? 'Connected to Internet'
                          : 'No Internet Connection',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: controller.isConnected
                            ? AppTheme.success
                            : AppTheme.error,
                      ),
                    ),
                    Text(
                      controller.getConnectionType(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isCheckingConnection)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                  ),
                ),
            ],
          ),

          if (controller.isConnected) ...[
            SizedBox(height: AppTheme.space12),
            Divider(color: isDark ? const Color(0xFF3D4A5C) : const Color(0xFFE2E8F0)),
            SizedBox(height: AppTheme.space12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusChip(
                  context,
                  'Speed',
                  controller.connectionSpeed > 0
                      ? '${controller.connectionSpeed.toStringAsFixed(0)}ms'
                      : 'Testing...',
                  Icons.speed,
                  AppTheme.info,
                  isDark,
                ),
                _buildStatusChip(
                  context,
                  'Quality',
                  controller.getConnectionQuality(),
                  Icons.signal_cellular_alt,
                  controller.isSlowConnection ? AppTheme.warning : AppTheme.success,
                  isDark,
                ),
              ],
            ),
          ],

          SizedBox(height: AppTheme.space12),

          // Test Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.isCheckingConnection
                      ? null
                      : () async {
                    print('🔵 Test Now button pressed');
                    await controller.checkConnection(showSnackbar: true);
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Test Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: EdgeInsets.symmetric(vertical: AppTheme.space12),
                  ),
                ),
              ),
              SizedBox(width: AppTheme.space8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDetailedInfo(context, controller, isDark);
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primary),
                    padding: EdgeInsets.symmetric(vertical: AppTheme.space12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildStatusChip(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
      bool isDark,
      ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(height: AppTheme.space4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Detailed Connectivity Info Dialog
  void _showDetailedInfo(
      BuildContext context,
      ConnectivityController controller,
      bool isDark,
      ) {
    final info = controller.getConnectionInfo();

    Get.dialog(
      Dialog(
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.network_check, color: AppTheme.primary, size: 28),
                  SizedBox(width: AppTheme.space12),
                  Text(
                    'Connection Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.space24),

              ...info.entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppTheme.space12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppTheme.darkTextSecondary
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      SizedBox(width: AppTheme.space8),
                      Expanded(
                        child: Text(
                          entry.value.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              SizedBox(height: AppTheme.space16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quick Test Dialog
  void _showConnectivityTestDialog(
      BuildContext context,
      ConnectivityController controller,
      bool isDark,
      ) {
    Get.dialog(
      Dialog(
        backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_find,
                size: 64,
                color: AppTheme.primary,
              ),
              SizedBox(height: AppTheme.space16),
              Text(
                'Connectivity Test',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppTheme.space8),
              Obx(() => Text(
                controller.isConnected ? 'You are online' : 'You are offline',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: controller.isConnected ? AppTheme.success : AppTheme.error,
                ),
              )),
              SizedBox(height: AppTheme.space24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    print('🔵 Run Test button pressed');
                    Get.back();
                    await controller.checkConnection(showSnackbar: true);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Run Test'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
              SizedBox(height: AppTheme.space12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.back();
                    _showDetailedInfo(context, controller, isDark);
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primary),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // User Card Widget
  Widget _buildUserCard(BuildContext context, UserModel user, int index, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.space16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: isDark ? AppTheme.darkShadowMedium : AppTheme.shadowMedium,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          onTap: () => _showUserDetails(context, user, isDark),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.space16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Profile Picture with Status
                    Stack(
                      children: [
                        Hero(
                          tag: 'user_${user.id}',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: user.gender == 'male'
                                    ? AppTheme.secondary
                                    : AppTheme.accent,
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(user.profilePic),
                              backgroundColor: isDark
                                  ? AppTheme.darkSurfaceVariant
                                  : AppTheme.surfaceVariant,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(AppTheme.space4),
                            decoration: BoxDecoration(
                              color: user.isRegister
                                  ? AppTheme.success
                                  : AppTheme.error,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? AppTheme.darkSurface : AppTheme.surface,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              user.isRegister ? Icons.check : Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: AppTheme.space16),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: AppTheme.space8),
                              _buildGenderBadge(context, user.gender, isDark),
                            ],
                          ),
                          SizedBox(height: AppTheme.space4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: isDark
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.textSecondary,
                              ),
                              SizedBox(width: AppTheme.space4),
                              Expanded(
                                child: Text(
                                  user.location,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? AppTheme.darkTextSecondary
                                        : AppTheme.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppTheme.space4),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: 14,
                                color: isDark
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.textSecondary,
                              ),
                              SizedBox(width: AppTheme.space4),
                              Expanded(
                                child: Text(
                                  user.car,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppTheme.darkTextTertiary
                                        : AppTheme.textTertiary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Price Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.space12,
                        vertical: AppTheme.space8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primary, AppTheme.accent],
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Price',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '\$${user.price}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Divider
                Padding(
                  padding: EdgeInsets.symmetric(vertical: AppTheme.space12),
                  child: Divider(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF3D4A5C)
                        : const Color(0xFFE2E8F0),
                  ),
                ),

                // Additional Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoChip(
                      context,
                      Icons.cake_outlined,
                      _formatDate(user.dob),
                      AppTheme.warning,
                      isDark,
                    ),
                    _buildInfoChip(
                      context,
                      Icons.calendar_today,
                      _formatDate(user.createdAt),
                      AppTheme.info,
                      isDark,
                    ),
                    _buildInfoChip(
                      context,
                      user.isRegister ? Icons.verified_user : Icons.pending,
                      user.isRegister ? 'Registered' : 'Pending',
                      user.isRegister ? AppTheme.success : AppTheme.error,
                      isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderBadge(BuildContext context, String gender, bool isDark) {
    final color = gender == 'male' ? AppTheme.secondary : AppTheme.accent;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.space8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.space8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            gender == 'male' ? Icons.male : Icons.female,
            size: 12,
            color: color,
          ),
          SizedBox(width: AppTheme.space4),
          Text(
            gender.capitalize ?? gender,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
      BuildContext context,
      IconData icon,
      String label,
      Color color,
      bool isDark,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        SizedBox(width: AppTheme.space4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  void _showUserDetails(BuildContext context, UserModel user, bool isDark) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusLarge),
          ),
        ),
        padding: EdgeInsets.all(AppTheme.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.darkTextTertiary
                    : AppTheme.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: AppTheme.space24),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.profilePic),
              backgroundColor: isDark
                  ? AppTheme.darkSurfaceVariant
                  : AppTheme.surfaceVariant,
            ),
            SizedBox(height: AppTheme.space16),
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppTheme.space8),
            Text(
              user.location,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: AppTheme.space24),
            _buildDetailRow(context, 'Car', user.car, isDark),
            _buildDetailRow(context, 'Price', '\$${user.price}', isDark),
            _buildDetailRow(context, 'Gender', user.gender.capitalize ?? user.gender, isDark),
            _buildDetailRow(
              context,
              'Status',
              user.isRegister ? 'Registered' : 'Pending',
              isDark,
            ),
            SizedBox(height: AppTheme.space16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context,
      String label,
      String value,
      bool isDark,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}