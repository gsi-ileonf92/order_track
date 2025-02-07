import 'package:logger/logger.dart';
import 'package:order_track/core/constants/enums.dart';

class Utils {
  static logObject(dynamic object) {
    try {
      Logger(printer: PrettyPrinter()).t(object.toJson());
    } catch (e) {
      Logger().e("exception while logging: $e");
      Logger(printer: PrettyPrinter(colors: true)).t(object.toMap());
    }
  }

  static void logInfo(String message, {int methodCount = 2}) {
    Logger(
      printer: PrettyPrinter(methodCount: methodCount),
    ).i(message);
  }

  static void logWarning(String message, {int methodCount = 2}) {
    Logger(
      printer: PrettyPrinter(methodCount: methodCount),
    ).w(message);
  }

  static void logError(String message, {int methodCount = 2}) {
    Logger(
      printer: PrettyPrinter(methodCount: methodCount),
    ).e(message);
  }

  static void logDebug(String message, {int methodCount = 2}) {
    Logger(
      printer: PrettyPrinter(methodCount: methodCount),
    ).d(message);
  }

  static void logTrace(String message, {int methodCount = 2}) {
    Logger(
      printer: PrettyPrinter(methodCount: methodCount),
    ).t(message);
  }

  static String getTranslatedOrderStatus(String status) =>
      EnumOrderStatus.values
          .firstWhere((element) => element.name == status)
          .displayName;
}
