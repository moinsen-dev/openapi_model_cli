const mustacheDartFreezedEntity = '''
// ignore_for_file: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

import '_index.dart';

part '{{ fileName }}.freezed.dart';
part '{{ fileName }}.g.dart';

@freezed
class {{ className }} extends BaseModel with _{{ dollarClassName }} {
  {{# attrs }}
  static const attr_{{ name }} = '{{ name }}';
  {{/ attrs }}

  factory {{ className }}({
  {{# attrs }}
   {{ description }}
   {{ default }}{{ type }} {{ name }},
  {{/ attrs }}
  }) = _{{ className }};      

  factory {{ className }}.fromJson(Map<String, dynamic> json) => _{{ dollarClassName }}FromJson(json);
}
''';
