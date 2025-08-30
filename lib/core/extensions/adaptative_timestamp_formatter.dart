import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdaptiveTimestampFormatter {
  /// Formats Firestore timestamp adaptively:
  /// - Within 24 hours: shows relative time (e.g., "2 hours ago")
  /// - After 24 hours: shows "dd/MM/yyyy at HH:mm"
  static String format(dynamic timestampData) {
    // Handle null or invalid timestamp
    if (timestampData == null) {
      return 'Date indisponible';
    }

    Timestamp timestamp;
    if (timestampData is Timestamp) {
      timestamp = timestampData;
    } else {
      return 'Format de date invalide';
    }

    final DateTime dateTime = timestamp.toDate();
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);

    // If less than 24 hours, show relative time
    if (difference.inHours < 24) {
      if (difference.inMinutes < 1) {
      return 'À l\'instant';
      } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
      return 'Il y a ${difference.inHours} ${difference.inHours == 1 ? 'heure' : 'heures'}';
      }
    }
    // If more than 24 hours, show formatted date and time
    else {
      return '${DateFormat('dd/MM/yyyy').format(dateTime)} à ${DateFormat('HH:mm').format(dateTime)}';
    }
  }
}
