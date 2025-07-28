import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';

class ErrorLoggingService {
  static final ErrorLoggingService _instance = ErrorLoggingService._internal();
  factory ErrorLoggingService() => _instance;
  ErrorLoggingService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Error types constants
  static const String SERVER_ERROR = 'server_error';
  static const String NETWORK_ERROR = 'network_error';
  static const String TIMEOUT_ERROR = 'timeout_error';
  static const String UNKNOWN_ERROR = 'unknown_error';
  static const String UPLOAD_ERROR = 'upload_error';
  static const String AUTH_ERROR = 'auth_error';
  static const String VALIDATION_ERROR = 'validation_error';

  /// Log error to Firebase Firestore and Crashlytics
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    Map<String, dynamic>? requestData,
    String? responseBody,
    int? statusCode,
    String? stackTrace,
    Map<String, dynamic>? additionalData,
    String? feature, // Feature where error occurred (e.g., 'upload', 'login', 'otp')
  }) async {
    try {
      final userId = await SessionHelper.getId();
      final userName = await SessionHelper.getName();
      
      final errorData = {
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
        'userName': userName,
        'errorType': errorType,
        'errorMessage': errorMessage,
        'statusCode': statusCode,
        'responseBody': responseBody,
        'stackTrace': stackTrace,
        'feature': feature,
        'requestData': requestData,
        'additionalData': additionalData,
        'deviceInfo': {
          'platform': Platform.operatingSystem,
          'platformVersion': Platform.operatingSystemVersion,
          'locale': Platform.localeName,
        },
        'appInfo': {
          'version': '1.0.0', // Static version for now
          'buildNumber': '1',
          'packageName': 'com.example.cacoon_mobile',
        },
      };

      // Save to Firestore
      await _firestore.collection('app_errors').add(errorData);
      
      // Also log to Crashlytics for monitoring
      await _crashlytics.recordError(
        errorMessage,
        stackTrace != null ? StackTrace.fromString(stackTrace) : null,
        fatal: false,
      );
      
      // Set custom keys for better analysis in Crashlytics
      await _setCustomKeys({
        'errorType': errorType,
        'statusCode': statusCode?.toString() ?? 'null',
        'userId': userId.toString(),
        'feature': feature ?? 'unknown',
        'platform': Platform.operatingSystem,
        'appVersion': '1.0.0',
      });
      
      print('✅ Error logged to Firebase successfully');
    } catch (e) {
      print('❌ Failed to log error to Firebase: $e');
      // Fallback: at least try to log to Crashlytics
      await _fallbackCrashlyticsLog(errorMessage, errorType);
    }
  }

  /// Log upload-specific errors
  Future<void> logUploadError({
    required String errorMessage,
    required Map<String, dynamic> requestData,
    String? responseBody,
    int? statusCode,
    String? stackTrace,
  }) async {
    await logError(
      errorType: statusCode != null && statusCode >= 500 ? SERVER_ERROR : UPLOAD_ERROR,
      errorMessage: errorMessage,
      requestData: requestData,
      responseBody: responseBody,
      statusCode: statusCode,
      stackTrace: stackTrace,
      feature: 'upload',
    );
  }

  /// Log authentication errors
  Future<void> logAuthError({
    required String errorMessage,
    String? feature,
    Map<String, dynamic>? additionalData,
  }) async {
    await logError(
      errorType: AUTH_ERROR,
      errorMessage: errorMessage,
      feature: feature ?? 'auth',
      additionalData: additionalData,
    );
  }

  /// Log network connectivity errors
  Future<void> logNetworkError({
    required String errorMessage,
    String? feature,
    Map<String, dynamic>? requestData,
  }) async {
    await logError(
      errorType: NETWORK_ERROR,
      errorMessage: errorMessage,
      feature: feature,
      requestData: requestData,
    );
  }

  /// Log timeout errors
  Future<void> logTimeoutError({
    required String errorMessage,
    String? feature,
    Map<String, dynamic>? requestData,
  }) async {
    await logError(
      errorType: TIMEOUT_ERROR,
      errorMessage: errorMessage,
      feature: feature,
      requestData: requestData,
    );
  }

  /// Log validation errors
  Future<void> logValidationError({
    required String errorMessage,
    String? feature,
    Map<String, dynamic>? formData,
  }) async {
    await logError(
      errorType: VALIDATION_ERROR,
      errorMessage: errorMessage,
      feature: feature,
      additionalData: {'formData': formData},
    );
  }

  /// Determine error type from exception
  String determineErrorType(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('timeout')) {
      return TIMEOUT_ERROR;
    } else if (errorString.contains('socketexception') || 
               errorString.contains('network') ||
               errorString.contains('connection')) {
      return NETWORK_ERROR;
    } else if (errorString.contains('unauthorized') ||
               errorString.contains('authentication') ||
               errorString.contains('token')) {
      return AUTH_ERROR;
    } else {
      return UNKNOWN_ERROR;
    }
  }

  /// Get user-friendly error message
  String getUserFriendlyMessage(String errorType, {String? customMessage}) {
    if (customMessage != null && customMessage.isNotEmpty) {
      return customMessage;
    }

    switch (errorType) {
      case TIMEOUT_ERROR:
        return 'Koneksi timeout - periksa koneksi internet Anda';
      case NETWORK_ERROR:
        return 'Tidak dapat terhubung ke server - periksa koneksi internet';
      case SERVER_ERROR:
        return 'Server sedang bermasalah - coba lagi nanti';
      case AUTH_ERROR:
        return 'Sesi Anda telah berakhir - silakan login kembali';
      case VALIDATION_ERROR:
        return 'Data yang dimasukkan tidak valid';
      case UPLOAD_ERROR:
        return 'Gagal mengunggah data - coba lagi';
      default:
        return 'Terjadi kesalahan tidak terduga';
    }
  }

  /// Set custom keys for Crashlytics
  Future<void> _setCustomKeys(Map<String, String> keys) async {
    try {
      for (final entry in keys.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value);
      }
    } catch (e) {
      print('Failed to set custom keys: $e');
    }
  }

  /// Fallback logging to Crashlytics only
  Future<void> _fallbackCrashlyticsLog(String errorMessage, String errorType) async {
    try {
      await _crashlytics.recordError(
        'Fallback log: $errorMessage',
        null,
        fatal: false,
      );
      await _crashlytics.setCustomKey('errorType', errorType);
      await _crashlytics.setCustomKey('logType', 'fallback');
    } catch (crashlyticsError) {
      print('❌ Failed to log to Crashlytics: $crashlyticsError');
    }
  }

  /// Log critical errors that should be marked as fatal
  Future<void> logCriticalError({
    required String errorMessage,
    required String stackTrace,
    String? feature,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Log to Firestore first
      await logError(
        errorType: 'critical_error',
        errorMessage: errorMessage,
        stackTrace: stackTrace,
        feature: feature,
        additionalData: additionalData,
      );

      // Log as fatal to Crashlytics
      await _crashlytics.recordError(
        errorMessage,
        StackTrace.fromString(stackTrace),
        fatal: true,
      );
    } catch (e) {
      print('❌ Failed to log critical error: $e');
    }
  }

  /// Clear error logs older than specified days (for cleanup)
  Future<void> clearOldLogs({int daysToKeep = 30}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      
      final oldLogs = await _firestore
          .collection('app_errors')
          .where('timestamp', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      final batch = _firestore.batch();
      for (final doc in oldLogs.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('✅ Cleared ${oldLogs.docs.length} old error logs');
    } catch (e) {
      print('❌ Failed to clear old logs: $e');
    }
  }
}
