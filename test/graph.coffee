module.exports =
  a:
    "$ref": [{"$ref": "#/b"}]
  b:
    "$ref": [{"$ref": "#/a"}]
  c:
    "$ref": [{"$ref": "#/a"}]
  d:
    "$ref": [{"$ref": "#/c"}]
