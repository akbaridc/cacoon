# Error Logging Service Documentation

## Overview

`ErrorLoggingService` adalah service khusus untuk menangani logging error ke Firebase Firestore dan Firebase Crashlytics dengan cara yang terorganisir dan reusable.

## Features

- ✅ Automatic error categorization
- ✅ Firebase Firestore logging
- ✅ Firebase Crashlytics integration
- ✅ User-friendly error messages
- ✅ Stack trace logging
- ✅ Device and app information capture
- ✅ Feature-specific error tracking

## Installation & Setup

### 1. Import Service

```dart
import 'package:cacoon_mobile/app/services/error_logging_service.dart';
```

### 2. Initialize Service

```dart
class YourController extends GetxController {
  final ErrorLoggingService _errorLoggingService = ErrorLoggingService();
}
```

## Error Types

The service includes predefined error types:

- `SERVER_ERROR` - Server response errors (5xx status codes)
- `NETWORK_ERROR` - Network connectivity issues
- `TIMEOUT_ERROR` - Request timeout errors
- `AUTH_ERROR` - Authentication/authorization failures
- `VALIDATION_ERROR` - Form validation errors
- `UPLOAD_ERROR` - File upload failures
- `UNKNOWN_ERROR` - Unclassified errors

## Usage Examples

### 1. Basic Error Logging

```dart
try {
  // Your code here
} catch (e) {
  await _errorLoggingService.logError(
    errorType: ErrorLoggingService.NETWORK_ERROR,
    errorMessage: e.toString(),
    feature: 'user_registration',
  );
}
```

### 2. Upload Error Logging

```dart
try {
  // Upload logic
} catch (e) {
  await _errorLoggingService.logUploadError(
    errorMessage: e.toString(),
    requestData: {
      'fileName': 'photo.jpg',
      'fileSize': '2MB',
      'userId': '12345',
    },
    statusCode: 500,
    responseBody: response.body,
  );
}
```

### 3. Authentication Error Logging

```dart
if (response.statusCode != 200) {
  await _errorLoggingService.logAuthError(
    errorMessage: 'Login failed',
    feature: 'login',
    additionalData: {
      'email': userEmail,
      'statusCode': response.statusCode,
    },
  );
}
```

### 4. Smart Error Handling

```dart
try {
  // Your code here
} catch (e) {
  // Automatically determine error type
  final errorType = _errorLoggingService.determineErrorType(e);
  final userMessage = _errorLoggingService.getUserFriendlyMessage(errorType);

  await _errorLoggingService.logError(
    errorType: errorType,
    errorMessage: e.toString(),
    feature: 'data_sync',
    stackTrace: StackTrace.current.toString(),
  );

  // Show user-friendly message
  Get.snackbar('Error', userMessage);
}
```

### 5. Network Error Logging

```dart
try {
  final response = await http.get(url);
} catch (e) {
  await _errorLoggingService.logNetworkError(
    errorMessage: e.toString(),
    feature: 'api_call',
    requestData: {'url': url.toString()},
  );
}
```

### 6. Validation Error Logging

```dart
if (!isValidEmail(email)) {
  await _errorLoggingService.logValidationError(
    errorMessage: 'Invalid email format',
    feature: 'user_form',
    formData: {'email': email},
  );
}
```

### 7. Critical Error Logging

```dart
try {
  // Critical operation
} catch (e) {
  await _errorLoggingService.logCriticalError(
    errorMessage: e.toString(),
    stackTrace: StackTrace.current.toString(),
    feature: 'payment_processing',
    additionalData: {'transactionId': txId},
  );
}
```

## Data Structure

