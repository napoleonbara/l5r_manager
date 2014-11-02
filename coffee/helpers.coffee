merge_objects = (objs...) ->
  r = {};
  for obj in objs
    r[n] = v for n, v of obj
  r

varnamize = (str) ->
  str.replace(/^\s+|\s+$/g, '').toLowerCase().replace(/[ ']/, '_')


object_keep = (obj, list) ->
  r = {}
  for i in [0...list.length]
    r[list[i]] = obj[list[i]]
  r

