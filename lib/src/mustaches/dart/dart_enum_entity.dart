const mustacheDartEnumEntity = '''
  enum {{ className }} {
    {{# attrs }}
      {{ description }}
      {{ name }},
    {{/ attrs }}
  }
''';
