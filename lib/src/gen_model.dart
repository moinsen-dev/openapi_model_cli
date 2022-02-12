import 'package:mustache_template/mustache.dart';
import 'package:yaml/yaml.dart';

// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';

// part 'a.freezed.dart';
// part 'a.g.dart';

// @freezed
// class entity with _$entity {
//   factory entity({
//   }) = _entity;

//   factory entity.fromJson(Map<String, dynamic> json) =>
//       _$entityFromJson(json);
// }

class GenModel {
  GenModel(this.name, this.data);

  final String name;
  final YamlMap data;

  void testMustache() {
    var source = '''
	  {{# names }}
            <div>{{ lastname }}, {{ firstname }}</div>
	  {{/ names }}
	  {{^ names }}
	    <div>No names.</div>
	  {{/ names }}
	  {{! I am a comment. }}
	''';

    var template = Template(source, name: 'template-filename.html');

    var output = template.renderString({
      'names': [
        {'firstname': 'Greg', 'lastname': 'Lowe'},
        {'firstname': 'Bob', 'lastname': 'Johnson'}
      ]
    });

    print(output);
  }
}
