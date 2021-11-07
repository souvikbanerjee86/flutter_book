import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(Timestamp? timestamp) {
  if (timestamp != null) {
    return DateFormat.yMMMd().format(timestamp.toDate());
  }
  return "";
}
