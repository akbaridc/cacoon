import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cacoon_mobile/app/data/boat_model.dart';
import 'package:cacoon_mobile/app/data/palka_model.dart';
import 'package:cacoon_mobile/app/data/shift_model.dart';
import 'package:cacoon_mobile/app/routes/app_pages.dart';
import 'package:cacoon_mobile/app/services/error_logging_service.dart';
import 'package:cacoon_mobile/constants/api_endpoint.dart';
import 'package:cacoon_mobile/constants/lottie_assets.dart';
import 'package:cacoon_mobile/helpers/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class CreateController extends GetxController {
  var imageFile = Rxn<File>();
  var selfieImageFile = Rxn<File>();

  var currentPosition = Rxn<Position>();
  var captureTime = ''.obs;
  var longitude = ''.obs;
  var latitude = ''.obs;
  var name = ''.obs;

  var selectedBoat = ''.obs;
  var dateTime = DateTime.now().obs;

  var palka = <Palka>[].obs;
  var selectedPalka = ''.obs;
  var selectedPalkaId = ''.obs;
  var isLoadingPalka = false.obs;
  var isErrorPalka = false.obs;
  var errorMessagePalka = ''.obs;

  var shift = <Shift>[].obs;
  var selectedShift = ''.obs;
  var isLoadingShift = false.obs;
  var isErrorShift = false.obs;
  var errorMessageShift = ''.obs;

  var boatTextController = TextEditingController();
  var noteTextController = TextEditingController();

  var isSubmitting = false.obs;
  var showPreviewDialog = false.obs;

  // Image picker state management
  var isPickingImage = false.obs;
  var isPickingSelfie = false.obs;
  var isProcessingWatermark = false.obs; // Add watermark processing state

  // Error logging service
  final ErrorLoggingService _errorLoggingService = ErrorLoggingService();

  Future<void> pickSelfieImage() async {
    // Prevent multiple calls and check if watermark is being processed
    if (isPickingSelfie.value || isPickingImage.value || isProcessingWatermark.value) {
      print('Image picker or watermark processing already active, ignoring call');
      return;
    }

    try {
      isPickingSelfie.value = true;
      
      // Force close any existing dialogs before starting
      if (Get.isDialogOpen == true) {
        print('Closing existing dialog before starting selfie capture');
        Get.back();
        await Future.delayed(const Duration(milliseconds: 300)); // Wait for dialog to close
      }
      
      await _determinePosition();
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 40, // Same quality as main photo
        preferredCameraDevice: CameraDevice.front, // Front camera for selfie
        maxWidth: 800, // Same as main photo for consistency
        maxHeight: 800, // Same as main photo for consistency
      );

      if (pickedFile != null) {
        // Set watermark processing flag
        isProcessingWatermark.value = true;
        
        // Show loading dialog while processing watermark with Lottie
        // _showLottieLoadingDialog(
        //   lottieUrl: LottieAssets.processingAlt,
        //   title: 'Memproses foto selfie...',
        //   subtitle: 'Menambahkan watermark',
        //   width: 80,
        //   height: 80,
        // );
        
        // Add timeout for watermark processing
        try {
          final processedImageFile = await _addWatermarkToImage(File(pickedFile.path), isSelfie: true)
              .timeout(const Duration(seconds: 30), onTimeout: () {
            throw Exception('Watermark processing timeout');
          });
          
          // Close loading dialog
          // if (Get.isDialogOpen == true) {
          //   Get.back();
          // }
          
          selfieImageFile.value = processedImageFile;
          
          // Show preview dialog after processing
          _showWatermarkPreview(processedImageFile, isSelfie: true);
          
          // Get.snackbar(
          //   'Sukses', 
          //   'Foto selfie berhasil diambil dan diproses',
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          //   duration: const Duration(seconds: 2),
          // );

          // Get.back();
        } catch (watermarkError) {
          print('Watermark processing error: $watermarkError');
          
          // Close loading dialog if still open
          // if (Get.isDialogOpen == true) {
          //   Get.back();
          // }
          
          // Use original file if watermark fails
          selfieImageFile.value = File(pickedFile.path);
          
          Get.snackbar(
            'Warning', 
            'Foto selfie berhasil diambil, namun watermark gagal diproses',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          
          // Show preview with original file
          _showWatermarkPreview(File(pickedFile.path), isSelfie: true);
        }
      }
    } catch (e) {
      print('Error taking selfie: $e');
      
      // Force close any open dialogs
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      
      // Log error using ErrorLoggingService
      await _errorLoggingService.logError(
        errorType: 'camera_error',
        errorMessage: 'Failed to capture selfie with watermark: ${e.toString()}',
        requestData: {'feature': 'selfie_capture_with_watermark'},
        feature: 'camera',
        stackTrace: StackTrace.current.toString(),
      );
      
      Get.snackbar(
        'Error', 
        'Gagal mengambil foto selfie. Silakan coba lagi.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isPickingSelfie.value = false;
      isProcessingWatermark.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    
    // Try to get arguments immediately
    print("CREATE CONTROLLER onInit - Arguments: ${Get.arguments}");
    _handleArguments();
    
    if (!await _requestCameraPermission()) {
      Get.snackbar('Permission Error', 'Permission kamera tidak diberikan');
      return;
    }
    await _determinePosition();

    name.value = (await SessionHelper.getName());

    await fetchPalka();
    await fetchShift();
  }

  @override
  void onReady() {
    super.onReady();
    
    // Try again in onReady
    print("CREATE CONTROLLER onReady - Arguments: ${Get.arguments}");
    _handleArguments();
    
    // Also try with WidgetsBinding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("CREATE CONTROLLER PostFrameCallback - Arguments: ${Get.arguments}");
      _handleArguments();
    });
  }

  void _handleArguments() {
    final arguments = Get.arguments;
    print("_handleArguments called with: $arguments");
    print("Arguments type: ${arguments.runtimeType}");
    
    if (arguments != null && arguments is Map<String, dynamic>) {
      final boat = arguments['boat'] as Boat?;
      final date = arguments['date'] as DateTime?;
      
      print("Boat found: ${boat?.vslName}");
      print("Date found: $date");
      
      if (boat != null) {
        // Pre-fill boat data if provided
        setSelectedBoat(boat.vslName, boat.vslCode);
        print("Boat set: ${boat.vslName} - ${boat.vslCode}");
      }
      
      if (date != null) {
        // Set the date from argument but use current time
        final now = DateTime.now();
        dateTime.value = DateTime(
          date.year,
          date.month, 
          date.day,
          now.hour,
          now.minute,
          now.second,
        );
        print("Date set with current time: ${dateTime.value}");
      }

      print("Final state - Boat: ${boatTextController.text}, SelectedBoat: ${selectedBoat.value}");
    } else {
      print("No arguments received or wrong type");
    }
  }

  // Public method for manual argument handling
  void handleArguments(dynamic arguments) {
    print("Manual handleArguments called with: $arguments");
    print("Arguments type: ${arguments.runtimeType}");
    
    if (arguments != null && arguments is Map<String, dynamic>) {
      final boat = arguments['boat'] as Boat?;
      final date = arguments['date'] as DateTime?;
      
      print("Manual - Boat found: ${boat?.vslName}");
      print("Manual - Date found: $date");
      
      if (boat != null) {
        // Pre-fill boat data if provided
        setSelectedBoat(boat.vslName, boat.vslCode);
        print("Manual - Boat set: ${boat.vslName} - ${boat.vslCode}");
      }
      
      if (date != null) {
        // Set the date from argument but use current time
        final now = DateTime.now();
        dateTime.value = DateTime(
          date.year,
          date.month, 
          date.day,
          now.hour,
          now.minute,
          now.second,
        );
        print("Manual - Date set with current time: ${dateTime.value}");
      }

      print("Manual - Final state - Boat: ${boatTextController.text}, SelectedBoat: ${selectedBoat.value}");
    } else {
      dateTime.value = DateTime.now();
      _resetForm();
      print("Manual - No arguments received or wrong type");
    }
  }

  void doRefresh() async {
    await fetchPalka();
    await fetchShift();
  }

  void setSelectedBoat(String name, String code) {
    selectedBoat.value = code;
    boatTextController.text = name;
  }

  void setSelectedPalka(String name, String id) {
    selectedPalka.value = name;
    selectedPalkaId.value = id;
  }

  Future<List<Boat>> fetchBoatSuggestions({required String keyword}) async {
    try {
      final token = await SessionHelper.getAccessToken();
      final url =
          '${ApiEndpoint.baseUrl}${ApiEndpoint.vessel}?search=$keyword&type=Loading';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Response status: ${response.body}");
      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);
        final dataList = jsonResult["data"];
        print("Data fetched: $dataList");
        if (dataList == null || dataList.isEmpty) {
          return [];
        }
        print("Data list length: ${dataList.length}");
        return dataList.map<Boat>((item) => Boat.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching boats: $e");
      return [];
    }
  }

  Future<void> fetchPalka() async {
    try {
      isLoadingPalka.value = true;
      isErrorPalka.value = false;
      errorMessagePalka.value = '';

      var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.palka}';
      String token = await SessionHelper.getAccessToken();

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.body);
        var data = jsonResult["data"];
        List<Palka> fetchedPalka = data
            .map<Palka>((item) => Palka.fromJson(item))
            .toList();

        palka.assignAll(fetchedPalka);
      } else {
        isErrorPalka.value = true;
        errorMessagePalka.value = 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      isErrorPalka.value = true;
      errorMessagePalka.value = e.toString();
    } finally {
      isLoadingPalka.value = false;
    }
  }

  Future<void> fetchShift() async {
    try {
      isLoadingShift.value = true;
      isErrorShift.value = false;
      errorMessageShift.value = '';

      shift.assignAll([
        Shift(id: 1, name: 'Shift 1'),
        Shift(id: 2, name: 'Shift 2'),
        Shift(id: 3, name: 'Shift 3'),
      ]);
    } catch (e) {
      isErrorShift.value = true;
      errorMessageShift.value = e.toString();
    } finally {
      isLoadingShift.value = false;
    }
  }

  Future<void> submitData() async {
    if (isSubmitting.value) return; // Prevent multiple submissions
    
    if (imageFile.value == null) {
      Get.snackbar('Error', 'Silakan ambil foto terlebih dahulu');
      return;
    }

    if (currentPosition.value == null) {
      Get.snackbar('Error', 'Lokasi tidak tersedia');
      return;
    }

    if (selectedBoat.value.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih kapal terlebih dahulu');
      return;
    }

    if (selectedPalka.value.isEmpty && selectedPalkaId.value.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih palka terlebih dahulu');
      return;
    }

    if (selectedShift.value.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih shift terlebih dahulu');
      return;
    }

    try {
      isSubmitting.value = true;
      print("Starting upload process...");
      
      // Show progress indicator with Lottie animation
      _showLottieLoadingDialog(
        lottieUrl: LottieAssets.uploadingAlt,
        title: 'Mengunggah data...',
        subtitle: 'Mohon tunggu sebentar',
        width: 100,
        height: 100,
      );
      
      var url = '${ApiEndpoint.baseUrl}${ApiEndpoint.postVessel}';
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);
      
      // Set headers with timeout configuration
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] =
          'Bearer ${await SessionHelper.getAccessToken()}';
      
      // Tambahkan field biasa
      request.fields['user'] = (await SessionHelper.getId()).toString();
      request.fields['vessel_code'] = selectedBoat.value;
      request.fields['palka'] = selectedPalkaId.value.isNotEmpty ? selectedPalkaId.value : selectedPalka.value;
      request.fields['date'] = DateFormat('yyyy-MM-dd').format(dateTime.value);
      request.fields['time'] = DateFormat('HH:mm:ss').format(dateTime.value);
      request.fields['lat'] = latitude.value.toString();
      request.fields['long'] = longitude.value.toString();
      request.fields['shift'] = selectedShift.value == 'Shift 1'
          ? '1'
          : selectedShift.value == 'Shift 2'
              ? '2'
              : '3';
      request.fields['note'] = noteTextController.text;

      // Compress and add photo_vessel with progress tracking
      if (imageFile.value != null) {
        print("Compressing main image...");
        final compressedImage = await _compressImage(imageFile.value!);
        
        final photoVesselFile = await http.MultipartFile.fromPath(
          'photo_vessel',
          compressedImage.path,
          filename: basename(compressedImage.path),
        );
        request.files.add(photoVesselFile);
        print("Main image added to request (${await compressedImage.length()} bytes)");
      }

      // Compress and add photo_selfie if available
      if (selfieImageFile.value != null) {
        print("Compressing selfie image...");
        final compressedSelfie = await _compressImage(selfieImageFile.value!);
        
        final photoSelfieFile = await http.MultipartFile.fromPath(
          'photo_selfie',
          compressedSelfie.path,
          filename: basename(compressedSelfie.path),
        );
        request.files.add(photoSelfieFile);
        print("Selfie image added to request (${await compressedSelfie.length()} bytes)");
      }

      print("Sending request to server...");
      
      // Prepare request data for potential error logging
      final requestDataForLogging = {
        'vessel_code': selectedBoat.value,
        'palka': selectedPalkaId.value.isNotEmpty ? selectedPalkaId.value : selectedPalka.value,
        'date': DateFormat('yyyy-MM-dd').format(dateTime.value),
        'time': DateFormat('HH:mm:ss').format(dateTime.value),
        'lat': latitude.value.toString(),
        'long': longitude.value.toString(),
        'shift': selectedShift.value == 'Shift 1' ? '1' : selectedShift.value == 'Shift 2' ? '2' : '3',
        'note': noteTextController.text,
        'hasMainPhoto': imageFile.value != null,
        'hasSelfiePhoto': selfieImageFile.value != null,
      };
      
      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60), // 60 seconds timeout
        onTimeout: () {
          throw Exception('Upload timeout - connection too slow');
        },
      );
      
      final response = await http.Response.fromStream(streamedResponse);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      // Close progress dialog
      Get.back();
      //get body status

      if (response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Data berhasil dikirim',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        // Reset form after successful submission
        _resetForm();
        Get.toNamed(Routes.NAVIGATION_BAR);
        print('Upload sukses: ${response.body}');
      } else {
        // Log server error using ErrorLoggingService
        await _errorLoggingService.logUploadError(
          errorMessage: 'Server responded with status ${response.statusCode}',
          requestData: requestDataForLogging,
          responseBody: response.body,
          statusCode: response.statusCode,
        );
        
        Get.snackbar(
          'Error',
          'Gagal mengirim data: ${response.body}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        print('Gagal upload: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Close progress dialog if still open
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      
      // Prepare request data for error logging
      final requestDataForLogging = {
        'vessel_code': selectedBoat.value,
        'palka': selectedPalkaId.value.isNotEmpty ? selectedPalkaId.value : selectedPalka.value,
        'date': DateFormat('yyyy-MM-dd').format(dateTime.value),
        'time': DateFormat('HH:mm:ss').format(dateTime.value),
        'lat': latitude.value.toString(),
        'long': longitude.value.toString(),
        'shift': selectedShift.value == 'Shift 1' ? '1' : selectedShift.value == 'Shift 2' ? '2' : '3',
        'note': noteTextController.text,
        'hasMainPhoto': imageFile.value != null,
        'hasSelfiePhoto': selfieImageFile.value != null,
      };
      
      // Determine error type using ErrorLoggingService
      final errorType = _errorLoggingService.determineErrorType(e);
      final userFriendlyMessage = _errorLoggingService.getUserFriendlyMessage(errorType);
      
      // Log error using ErrorLoggingService
      await _errorLoggingService.logError(
        errorType: errorType,
        errorMessage: e.toString(),
        requestData: requestDataForLogging,
        feature: 'upload',
        stackTrace: StackTrace.current.toString(),
      );
      
      Get.snackbar(
        'Error',
        userFriendlyMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      print('Error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  // Add image compression method
  Future<File> _compressImage(File imageFile) async {
    try {
      print("Starting image compression for: ${imageFile.path}");
      final originalSize = await imageFile.length();
      print("Original file size: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB");
      
      // If file is already small enough, return as is
      if (originalSize < 2 * 1024 * 1024) { // Less than 2MB
        print("File is already small, skipping compression");
        return imageFile;
      }
      
      // Read and decode image
      final Uint8List imageBytes = await imageFile.readAsBytes();
      // Keep original dimensions, no resolution reduction
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;
      
      // Convert back to bytes with moderate compression
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      
      if (byteData != null) {
        final Uint8List compressedBytes = byteData.buffer.asUint8List();
        
        // Save compressed image
        final String compressedPath = imageFile.path.replaceAll('.png', '_compressed.png');
        final File compressedFile = File(compressedPath);
        await compressedFile.writeAsBytes(compressedBytes);
        
        final compressedSize = await compressedFile.length();
        print("Compressed file size: ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB");
        print("Compression ratio: ${((originalSize - compressedSize) / originalSize * 100).toStringAsFixed(1)}%");
        
        return compressedFile;
      }
      
      return imageFile;
    } catch (e) {
      print('Error compressing image: $e');
      return imageFile; // Return original if compression fails
    }
  }

  // Create optimized thumbnail for large files
  Future<ui.Image> _createThumbnail(File imageFile) async {
    try {
      print('Creating thumbnail for: ${imageFile.path}');
      
      // Read image bytes
      final Uint8List imageBytes = await imageFile.readAsBytes();
      
      // Decode with reduced size for preview
      final ui.Codec codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: 600, // Reduced size for preview
        targetHeight: 600,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      
      print('Thumbnail created: ${frameInfo.image.width}x${frameInfo.image.height}');
      return frameInfo.image;
    } catch (e) {
      print('Error creating thumbnail: $e');
      // Return a fallback empty image
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 300, 300),
        Paint()..color = Colors.grey,
      );
      final picture = recorder.endRecording();
      return await picture.toImage(300, 300);
    }
  }

  void _resetForm() {
    imageFile.value = null;
    selfieImageFile.value = null;
    selectedBoat.value = '';
    selectedPalka.value = '';
    selectedPalkaId.value = '';
    selectedShift.value = '';
    boatTextController.clear();
    noteTextController.clear();
    captureTime.value = '';
    
    // Reset image picker states
    isPickingImage.value = false;
    isPickingSelfie.value = false;
    isProcessingWatermark.value = false;
  }

  Future<void> pickImage() async {
    // Prevent multiple calls and check if watermark is being processed
    if (isPickingImage.value || isPickingSelfie.value || isProcessingWatermark.value) {
      print('Image picker or watermark processing already active, ignoring call');
      return;
    }

    try {
      isPickingImage.value = true;
      
      // Force close any existing dialogs before starting
      if (Get.isDialogOpen == true) {
        print('Closing existing dialog before starting image capture');
        Get.back();
        await Future.delayed(const Duration(milliseconds: 300)); // Wait for dialog to close
      }
      
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 40, // Maximum quality (0-100, 100 = max quality)
        preferredCameraDevice: CameraDevice.rear, // Back camera for main photo
        maxWidth: 800, // Optional: limit width to reduce size
        maxHeight: 800, // Optional: limit height to reduce size
      );

      if (pickedFile != null) {
        // Set watermark processing flag
        isProcessingWatermark.value = true;
        
        // Show loading dialog while processing watermark with Lottie
        _showLottieLoadingDialog(
          lottieUrl: LottieAssets.processingAlt,
          title: 'Memproses foto...',
          subtitle: 'Menambahkan watermark',
          width: 80,
          height: 80,
        );
        
        // Add timeout for watermark processing
        try {
          final processedImageFile = await _addWatermarkToImage(File(pickedFile.path), isSelfie: false)
              .timeout(const Duration(seconds: 30), onTimeout: () {
            throw Exception('Watermark processing timeout');
          });
          
          // Close loading dialog
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          
          imageFile.value = processedImageFile;
          captureTime.value = DateFormat(
            'dd/MM/yyyy hh:mm a',
          ).format(DateTime.now());
          
          // Show preview dialog after processing
          _showWatermarkPreview(processedImageFile);
        } catch (watermarkError) {
          print('Watermark processing error: $watermarkError');
          
          // Close loading dialog if still open
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          
          // Use original file if watermark fails
          imageFile.value = File(pickedFile.path);
          captureTime.value = DateFormat(
            'dd/MM/yyyy hh:mm a',
          ).format(DateTime.now());
          
          Get.snackbar(
            'Warning', 
            'Foto berhasil diambil, namun watermark gagal diproses',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          
          // Show preview with original file
          _showWatermarkPreview(File(pickedFile.path));
        }
      } else {
        Get.snackbar('Info', 'Foto tidak jadi diambil');
      }
    } catch (e) {
      print('Error taking image: $e');
      
      // Force close any open dialogs
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      
      // Log error using ErrorLoggingService
      await _errorLoggingService.logError(
        errorType: 'camera_error',
        errorMessage: 'Failed to capture main image: ${e.toString()}',
        requestData: {'feature': 'main_photo_capture'},
        feature: 'camera',
        stackTrace: StackTrace.current.toString(),
      );
      
      Get.snackbar(
        'Error', 
        'Gagal mengambil foto. Silakan coba lagi.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isPickingImage.value = false;
      isProcessingWatermark.value = false;
    }
  }

  Future<File> _addWatermarkToImage(File imageFile, {bool isSelfie = false}) async {
    try {
      print('Starting watermark process for: ${imageFile.path} (isSelfie: $isSelfie)');
      
      // Check if file exists and is readable
      if (!await imageFile.exists()) {
        print('Image file does not exist');
        return imageFile;
      }
      
      // Read image bytes with timeout
      final Uint8List imageBytes = await imageFile.readAsBytes()
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Image reading timeout');
      });
      print('Image bytes loaded: ${imageBytes.length}');
      
      // For selfie, use faster processing with smaller target size
      final ui.Codec codec = isSelfie 
        ? await ui.instantiateImageCodec(
            imageBytes,
            targetWidth: 600,  // Slightly larger for better quality
            targetHeight: 600,
          ).timeout(const Duration(seconds: 10), onTimeout: () {
            throw Exception('Image codec timeout for selfie');
          })
        : await ui.instantiateImageCodec(imageBytes)
            .timeout(const Duration(seconds: 10), onTimeout: () {
            throw Exception('Image codec timeout for main photo');
          });
      
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image originalImage = frameInfo.image;
      
      print('Original image size: ${originalImage.width} x ${originalImage.height}');
      
      // Create canvas for watermark with memory management
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Draw original image
      canvas.drawImage(originalImage, Offset.zero, Paint());
      
      // Calculate responsive watermark size based on image dimensions
      final double imageWidth = originalImage.width.toDouble();
      final double imageHeight = originalImage.height.toDouble();
      
      // Use smaller watermark for selfie to reduce processing time
      final double watermarkWidth = isSelfie 
        ? imageWidth * 0.8  // 80% for selfie (slightly smaller for faster processing)
        : imageWidth * 0.8; // 80% for main photo
      final double watermarkHeight = isSelfie 
        ? imageHeight * 0.12 // 12% for selfie (smaller for faster processing)
        : imageHeight * 0.15; // 15% for main photo
      final double margin = imageWidth * 0.05; // 5% margin
      
      final Rect watermarkRect = Rect.fromLTWH(
        margin, // Left margin
        imageHeight - watermarkHeight - margin, // Bottom position
        watermarkWidth,
        watermarkHeight,
      );
      
      print('Watermark rect: ${watermarkRect.toString()}');
      
      // Draw semi-transparent background with border
      final Paint backgroundPaint = Paint()
        ..color = Colors.black.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      
      final Paint borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0; // Same border for both
      
      final RRect roundedRect = RRect.fromRectAndRadius(
        watermarkRect,
        Radius.circular(imageWidth * 0.02), // Responsive radius
      );
      
      canvas.drawRRect(roundedRect, backgroundPaint);
      canvas.drawRRect(roundedRect, borderPaint);
      
      // Prepare text information
      final DateTime now = DateTime.now();
      final String timestamp = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
      final String latLong = 'Lat: ${latitude.value}\nLong: ${longitude.value}';
      final String createdAt = 'Created: $timestamp';
      
      // Calculate responsive font size - optimize for selfie
      final double fontSize = isSelfie 
        ? imageWidth * 0.022  // 2.2% for selfie (slightly smaller for faster rendering)
        : imageWidth * 0.025; // 2.5% for main photo
      print('Font size: $fontSize');
      
      // Text style with consistent settings for both selfie and main photo
      final TextStyle textStyle = TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 2.0, // Same blur for both
            color: Colors.black.withOpacity(0.8),
            offset: const Offset(1.0, 1.0),
          ),
        ],
      );
      
      final double padding = watermarkWidth * 0.03;
      
      // For selfie, use simplified watermark to reduce processing time
      if (isSelfie) {
        // Simplified watermark for selfie - just essential info
        final TextPainter timestampPainter = TextPainter(
          text: TextSpan(text: createdAt, style: textStyle),
          textDirection: ui.TextDirection.ltr,
        );
        timestampPainter.layout(maxWidth: watermarkWidth - (padding * 2));
        timestampPainter.paint(
          canvas,
          Offset(watermarkRect.left + padding, watermarkRect.top + padding),
        );
        
        // Add location on single line for faster processing
        final String shortLocation = 'Lat: ${latitude.value} | Long: ${longitude.value}';
        final TextPainter locationPainter = TextPainter(
          text: TextSpan(text: shortLocation, style: textStyle.copyWith(fontSize: fontSize * 0.8)),
          textDirection: ui.TextDirection.ltr,
        );
        locationPainter.layout(maxWidth: watermarkWidth - (padding * 2));
        locationPainter.paint(
          canvas,
          Offset(
            watermarkRect.left + padding, 
            watermarkRect.top + padding + timestampPainter.height + (padding * 0.3),
          ),
        );
        
        // Add selfie indicator
        final TextPainter indicatorPainter = TextPainter(
          text: TextSpan(
            text: '🤳 SELFIE',
            style: textStyle.copyWith(
              fontSize: fontSize * 0.7,
              color: Colors.yellow,
            ),
          ),
          textDirection: ui.TextDirection.ltr,
        );
        indicatorPainter.layout();
        indicatorPainter.paint(
          canvas,
          Offset(
            watermarkRect.right - indicatorPainter.width - padding,
            watermarkRect.bottom - indicatorPainter.height - padding,
          ),
        );
      } else {
        // Full watermark for main photo
        // Draw latitude/longitude text
        final TextPainter latLongPainter = TextPainter(
          text: TextSpan(text: latLong, style: textStyle),
          textDirection: ui.TextDirection.ltr,
          maxLines: 2,
        );
        latLongPainter.layout(maxWidth: watermarkWidth - (padding * 2));
        latLongPainter.paint(
          canvas,
          Offset(watermarkRect.left + padding, watermarkRect.top + padding),
        );
        
        // Draw timestamp text
        final TextPainter timestampPainter = TextPainter(
          text: TextSpan(text: createdAt, style: textStyle),
          textDirection: ui.TextDirection.ltr,
        );
        timestampPainter.layout(maxWidth: watermarkWidth - (padding * 2));
        timestampPainter.paint(
          canvas,
          Offset(
            watermarkRect.left + padding, 
            watermarkRect.top + padding + latLongPainter.height + (padding * 0.5),
          ),
        );
        
        // Add watermark indicator
        final TextPainter indicatorPainter = TextPainter(
          text: TextSpan(
            text: '📸 CACOON',
            style: textStyle.copyWith(
              fontSize: fontSize * 0.8,
              color: Colors.yellow,
            ),
          ),
          textDirection: ui.TextDirection.ltr,
        );
        indicatorPainter.layout();
        indicatorPainter.paint(
          canvas,
          Offset(
            watermarkRect.right - indicatorPainter.width - padding,
            watermarkRect.bottom - indicatorPainter.height - padding,
          ),
        );
      }
      
      // Convert to image with timeout
      final ui.Picture picture = recorder.endRecording();
      final ui.Image watermarkedImage = await picture.toImage(
        originalImage.width,
        originalImage.height,
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception('Picture to image conversion timeout');
      });
      
      print('Watermarked image created');
      
      // Convert to bytes with timeout
      final ByteData? byteData = await watermarkedImage.toByteData(
        format: ui.ImageByteFormat.png,
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception('Image to bytes conversion timeout');
      });
      
      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        
        // Save to temporary file with timeout
        final String tempPath = imageFile.path.replaceAll('.jpg', '_watermarked.png').replaceAll('.jpeg', '_watermarked.png');
        final File watermarkedFile = File(tempPath);
        await watermarkedFile.writeAsBytes(pngBytes)
            .timeout(const Duration(seconds: 10), onTimeout: () {
          throw Exception('File write timeout');
        });
        
        print('${isSelfie ? "Selfie" : "Main"} watermarked file saved: ${watermarkedFile.path}');
        print('File size: ${await watermarkedFile.length()} bytes');
        
        // Dispose resources
        originalImage.dispose();
        watermarkedImage.dispose();
        
        return watermarkedFile;
      }
      
      print('Failed to convert watermarked image to bytes');
      return imageFile; // Return original if watermark fails
    } catch (e) {
      print('Error adding watermark: $e');
      return imageFile; // Return original image if watermark fails
    }
  }

  void _showWatermarkPreview(File watermarkedFile, {bool isSelfie = false}) {
    // Prevent opening dialog if another is already open
    if (Get.isDialogOpen == true || showPreviewDialog.value) {
      print('Dialog already open, skipping preview');
      return;
    }
    
    showPreviewDialog.value = true;
    
    // Check if file exists and has watermark
    final bool fileExists = watermarkedFile.existsSync();
    final bool hasWatermark = watermarkedFile.path.contains('_watermarked'); // Both selfie and main photo can have watermark
    
    // Get file size for optimization
    final int fileSizeBytes = fileExists ? watermarkedFile.lengthSync() : 0;
    final double fileSizeMB = fileSizeBytes / 1024 / 1024;
    final bool isLargeFile = fileSizeMB > 1.0; // Files larger than 1MB
    
    print('Preview file size: ${fileSizeMB.toStringAsFixed(2)} MB');
    print('Is large file: $isLargeFile');
    
    // Set auto-close timer for very large files
    if (fileSizeMB > 2.0) {
      Timer(const Duration(seconds: 10), () {
        if (showPreviewDialog.value && Get.isDialogOpen == true) {
          showPreviewDialog.value = false;
          Get.back();
          Get.snackbar(
            'Info',
            'Preview ditutup otomatis - file terlalu besar',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      });
    }
    
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: hasWatermark ? Colors.green : isSelfie ? Colors.blue : Colors.orange,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelfie ? Icons.camera_front : Icons.camera_alt,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isSelfie ? 'Preview Foto Selfie' : 'Preview Foto Kapal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showPreviewDialog.value = false;
                        // Use immediate close for better performance
                        if (Get.isDialogOpen == true) {
                          Get.back();
                        }
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              // Image Preview
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Status indicator
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: hasWatermark ? Colors.green.withOpacity(0.1) : isSelfie ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: hasWatermark ? Colors.green : isSelfie ? Colors.blue : Colors.orange,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              hasWatermark ? Icons.check_circle : isSelfie ? Icons.info : Icons.warning,
                              color: hasWatermark ? Colors.green : isSelfie ? Colors.blue : Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              hasWatermark 
                                ? 'Watermark berhasil ditambahkan' 
                                : isSelfie 
                                  ? 'Foto selfie sedang diproses'
                                  : 'Watermark tidak terdeteksi',
                              style: TextStyle(
                                color: hasWatermark ? Colors.green : isSelfie ? Colors.blue : Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Image with optimized loading
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: fileExists 
                            ? isLargeFile
                              ? FutureBuilder<ui.Image>(
                                  future: _createThumbnail(watermarkedFile),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(height: 8),
                                              Text('Memuat preview...', style: TextStyle(fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError || !snapshot.hasData) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.error, color: Colors.red, size: 48),
                                              SizedBox(height: 8),
                                              Text('Gagal memuat preview'),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return RawImage(
                                        image: snapshot.data!,
                                        fit: BoxFit.contain,
                                      );
                                    }
                                  },
                                )
                              : Image.file(
                                  watermarkedFile,
                                  fit: BoxFit.contain,
                                  cacheWidth: 800, // Limit cache size
                                  cacheHeight: 800,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.error, color: Colors.red, size: 48),
                                            SizedBox(height: 8),
                                            Text('Gagal memuat gambar'),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                            : Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.image_not_supported, color: Colors.grey, size: 48),
                                      SizedBox(height: 8),
                                      Text('File tidak ditemukan'),
                                    ],
                                  ),
                                ),
                              ),
                        ),
                      ),
                      
                      // File info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'File: ${watermarkedFile.path.split('/').last}\nSize: ${fileExists ? '${fileSizeMB.toStringAsFixed(2)} MB' : 'Unknown'}${isLargeFile ? ' (Optimized preview)' : ''}',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Info Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          hasWatermark ? Icons.check_circle : isSelfie ? Icons.info : Icons.info,
                          color: hasWatermark ? Colors.green : isSelfie ? Colors.blue : Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hasWatermark 
                            ? 'Watermark berhasil ditambahkan!'
                            : isSelfie 
                              ? 'Foto selfie berhasil diproses'
                              : 'Foto diproses tanpa watermark',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: hasWatermark ? Colors.green : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Details
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Informasi:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (!isSelfie) ...[
                            _buildInfoRow('📍 Lokasi', 'Lat: ${latitude.value}, Long: ${longitude.value}'),
                            const SizedBox(height: 4),
                          ],
                          if (isSelfie) ...[
                            _buildInfoRow('📍 Lokasi', 'Lat: ${latitude.value}, Long: ${longitude.value}'),
                            const SizedBox(height: 4),
                          ],
                          _buildInfoRow('⏰ Waktu', DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())),
                          const SizedBox(height: 4),
                          _buildInfoRow('📸 Jenis', isSelfie ? 'Foto Selfie' : 'Foto Kapal'),
                          const SizedBox(height: 4),
                          _buildInfoRow('🏷️ Status', hasWatermark ? 'Dengan Watermark' : 'Sedang Diproses'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Action Buttons
                    Row(
                      children: [
                        // Add quick skip button for large files
                        if (isLargeFile) ...[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                showPreviewDialog.value = false;
                                // Immediate close for skip
                                if (Get.isDialogOpen == true) {
                                  Get.back();
                                }
                                Get.snackbar(
                                  'Info', 
                                  isSelfie 
                                    ? 'Foto selfie disimpan'
                                    : 'Foto disimpan tanpa preview',
                                  backgroundColor: Colors.blue,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 1),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Lewati'),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showPreviewDialog.value = false;
                              // Use immediate close for better performance
                              if (Get.isDialogOpen == true) {
                                Get.back();
                              }
                              
                              // Reset watermark processing state
                              isProcessingWatermark.value = false;
                              
                              // Add longer delay for better UX and state cleanup
                              Future.delayed(const Duration(milliseconds: 500), () {
                                if (isSelfie) {
                                  // Check if already picking image before calling
                                  if (!isPickingSelfie.value && !isPickingImage.value && !isProcessingWatermark.value) {
                                    pickSelfieImage();
                                  } else {
                                    print('Selfie picker blocked - states: picking=${isPickingSelfie.value}, processing=${isProcessingWatermark.value}');
                                  }
                                } else {
                                  // Check if already picking image before calling
                                  if (!isPickingImage.value && !isPickingSelfie.value && !isProcessingWatermark.value) {
                                    pickImage();
                                  } else {
                                    print('Image picker blocked - states: picking=${isPickingImage.value}, processing=${isProcessingWatermark.value}');
                                  }
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Foto Ulang'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showPreviewDialog.value = false;
                              // Use immediate close for better performance
                              if (Get.isDialogOpen == true) {
                                Get.back();
                              }
                              
                              // Add shorter delay and immediate feedback
                              Future.delayed(const Duration(milliseconds: 50), () {
                                Get.snackbar(
                                  'Sukses', 
                                  isSelfie 
                                    ? 'Foto selfie berhasil diambil dan diproses'
                                    : 'Foto berhasil diambil dan diproses',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 2),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Gunakan Foto'),
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
      barrierDismissible: false,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        const Text(': ', style: TextStyle(fontSize: 12)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Lokasi Tidak Aktif', 'Nyalakan GPS Anda terlebih dahulu');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Lokasi Ditolak', 'Tidak bisa ambil lokasi');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Lokasi Ditolak Permanen',
        'Silakan izinkan di pengaturan',
      );
      return;
    }

    try {
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      latitude.value = currentPosition.value!.latitude.toString();
      longitude.value = currentPosition.value!.longitude.toString();
      Get.snackbar('Sukses', 'Lokasi berhasil didapatkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mendapatkan lokasi: $e');
    }
  }

  String get currentLocationText {
    if (currentPosition.value == null) return 'Location not available';
    return 'Lat: ${currentPosition.value!.latitude}, Long: ${currentPosition.value!.longitude}';
  }

  // Helper method to show Lottie loading dialog
  void _showLottieLoadingDialog({
    required String lottieUrl,
    required String title,
    required String subtitle,
    double width = 80,
    double height = 80,
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie animation
                Lottie.network(
                  lottieUrl,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to CircularProgressIndicator if Lottie fails
                    return SizedBox(
                      width: width,
                      height: height,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
