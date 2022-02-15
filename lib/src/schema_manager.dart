import 'package:openapi_model_cli/src/env.dart';
import 'package:openapi_model_cli/src/schema.dart';

class SchemaManager {
  final Env env;
  Set<Schema> schemes = {};

  SchemaManager(this.env) {
    env.schemas?.forEach(
      (name, schema) {
        schemes.add(
          Schema(
            name,
            schema,
          ),
        );
      },
    );
  }
}
