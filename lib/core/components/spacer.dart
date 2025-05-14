import 'package:ccl_app/core/dimens.dart';
import 'package:flutter/widgets.dart';

abstract class Spacing {
  /// "micro":  height = 4.0, width = 4.0
  static const SizedBox micro = SizedBox(
    height: Dimen.micro,
    width: Dimen.micro,
  );

  /// "tiny":  height = 6.0, width = 6.0
  static const SizedBox tiny = SizedBox(
    height: Dimen.tiny,
    width: Dimen.tiny,
  );

  /// "xSmall":  height = 8.0, width = 8.0
  static const SizedBox xSmall = SizedBox(
    height: Dimen.xSmall,
    width: Dimen.xSmall,
  );

  /// "small":  height = 12.0, width = 12.0
  static const SizedBox small = SizedBox(
    height: Dimen.small,
    width: Dimen.small,
  );

  /// "regular":  height = 16.0, width = 16.0
  static const SizedBox regular = SizedBox(
    height: Dimen.regular,
    width: Dimen.regular,
  );

  /// "medium":  height = 24.0, width = 24.0
  static const SizedBox medium = SizedBox(
    height: Dimen.medium,
    width: Dimen.medium,
  );

  /// "large":  height = 32.0, width = 32.0
  static const SizedBox large = SizedBox(
    height: Dimen.large,
    width: Dimen.large,
  );

  /// "xLarge": height = 44.0, width = 44.0
  static const SizedBox xLarge = SizedBox(
    height: Dimen.xLarge,
    width: Dimen.xLarge,
  );
}
