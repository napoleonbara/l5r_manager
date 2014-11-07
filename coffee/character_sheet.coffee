
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
          @[attr].text("#{val.rank}.#{val.points}")
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
            [rank, points] = @[attr].text().split('.').map(Number)
            return rank: rank, points: points 
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
        content = ["<strong>#{category}</strong>:", effect_str]
        content.push "<em>(#{effect_attr.why})<em>" if effect_attr.why?
        $where.append("<li class='level1' ><div class='li'>"+
          content.join(' ')+
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
    
    expressions = str.match(/#\{[^\}]+\}/g)
    
    if expressions
      map = merge_objects(@map(@mapping, true),
        floor: Math.floor
        ceil:  Math.ceil
        max:   Math.max
        min:   Math.min )
    
      values = for expression in expressions
        expression = expression.replace('#{', '').replace('}', '')
        parsed = expression_parser.parse(expression)
        @evaluate(parsed, map)
      
      for i in [0...expressions.length]
        str = str.replace(expressions[i], values[i])
    
    return str
    
  evaluate: (tree, map) ->
    switch tree.type
      when 'symbol'       then map[tree.val]
      when 'number'       then tree.val
      when 'function call'then @evaluate(tree.func, map)(@evaluate(tree.arg, map))
      when '*'            then @evaluate(tree.left, map) * @evaluate(tree.right, map)
      when '/'            then @evaluate(tree.left, map) / @evaluate(tree.right, map)
      when '+'            then @evaluate(tree.left, map) + @evaluate(tree.right, map)
      when '-'            then @evaluate(tree.left, map) - @evaluate(tree.right, map)
      when 'dot'          then @evaluate(tree.left, map)[tree.right.val]
    
  complete: ->
    map = @map(@primaries)
    for name, properties of @secondaries
      map[name] = properties.compute.call(map)
      @set(name, map[name])
  
  hide_skills_zero: ->
    @skills.find('.col2')
      .filter ->
        Number(trim($(this).text())) == 0
      .parent()
      .hide()
  
sheet = null;
  
$ ->

  sheet = new CharacterSheet(PRIMARY_MAPPING, SECONDARY_MAPPING)

  sheet.complete()

  sheet.regroup_effects('#fast_reference + div')
  
  sheet.hide_skills_zero()
