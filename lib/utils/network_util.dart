import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/service/api.dart';

class NetworkUtils {
  // Global key to access context from anywhere
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  // Track dialog visibility to prevent multiple dialogs
  static bool _isDialogShowing = false;

  // Show reconnect dialog when offline
  static void showReconnectDialog(BuildContext context, {Function? onReconnected}) {
    // Prevent multiple dialogs
    if (_isDialogShowing) return;
    _isDialogShowing = true;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.signal_wifi_off, color: Colors.red),
              SizedBox(width: 10),
              Text(
                'Tidak Ada Koneksi Internet',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aplikasi membutuhkan koneksi internet untuk menampilkan data terbaru. Silakan cek koneksi internet Anda dan coba lagi.',
                style: GoogleFonts.roboto(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Data yang ditampilkan mungkin tidak terbaru.',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isDialogShowing = false;
              },
              child: Text(
                'Gunakan Data Lokal',
                style: GoogleFonts.poppins(
                  color: WADarkColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Check connectivity again
                bool isOnline = await Api().isOnline();
                if (isOnline) {
                  // If we're back online, refresh data
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Koneksi internet tersedia. Memuat data terbaru...'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Call the callback if provided
                  if (onReconnected != null) {
                    onReconnected();
                  }
                } else {
                  // Still offline, show the dialog again
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Masih tidak ada koneksi internet. Menggunakan data lokal.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
                _isDialogShowing = false;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: WAPrimaryColor1,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Coba Lagi',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show offline banner with reconnect button
  static Widget buildOfflineBanner({Function? onReconnect}) {
    return Builder(
      builder: (context) => Container(
        width: double.infinity,
        color: Colors.orange.shade200,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.cloud_off, size: 18, color: Colors.orange.shade800),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Mode Offline. Menampilkan data lokal.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                bool isOnline = await Api().isOnline();
                if (!isOnline) {
                  showReconnectDialog(
                    context,
                    onReconnected: onReconnect,
                  );
                } else if (onReconnect != null) {
                  // Already online, just refresh
                  onReconnect();
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange.shade100,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                minimumSize: Size(0, 24),
              ),
              child: Text(
                'Hubungkan',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Check if network is available, if not show the dialog
  static Future<bool> checkNetworkAndShowDialog(BuildContext context, {Function? onReconnected}) async {
    bool isOnline = await Api().isOnline();
    if (!isOnline) {
      showReconnectDialog(context, onReconnected: onReconnected);
      return false;
    }
    return true;
  }

  // Auto-retry mechanism for network operations
  static Future<T?> withRetry<T>(
    Future<T> Function() operation,
    BuildContext context, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
    bool showDialogOnFailure = true,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        bool isOnline = await Api().isOnline();
        if (!isOnline) {
          if (showDialogOnFailure && attempts == 0) {
            // Only show dialog on first attempt
            showReconnectDialog(context);
          }
          throw Exception('No internet connection');
        }
        
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          if (showDialogOnFailure) {
            // Show a different message on final failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal terhubung ke server. Menggunakan data lokal.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return null;
        }
        
        // Wait before retrying
        await Future.delayed(delay);
      }
    }
    
    return null;
  }
  
  // Create a network-aware widget builder that automatically shows
  // offline banner when network is unavailable
  static Widget networkAwareBuilder({
    required Widget Function(BuildContext) builder,
    Function? onReconnect,
  }) {
    return StreamBuilder<bool>(
      stream: NetworkStatusService().networkStatusStream,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        
        return Column(
          children: [
            if (!isOnline) buildOfflineBanner(onReconnect: onReconnect),
            Expanded(child: builder(context)),
          ],
        );
      },
    );
  }
}

// Network status service to monitor connectivity changes
class NetworkStatusService {
  static final NetworkStatusService _instance = NetworkStatusService._internal();
  factory NetworkStatusService() => _instance;
  NetworkStatusService._internal();
  
  Stream<bool> get networkStatusStream => 
    Stream.periodic(Duration(seconds: 5))
      .asyncMap((_) => Api().isOnline());
}