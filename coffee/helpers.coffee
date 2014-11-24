
Object.merge = (objs...) ->
  r = {}
  Object.merge_with(r, objs...)
  r
  
Object.merge_with = (target, objs...) ->
  for obj in objs
    target[n] = v for n, v of obj

Object.keep_only = (o, keys...) ->
  Object.keep_if(o, (k,v)-> k in keys)

Object.keep_if = (o, predicate) ->
  r = {}
  for key, value of o
    if predicate(key, value) then r[key] = o[key]
  r

Array.equal = (a, b) ->
  switch 
    when a == b              then true
    when not b?              then false
    when a.length != b.length then false
    else
      for i in [0...a.length]
        return false if a[i] != b[i]
      true

Array.include = (a, o) ->
  a.indexOf(o) != -1

Array.popn = (a, n) ->
  (a.pop() for i in [0...n])

String.trim = (s) ->
  s.replace(/^\s+|\s+$/g, '')

String.snake_case = (s) ->
  s.toLowerCase()
   .replace(/[\s':]/g, '_')
   .replace(/_+/g, '_')

String.small_case = (s) ->
  String.snake_case(s).replace(/_/g, ' ')
