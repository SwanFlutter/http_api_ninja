import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'http_controller.dart';

class UpdateController extends GetXController {
  // Current app version - UPDATE THIS WITH EACH RELEASE
  static const String currentVersion = '1.0.0';

  // GitHub repository info - UPDATE WITH YOUR REPO
  static const String githubOwner = 'SwanFlutter';
  static const String githubRepo = 'http_api_ninja';

  // GetConnect for API calls
  final GetConnect _connect = GetConnect();

  // Observable variables
  final RxBool isChecking = false.obs;
  final RxBool updateAvailable = false.obs;
  final RxString latestVersion = ''.obs;
  final RxString downloadUrl = ''.obs;
  final RxString releaseNotes = ''.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final RxBool isDownloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connect.timeout = const Duration(seconds: 30);
  }

  /// Check GitHub releases for new version
  Future<void> checkForUpdates() async {
    if (isChecking.value) return;

    isChecking.value = true;
    updateAvailable.value = false;

    try {
      final response = await _connect.get(
        'https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest',
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      debugPrint('=== UPDATE CHECK ===');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body;
        final tagName = data['tag_name'] as String?;

        debugPrint('Tag name from GitHub: $tagName');

        if (tagName == null || tagName.isEmpty) {
          debugPrint('No tag_name found in response');
          return;
        }

        // Remove 'v' prefix if present
        final version = tagName.startsWith('v')
            ? tagName.substring(1)
            : tagName;
        latestVersion.value = version;
        releaseNotes.value = data['body'] ?? 'No release notes available';

        debugPrint('Latest version: $version');
        debugPrint('Current version: $currentVersion');
        debugPrint('Is newer: ${_isNewerVersion(version, currentVersion)}');

        // Find download URL for current platform
        final assets = data['assets'] as List? ?? [];
        downloadUrl.value = _findDownloadUrl(assets);

        // Compare versions
        if (_isNewerVersion(version, currentVersion)) {
          updateAvailable.value = true;
          debugPrint('Update available!');
        } else {
          debugPrint('No update needed');
        }
      } else {
        debugPrint('Failed to get release info');
      }
    } catch (e, stack) {
      debugPrint('Error checking for updates: $e');
      debugPrint('Stack: $stack');
    } finally {
      isChecking.value = false;
    }
  }

  /// Find the appropriate download URL for current platform
  String _findDownloadUrl(List assets) {
    String platform = '';

    if (Platform.isWindows) {
      platform = 'windows';
    } else if (Platform.isMacOS) {
      platform = 'macos';
    } else if (Platform.isLinux) {
      platform = 'linux';
    }

    for (var asset in assets) {
      final name = (asset['name'] as String).toLowerCase();
      if (name.contains(platform)) {
        return asset['browser_download_url'] as String;
      }
    }

    // Return first asset if platform-specific not found
    if (assets.isNotEmpty) {
      return assets[0]['browser_download_url'] as String;
    }

    return '';
  }

  /// Compare version strings
  bool _isNewerVersion(String latest, String current) {
    try {
      final latestParts = latest.split('.').map(int.parse).toList();
      final currentParts = current.split('.').map(int.parse).toList();

      for (int i = 0; i < latestParts.length && i < currentParts.length; i++) {
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }

      return latestParts.length > currentParts.length;
    } catch (e) {
      return false;
    }
  }

  /// Open download URL in browser
  Future<void> openDownloadPage() async {
    final url = downloadUrl.value.isNotEmpty
        ? downloadUrl.value
        : 'https://github.com/$githubOwner/$githubRepo/releases/latest';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Open GitHub releases page
  Future<void> openReleasesPage() async {
    final uri = Uri.parse(
      'https://github.com/$githubOwner/$githubRepo/releases',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Download update file using GetConnect
  Future<void> downloadUpdate(HttpController httpController) async {
    if (downloadUrl.value.isEmpty || isDownloading.value) return;

    isDownloading.value = true;
    downloadProgress.value = 0.0;

    try {
      // Get download directory
      final dir =
          await getDownloadsDirectory() ?? await getTemporaryDirectory();
      final fileName = downloadUrl.value.split('/').last;
      final filePath = '${dir.path}/$fileName';

      // Download file
      final response = await _connect.get(
        downloadUrl.value,
        headers: {'Accept': 'application/octet-stream'},
      );

      if (response.statusCode == 200 && response.bodyBytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(response.body);

        downloadProgress.value = 1.0;

        httpController.showNotification(
          'Download complete! File saved to: $filePath',
          'success',
        );
      } else {
        throw Exception('Download failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading update: $e');
      httpController.showNotification('Download failed: $e', 'error');
    } finally {
      isDownloading.value = false;
    }
  }
}
