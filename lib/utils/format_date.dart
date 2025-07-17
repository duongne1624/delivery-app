import 'package:intl/intl.dart';

String formatDateTimeVN(DateTime time) {
  return DateFormat('HH:mm dd/MM/yyyy', 'vi_VN').format(time.toLocal());
}
