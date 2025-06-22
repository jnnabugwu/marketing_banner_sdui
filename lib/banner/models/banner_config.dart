import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'banner_config.g.dart';

@JsonSerializable()
class BannerConfig extends Equatable {
  const BannerConfig({
    required this.id,
    required this.type,
    required this.priority,
    required this.config,
    this.validFrom,
    this.validUntil,
    this.targetGroup,
  });

  factory BannerConfig.fromJson(Map<String, dynamic> json) =>
      _$BannerConfigFromJson(json);

  final String id;
  final String type;
  final int priority;
  final Map<String, dynamic> config;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final String? targetGroup;

  Map<String, dynamic> toJson() => _$BannerConfigToJson(this);

  bool get isValid {
    final now = DateTime.now();
    if (validFrom != null && now.isBefore(validFrom!)) return false;
    if (validUntil != null && now.isAfter(validUntil!)) return false;
    return true;
  }

  @override
  List<Object?> get props => [
        id,
        type,
        priority,
        config,
        validFrom,
        validUntil,
        targetGroup,
      ];
}
