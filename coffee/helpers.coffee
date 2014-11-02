merge_objects = (objs...) ->
  r = {};
  for obj in objs
    r[n] = v for n, v of obj
  r

varnamize = (str) ->
  str = str.replace(/^\s+|\s+$/g, '')
  str = str.toLowerCase()
  str = str.replace(/[\s':]/g, '_')
  str = str.replace(/_+/g, '_')

object_keep = (obj, list) ->
  r = {}
  for i in [0...list.length]
    r[list[i]] = obj[list[i]]
  r

min = Math.min
max = Math.max
floor = Math.floor
ceil = Math.ceil