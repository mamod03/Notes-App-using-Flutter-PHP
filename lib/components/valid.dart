import 'package:getx_test/constant/message.dart';

validInput(String val, int min, int max) {
  if (val.isEmpty) {
    return "$messageInputEmpty";
  }
  if (val.length > max) {
    return "$messageInputmax $max";
  }
  if (val.length < min) {
    return "$messageInputmin $min";
  }
}
