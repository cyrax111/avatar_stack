import 'positions.dart';
import 'restricted_positions.dart';

extension RestrictedPositionsCopyWith on RestrictedPositions {
  RestrictedPositions copyWith({
    double? maxCoverage,
    double? minCoverage,
    StackAlign? align,
    InfoItem? infoItem,
    StackLaying? laying,
    LayoutDirection? layoutDirection,
  }) {
    return RestrictedPositions(
      maxCoverage: maxCoverage ?? this.maxCoverage,
      minCoverage: minCoverage ?? this.minCoverage,
      align: align ?? this.align,
      infoItem: infoItem ?? this.infoItem,
      laying: laying ?? this.laying,
      layoutDirection: layoutDirection ?? this.layoutDirection,
    );
  }
}

extension RestrictedAmountPositionsCopyWith on RestrictedAmountPositions {
  RestrictedAmountPositions copyWith({
    double? maxCoverage,
    double? minCoverage,
    StackAlign? align,
    InfoItem? infoItem,
    StackLaying? laying,
    LayoutDirection? layoutDirection,
  }) {
    return RestrictedAmountPositions(
      maxCoverage: maxCoverage ?? this.maxCoverage,
      minCoverage: minCoverage ?? this.minCoverage,
      align: align ?? this.align,
      infoItem: infoItem ?? this.infoItem,
      laying: laying ?? this.laying,
      layoutDirection: layoutDirection ?? this.layoutDirection,
    );
  }
}
