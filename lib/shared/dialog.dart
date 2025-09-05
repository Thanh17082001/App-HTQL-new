import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class DialogForm {
  static successDialog(context){
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Thêm thành công',
        showConfirmBtn: false,
        autoCloseDuration: const Duration(seconds: 3));
  }

  static failureDialog(context) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Thêm thất bại thử lại',
        showConfirmBtn: false,
        autoCloseDuration: const Duration(seconds: 3));
  }
}


