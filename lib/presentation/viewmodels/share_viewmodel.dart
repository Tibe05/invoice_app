import 'dart:io';
import 'package:brain_memo/presentation/components/share_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareViewModel {
  final controller = ScreenshotController();

  Future<void> shareScoreImage(int score) async {
    final image = await controller.capture();
    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/score.png';
    final file = await File(path).writeAsBytes(image);

    final params = ShareParams(
      text:
          'I just scored $score in Brain Memo 123 🧠🔥! Think you can beat me? \nDownload here: https://apps.apple.com/us/app/brain-memo-123/id6753922058',
      files: [XFile(file.path)],
    );

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the picture!');
    }
  }

  /// Captures a custom invisible widget and shares it
  Future<void> shareScore({
    //required String pseudo,
    required loc,
    required int score,
    required String userAnswer,
    required String correctAnswer,
    required String message,
  }) async {
    try {
      // 🧱 Build the widget you want to capture
      final widgetToCapture = ShareScreen(
        loc: loc,
        score: score,
        userAnswer: userAnswer,
        correctAnswer: correctAnswer,
      );

      // 📸 Capture the widget even though it's not visible
      final Uint8List imageBytes =
          await controller.captureFromWidget(widgetToCapture);

      // 💾 Save to temporary file
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/score_share.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      // 🔗 Share the image and message
      final params = ShareParams(
        text: message,
        // text:
        //     'I just scored $score in Brain Memo 123 🧠🔥! Think you can beat me? \nDownload here: https://apps.apple.com/us/app/brain-memo-123/id6753922058',
        files: [XFile(file.path)],
      );

      final result = await SharePlus.instance.share(params);
      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing the picture!');
      }
    } catch (e) {
      print("Error while sharing score: $e");
    }
  }
}
