
class CharacterSheet
  constructor: (@mapping) ->
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
    effects = @get_all_effects()

    for domain, domain_effects of effects
      for effect_attr in domain_effects
        effect_str = @format_effect(effect_attr.effect)
        $where.append("<li class='level1' title='#{effect_attr.because}'>" + 
          "<div class='li'><strong>#{domain}</strong>: #{effect_str}</div></li>")

  get_all_effects: ->
    effects_record = {}
    $('.effects > *').each( () ->
      tag = this.tagName.toLowerCase()
      because = $(this).attr('because')
      effect = $(this).text()
  
      unless effects_record[tag] then effects_record[tag] = []
      effects_record[tag].push
        because: because
        effect: effect
    )
    effects_record
  
  format_effect: (str) ->
    str = str.replace(/^\s+|\s+$/g, '')
    str = '"' + str.replace('#{','"+(').replace('}',')+"')+'"'
    str = str.replace('$', 'char.')
    try
      str = eval(str)
    catch err
      str = err
  
    return str
    
  complete: (secondaries) ->
    map = {}
    map[n] = @get(n) for n of PRIMARY_MAPPING
    for name, properties of secondaries
      map[name] = properties.compute.call(map)
      @set(name, map[name])
  
$ ->

  sheet = new CharacterSheet(SHEET_MAPPING)

  sheet.complete(SECONDARY_MAPPING)

  sheet.regroup_effects('#fast_reference + div')
