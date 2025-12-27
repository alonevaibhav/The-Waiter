  import 'dart:async';
  import 'dart:developer' as developer;
  import 'package:connectivity_plus/connectivity_plus.dart';
  import 'package:get/get.dart';
  import 'package:http/http.dart' as http;

  /// Callback types for showing snackbars
  typedef SnackbarCallback = void Function(String message, String title, Duration duration);

  /// GetX Controller to monitor and manage network connectivity
  class ConnectivityController extends GetxController {
    final Connectivity _connectivity = Connectivity();

    // Callbacks for showing different types of snackbars
    SnackbarCallback? onShowError;
    SnackbarCallback? onShowSuccess;
    SnackbarCallback? onShowWarning;
    SnackbarCallback? onShowInfo;

    // Observable variables
    final _connectionStatus = ConnectivityResult.none.obs;
    final _isConnected = false.obs;
    final _isCheckingConnection = false.obs;
    final _isSlowConnection = false.obs;
    final _connectionSpeed = 0.0.obs; // Speed in ms
    final _lastConnectionCheck = DateTime.now().obs;

    // Getters
    ConnectivityResult get connectionStatus => _connectionStatus.value;
    bool get isConnected => _isConnected.value;
    bool get isCheckingConnection => _isCheckingConnection.value;
    bool get isSlowConnection => _isSlowConnection.value;
    double get connectionSpeed => _connectionSpeed.value;
    DateTime get lastConnectionCheck => _lastConnectionCheck.value;

    StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
    Timer? _speedCheckTimer;
    Timer? _debounceTimer;

    // Flags to prevent spam
    bool _hasShownInitialConnection = false;
    bool _hasShownNoInternet = false;
    DateTime? _lastSnackbarTime;

    // Thresholds
    static const int _slowConnectionThreshold = 2000; // 2 seconds
    static const int _verySlowConnectionThreshold = 5000; // 5 seconds
    static const int _timeoutThreshold = 10000; // 10 seconds
    static const int _snackbarCooldown = 3000; // 3 seconds between snackbars
    static const Duration _speedCheckInterval = Duration(seconds: 45);
    static const Duration _debounceDelay = Duration(milliseconds: 500);

    @override
    void onInit() {
      super.onInit();
      _initConnectivity();
      _listenToConnectivityChanges();
    }

    /// Initialize connectivity check
    Future<void> _initConnectivity() async {
      try {
        final results = await _connectivity.checkConnectivity();
        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
        await _updateConnectionStatus(result, showSnackbar: false);

        // Start periodic checks only if connected
        if (_isConnected.value) {
          _startPeriodicSpeedCheck();
        }
      } catch (e) {
        print('Error initializing connectivity: $e');
        _connectionStatus.value = ConnectivityResult.none;
        _isConnected.value = false;
      }
    }

    /// Listen to connectivity changes with debouncing
    void _listenToConnectivityChanges() {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
            (List<ConnectivityResult> results) {
          // Cancel previous debounce timer
          _debounceTimer?.cancel();

          // Debounce rapid changes
          _debounceTimer = Timer(_debounceDelay, () async {
            final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
            await _updateConnectionStatus(result, showSnackbar: true);
          });
        },
      );
    }

    /// Start periodic speed check
    void _startPeriodicSpeedCheck() {
      _speedCheckTimer?.cancel();
      _speedCheckTimer = Timer.periodic(_speedCheckInterval, (timer) async {
        if (_isConnected.value && !_isCheckingConnection.value) {
          await _checkConnectionSpeed(showSnackbar: false);
        }
      });
    }

    /// Stop periodic speed check
    void _stopPeriodicSpeedCheck() {
      _speedCheckTimer?.cancel();
      _speedCheckTimer = null;
    }

    /// Update connection status and verify internet access
    Future<void> _updateConnectionStatus(
        ConnectivityResult result, {
          bool showSnackbar = true,
        }) async {
      final previousConnectionStatus = _isConnected.value;
      final previousResult = _connectionStatus.value;

      _connectionStatus.value = result;

      // Check if there's actual internet access
      if (result != ConnectivityResult.none) {
        _isCheckingConnection.value = true;

        try {
          final hasInternet = await _checkInternetAccess();
          _isConnected.value = hasInternet;
          _lastConnectionCheck.value = DateTime.now();

          if (hasInternet) {
            // Start periodic checks if not already running
            if (_speedCheckTimer == null || !_speedCheckTimer!.isActive) {
              _startPeriodicSpeedCheck();
            }

            // Check connection speed
            await _checkConnectionSpeed(showSnackbar: showSnackbar);

            // Show "Back Online" only if:
            // 1. Previously disconnected
            // 2. Not the initial connection
            // 3. Snackbar is allowed
            if (showSnackbar && !previousConnectionStatus && _hasShownInitialConnection) {
              _showConnectedSnackbar();
            }

            _hasShownInitialConnection = true;
            _hasShownNoInternet = false;
          } else {
            _stopPeriodicSpeedCheck();
            _isSlowConnection.value = false;

            // Only show no internet if not already shown
            if (showSnackbar && !_hasShownNoInternet) {
              _showNoInternetSnackbar();
              _hasShownNoInternet = true;
            }
          }
        } finally {
          _isCheckingConnection.value = false;
        }
      } else {
        _isConnected.value = false;
        _isSlowConnection.value = false;
        _stopPeriodicSpeedCheck();

        // Only show no internet if not already shown
        if (showSnackbar && !_hasShownNoInternet) {
          _showNoInternetSnackbar();
          _hasShownNoInternet = true;
        }
      }
    }

    /// Check actual internet access with multiple fallbacks
    Future<bool> _checkInternetAccess() async {
      final targets = [
        'https://www.google.com',
        'https://www.cloudflare.com',
        'https://1.1.1.1',
      ];

      for (final target in targets) {
        try {
          final response = await http.head(
            Uri.parse(target),
          ).timeout(
            const Duration(seconds: 8),
          );

          if (response.statusCode >= 200 && response.statusCode < 500) {
            return true;
          }
        } catch (e) {
          // Continue to next target
          continue;
        }
      }

      // All targets failed
      return false;
    }

    /// Check connection speed using HTTP request
    Future<void> _checkConnectionSpeed({bool showSnackbar = true}) async {
      if (!_isConnected.value || _isCheckingConnection.value) return;

      try {
        final stopwatch = Stopwatch()..start();

        // Use a lightweight endpoint
        await http.head(
          Uri.parse('https://www.google.com'),
        ).timeout(
          const Duration(seconds: 10),
        );

        stopwatch.stop();
        _connectionSpeed.value = stopwatch.elapsedMilliseconds.toDouble();

        final previousSlowStatus = _isSlowConnection.value;

        // Determine connection quality
        if (_connectionSpeed.value >= _timeoutThreshold) {
          _isSlowConnection.value = true;
          if (showSnackbar && _canShowSnackbar()) {
            _showVerySlowConnectionSnackbar();
          }
        } else if (_connectionSpeed.value >= _verySlowConnectionThreshold) {
          _isSlowConnection.value = true;
          if (showSnackbar && !previousSlowStatus && _canShowSnackbar()) {
            _showVerySlowConnectionSnackbar();
          }
        } else if (_connectionSpeed.value >= _slowConnectionThreshold) {
          _isSlowConnection.value = true;
          if (showSnackbar && !previousSlowStatus && _canShowSnackbar()) {
            _showSlowConnectionSnackbar();
          }
        } else {
          // Connection is good
          if (previousSlowStatus && _isSlowConnection.value) {
            _isSlowConnection.value = false;
            if (showSnackbar && _canShowSnackbar()) {
              showConnectionRestoredInfo();
            }
          } else {
            _isSlowConnection.value = false;
          }
        }
        developer.log(
          'Connection speed: ${_connectionSpeed.value}ms - ${getConnectionQuality()}',
          name: 'ConnectivityController',
        );
      } on TimeoutException {
        _isSlowConnection.value = true;
        if (showSnackbar && _canShowSnackbar()) {
          _showVerySlowConnectionSnackbar();
        }
      } catch (e) {
        print('Error checking connection speed: $e');
        // Don't change slow connection status on error
      }
    }

    /// Check if enough time has passed to show another snackbar (anti-spam)
    bool _canShowSnackbar() {
      if (_lastSnackbarTime == null) {
        _lastSnackbarTime = DateTime.now();
        return true;
      }

      final timeSinceLastSnackbar = DateTime.now().difference(_lastSnackbarTime!).inMilliseconds;

      if (timeSinceLastSnackbar >= _snackbarCooldown) {
        _lastSnackbarTime = DateTime.now();
        return true;
      }

      return false;
    }

    /// Show "No Internet Connection" snackbar
    void _showNoInternetSnackbar() {
      if (!_canShowSnackbar()) return;

      onShowError?.call(
        'Please check your internet connection and try again',
        'No Internet Connection',
        const Duration(seconds: 5),
      );
    }

    /// Show "Connected" snackbar
    void _showConnectedSnackbar() {
      if (!_canShowSnackbar()) return;

      onShowSuccess?.call(
        'You are now connected to the internet',
        'Back Online',
        const Duration(seconds: 3),
      );
    }

    /// Show "Slow Connection" warning
    void _showSlowConnectionSnackbar() {
      if (!_canShowSnackbar()) return;

      onShowWarning?.call(
        'Your internet connection is slow. Some features may not work properly',
        'Slow Connection',
        const Duration(seconds: 4),
      );
    }

    /// Show "Very Slow Connection" warning
    void _showVerySlowConnectionSnackbar() {
      if (!_canShowSnackbar()) return;

      onShowWarning?.call(
        'Your internet is extremely slow. Please check your connection',
        'Very Slow Connection',
        const Duration(seconds: 5),
      );
    }

    /// Show "Connection Unstable" warning
    void showUnstableConnectionWarning() {
      if (!_canShowSnackbar()) return;

      onShowWarning?.call(
        'Your connection is unstable. You may experience interruptions',
        'Unstable Connection',
        const Duration(seconds: 4),
      );
    }

    /// Show "Connection Restored" info
    void showConnectionRestoredInfo() {
      if (!_canShowSnackbar()) return;

      onShowInfo?.call(
        'Your connection quality has improved',
        'Connection Restored',
        const Duration(seconds: 3),
      );
    }

    /// Show "Mobile Data" warning
    void showMobileDataWarning() {
      if (_connectionStatus.value == ConnectivityResult.mobile && _canShowSnackbar()) {
        onShowInfo?.call(
          'You are using mobile data. Large downloads may consume your data',
          'Mobile Data Active',
          const Duration(seconds: 4),
        );
      }
    }

    /// Check if on WiFi
    bool get isOnWiFi => _connectionStatus.value == ConnectivityResult.wifi;

    /// Check if on mobile data
    bool get isOnMobileData => _connectionStatus.value == ConnectivityResult.mobile;

    /// Check if on VPN
    bool get isOnVPN => _connectionStatus.value == ConnectivityResult.vpn;

    /// Get connection quality based on speed
    String getConnectionQuality() {
      if (!_isConnected.value) {
        return 'No Connection';
      }

      if (_connectionSpeed.value == 0) {
        return 'Unknown';
      }

      if (_connectionSpeed.value < 500) {
        return 'Excellent';
      } else if (_connectionSpeed.value < 1000) {
        return 'Very Good';
      } else if (_connectionSpeed.value < 2000) {
        return 'Good';
      } else if (_connectionSpeed.value < 3000) {
        return 'Fair';
      } else if (_connectionSpeed.value < 5000) {
        return 'Poor';
      } else {
        return 'Very Poor';
      }
    }

    /// Manually check connection (for pull-to-refresh, etc.)
    Future<bool> checkConnection({bool showSnackbar = false}) async {
      if (_isCheckingConnection.value) {
        return _isConnected.value;
      }

      _isCheckingConnection.value = true;

      try {
        final results = await _connectivity.checkConnectivity();
        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;

        if (result != ConnectivityResult.none) {
          final hasInternet = await _checkInternetAccess();
          _isConnected.value = hasInternet;
          _lastConnectionCheck.value = DateTime.now();

          if (hasInternet) {
            await _checkConnectionSpeed(showSnackbar: showSnackbar);

            if (showSnackbar) {
              _showConnectedSnackbar();
            }
          } else {
            if (showSnackbar) {
              _showNoInternetSnackbar();
            }
          }

          return hasInternet;
        }

        _isConnected.value = false;

        if (showSnackbar) {
          _showNoInternetSnackbar();
        }

        return false;
      } finally {
        _isCheckingConnection.value = false;
      }
    }

    /// Get connection type as string
    String getConnectionType() {
      switch (_connectionStatus.value) {
        case ConnectivityResult.wifi:
          return 'WiFi';
        case ConnectivityResult.mobile:
          return 'Mobile Data';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        case ConnectivityResult.vpn:
          return 'VPN';
        case ConnectivityResult.bluetooth:
          return 'Bluetooth';
        case ConnectivityResult.other:
          return 'Other';
        case ConnectivityResult.none:
        default:
          return 'No Connection';
      }
    }

    /// Get detailed connection info
    Map<String, dynamic> getConnectionInfo() {
      return {
        'isConnected': _isConnected.value,
        'connectionType': getConnectionType(),
        'speed': _connectionSpeed.value > 0
            ? '${_connectionSpeed.value.toStringAsFixed(0)}ms'
            : 'Unknown',
        'quality': getConnectionQuality(),
        'isSlowConnection': _isSlowConnection.value,
        'isOnWiFi': isOnWiFi,
        'isOnMobileData': isOnMobileData,
        'isOnVPN': isOnVPN,
        'lastCheck': _lastConnectionCheck.value.toIso8601String(),
      };
    }

    /// Reset connection state (useful for debugging)
    void resetConnectionState() {
      _hasShownInitialConnection = false;
      _hasShownNoInternet = false;
      _lastSnackbarTime = null;
    }

    @override
    void onClose() {
      _connectivitySubscription?.cancel();
      _speedCheckTimer?.cancel();
      _debounceTimer?.cancel();
      super.onClose();
    }
  }