
class CharacterSheet
  constructor: (@primaries, @secondaries) ->
    @mapping = merge_objects(@primaries, @secondaries)
    for attr_name, properties of @mapping
      @[attr_name] = $(properties.where)

  set: (attr, val) ->
    if typeof attr == 'string'
      switch @mapping[attr].type
        when 'int'
          @[attr].text(val)
        when 'rank'
          @[attr].text(val.join('.'))
    else
      for attr_name, value of attr
        @set(attr_name, value)

  get: (attr) ->
    if typeof attr == 'string'
      if typeof @mapping[attr].type == 'function'
        return @mapping[attr].type(@[attr])
      else
        switch @mapping[attr].type
          when 'int'
            return Number(@[attr].text())
          when 'rank'
            return @[attr].text().split('.').map(Number)
    else
      result = {}
      for attr_name, value of attr
          result[attr_name] = @get(attr_name)
      return result

  regroup_effects: (where) ->
    $where = $(where).find('ul')
    effect_dict = @get_all_effects()

    for category, effects of effect_dict
      for effect_attr in effects
        effect_str = @format_effect(effect_attr.effect)
        $where.append("<li class='level1' ><div class='li'>"+
          "<strong>#{category}</strong>: #{effect_str} <em>(#{effect_attr.why})<em>"+
          "</div></li>")

  get_all_effects: ->
    effects_record = {}
    $('effect').each () ->
      category = $(this).attr('cat')
      why = $(this).attr('why')
      effect = $(this).attr('effect')

      unless effects_record[category] then effects_record[category] = []
      effects_record[category].push
        why: why
        effect: effect

    effects_record
  
  map: (dict, with_skills = false) ->
    r = {}
    r[n] = @get(n) for n of dict
    if with_skills
      r[s.var_name] = s.rank for s in @get('skills')
    r
  
  format_effect: (str) ->
    str = str.replace(/^\s+|\s+$/g, '')
    str = '"' + str.replace(/#\{/g,'"+(').replace(/\}/g',')+"')+'"'
    str = str.replace(/@/g, '_map_.')
    _map_ = @map(@mapping, true)
    try
      str = eval(str)
    catch err
      str = err
  
    return str
    
  complete: ->
    map = @map(@primaries)
    for name, properties of @secondaries
      map[name] = properties.compute.call(map)
      @set(name, map[name])
  
$ ->

  sheet = new CharacterSheet(PRIMARY_MAPPING, SECONDARY_MAPPING)

  sheet.complete()

  sheet.regroup_effects('#fast_reference + div')
