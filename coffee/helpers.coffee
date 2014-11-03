merge_objects = (objs...) ->
  r = {};
  for obj in objs
    r[n] = v for n, v of obj
  r

varnamize = (str) ->
  str = trim(str)
  str = str.toLowerCase()
  str = str.replace(/[\s':]/g, '_')
  str = str.replace(/_+/g, '_')

trim = (str) ->
  str.replace(/^\s+|\s+$/g, '')

object_keep = (obj, list) ->
  r = {}
  for i in [0...list.length]
    r[list[i]] = obj[list[i]]
  r

min = Math.min
max = Math.max
floor = Math.floor
ceil = Math.ceil