### Firestore Document Structure

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "userId": "12345",
  "userName": "John Doe",
  "errorType": "network_error",
  "errorMessage": "SocketException: Connection refused",
  "statusCode": null,
  "responseBody": null,
  "stackTrace": "...",
  "feature": "upload",
  "requestData": {
    "vessel_code": "SHIP001",
    "palka": "PALKA001",
    "hasMainPhoto": true
  },
  "additionalData": {
    "customKey": "customValue"
  },
  "deviceInfo": {
    "platform": "android",
    "platformVersion": "Android 11",
    "locale": "id_ID"
  },
  "appInfo": {
    "version": "1.0.0",
    "buildNumber": "1",
    "packageName": "com.example.cacoon_mobile"
  }
}
```

## Best Practices

### 1. Feature-Specific Logging

Always specify the feature where the error occurred:

```dart
await _errorLoggingService.logError(
  errorType: ErrorLoggingService.NETWORK_ERROR,
  errorMessage: e.toString(),
  feature: 'boat_search', // ✅ Good
);
```

### 2. Include Relevant Context

Provide relevant data for debugging:

```dart
await _errorLoggingService.logError(
  errorType: ErrorLoggingService.SERVER_ERROR,
  errorMessage: 'API call failed',
  requestData: {
    'endpoint': '/api/boats',
    'method': 'GET',
    'params': searchParams,
  },
  statusCode: response.statusCode,
  responseBody: response.body,
);
```

### 3. Use Smart Error Detection

Let the service determine error types automatically:

```dart
final errorType = _errorLoggingService.determineErrorType(e);
final userMessage = _errorLoggingService.getUserFriendlyMessage(errorType);
```

### 4. Stack Trace for Debug Builds

Include stack traces for better debugging:

```dart
await _errorLoggingService.logError(
  errorType: errorType,
  errorMessage: e.toString(),
  stackTrace: StackTrace.current.toString(), // ✅ Helpful for debugging
);
```

## Monitoring & Analytics

### Firebase Console

1. **Firestore Console**: View detailed error logs in `app_errors` collection
2. **Crashlytics Dashboard**: Monitor crash reports and error trends

### Error Analysis Queries

```javascript
// Most common errors
db.collection("app_errors")
  .where("timestamp", ">=", startDate)
  .where("timestamp", "<=", endDate)
  .orderBy("timestamp", "desc");

// Errors by feature
db.collection("app_errors")
  .where("feature", "==", "upload")
  .orderBy("timestamp", "desc");

// Errors by user
db.collection("app_errors")
  .where("userId", "==", "specific_user_id")
  .orderBy("timestamp", "desc");
```

## Migration from Old Method

### Before (Old Method)

```dart
// Old Firebase logging in controller
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

await _firestore.collection('upload_errors').add(errorData);
await _crashlytics.recordError(errorMessage, null, fatal: false);
```

### After (Using Service)

```dart
// New service-based approach
final ErrorLoggingService _errorLoggingService = ErrorLoggingService();

await _errorLoggingService.logUploadError(
  errorMessage: e.toString(),
  requestData: requestData,
  statusCode: response.statusCode,
);
```

## Maintenance

### Cleanup Old Logs

```dart
// Clean up logs older than 30 days
await _errorLoggingService.clearOldLogs(daysToKeep: 30);
```

## Integration Examples

### Login Controller

```dart
class LoginController extends GetxController {
  final ErrorLoggingService _errorLoggingService = ErrorLoggingService();

  Future<void> login() async {
    try {
      // Login logic
    } catch (e) {
      final errorType = _errorLoggingService.determineErrorType(e);
      await _errorLoggingService.logAuthError(
        errorMessage: e.toString(),
        feature: 'login',
      );

      Get.snackbar('Error', _errorLoggingService.getUserFriendlyMessage(errorType));
    }
  }
}
```

### Upload Controller

```dart
class CreateController extends GetxController {
  final ErrorLoggingService _errorLoggingService = ErrorLoggingService();

  Future<void> submitData() async {
    try {
      // Upload logic
    } catch (e) {
      await _errorLoggingService.logUploadError(
        errorMessage: e.toString(),
        requestData: formData,
      );
    }
  }
}
```

This service provides a comprehensive solution for error handling and monitoring in your Flutter application! 🚀
