// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerConfig _$BannerConfigFromJson(Map<String, dynamic> json) => BannerConfig(
      id: json['id'] as String,
      type: json['type'] as String,
      priority: (json['priority'] as num).toInt(),
      config: json['config'] as Map<String, dynamic>,
      validFrom: json['validFrom'] == null
          ? null
          : DateTime.parse(json['validFrom'] as String),
      validUntil: json['validUntil'] == null
          ? null
          : DateTime.parse(json['validUntil'] as String),
      targetGroup: json['targetGroup'] as String?,
    );

Map<String, dynamic> _$BannerConfigToJson(BannerConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'priority': instance.priority,
      'config': instance.config,
      'validFrom': instance.validFrom?.toIso8601String(),
      'validUntil': instance.validUntil?.toIso8601String(),
      'targetGroup': instance.targetGroup,
    };
