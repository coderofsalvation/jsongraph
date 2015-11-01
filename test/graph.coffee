module.exports =
  a:
    output: [{"$ref": "#/b"}]
  b:
    output: [{"$ref": "#/a"}]
  c:
    output: [{"$ref": "#/a"}]
  d:
    output: [{"$ref": "#/c"}]
