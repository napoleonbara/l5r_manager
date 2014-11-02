
PRIMARY_MAPPING =
  stamina:
    where: '#general + div .table:nth-of-type(2) .row0 .col1'
    type: 'int'
  willpower:
    where: '#general + div .table:nth-of-type(2) .row0 .col3'
    type: 'int'
  strength:
    where: '#general + div .table:nth-of-type(2) .row1 .col1'
    type: 'int'
  perception:
    where: '#general + div .table:nth-of-type(2) .row1 .col3'
    type: 'int'
  agility:
    where: '#general + div .table:nth-of-type(2) .row2 .col1'
    type: 'int'
  intelligence:
    where: '#general + div .table:nth-of-type(2) .row2 .col3'
    type: 'int'
  reflexes:
    where: '#general + div .table:nth-of-type(2) .row3 .col1'
    type: 'int'
  awareness:
    where: '#general + div .table:nth-of-type(2) .row3 .col3'
    type: 'int'
  void:
    where: '#general + div .table:nth-of-type(2) .row4 .col1'
    type: 'int'
  status:
    where: '#general + div .table:nth-of-type(3) .row0 .col1'
    type: 'rank'
  glory:
    where: '#general + div .table:nth-of-type(3) .row0 .col3'
    type: 'rank'
  honor:
    where: '#general + div .table:nth-of-type(3) .row0 .col5'
    type: 'rank'
  taint:
    where: '#general + div .table:nth-of-type(3) .row0 .col7'
    type: 'rank'
  wounds_healthy:
    where: '#wounds + div .table:nth-of-type(1) .row1 .col2'
    type: 'int'
  wounds_nicked:
    where: '#wounds + div .table:nth-of-type(1) .row2 .col2'
    type: 'int'
  wounds_grazed:
    where: '#wounds + div .table:nth-of-type(1) .row3 .col2'
    type: 'int'
  wounds_hurt:
    where: '#wounds + div .table:nth-of-type(1) .row4 .col2'
    type: 'int'
  wounds_injured:
    where: '#wounds + div .table:nth-of-type(1) .row5 .col2'
    type: 'int'
  wounds_crippled:
    where: '#wounds + div .table:nth-of-type(1) .row6 .col2'
    type: 'int'
  wounds_down:
    where: '#wounds + div .table:nth-of-type(1) .row7 .col2'
    type: 'int'
  wounds_out:
    where: '#wounds + div .table:nth-of-type(1) .row8 .col2'
    type: 'int'
  skills:
    where: '#skills + div .table:nth-of-type(1) tr:gt(0)'
    type: ($sel) ->
      result = []
      $sel.each ->
        name = varnamize($(this).find('.col0 a').text())
        val = Number($(this).find('.col2').text())
        result.push([name, val])
      result


SECONDARY_MAPPING =
  earth:
    where: '#general + div .table:nth-of-type(2) .row0 .col5'
    type: 'int'
  water:
    where: '#general + div .table:nth-of-type(2) .row1 .col5'
    type: 'int'
  fire:
    where: '#general + div .table:nth-of-type(2) .row2 .col5'
    type: 'int'
  air:
    where: '#general + div .table:nth-of-type(2) .row3 .col5'
    type: 'int'
  insight:
    where: '#general + div .table:nth-of-type(1) .row1 .col1'
    type: 'int'
  insight_rank:
    where: '#general + div .table:nth-of-type(1) .row1 .col3'
    type: 'int'
  wounds_healthy_max:
    where: '#wounds + div .table:nth-of-type(1) .row1 .col1'
    type: 'int'
  wounds_nicked_max:
    where: '#wounds + div .table:nth-of-type(1) .row2 .col1'
    type: 'int'
  wounds_grazed_max:
    where: '#wounds + div .table:nth-of-type(1) .row3 .col1'
    type: 'int'
  wounds_hurt_max:
    where: '#wounds + div .table:nth-of-type(1) .row4 .col1'
    type: 'int'
  wounds_injured_max:
    where: '#wounds + div .table:nth-of-type(1) .row5 .col1'
    type: 'int'
  wounds_crippled_max:
    where: '#wounds + div .table:nth-of-type(1) .row6 .col1'
    type: 'int'
  wounds_down_max:
    where: '#wounds + div .table:nth-of-type(1) .row7 .col1'
    type: 'int'
  wounds_out_max:
    where: '#wounds + div .table:nth-of-type(1) .row8 .col1'
    type: 'int'

SHEET_MAPPING = merge_objects(PRIMARY_MAPPING, SECONDARY_MAPPING)






sheet = {}
char = {}




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
  
$ ->

  sheet = new CharacterSheet(SHEET_MAPPING)
  char = Character.from_sheet(sheet)

  sheet.set char
    # earth               : char.earth()
    # fire                : char.fire()
    # water               : char.water()
    # air                 : char.air()
    # insight             : char.insight()
    # insight_rank        : char.insight_rank()
    # wounds_healthy_max  : char.wounds_healthy_max()
    # wounds_nicked_max   : char.wounds_nicked_max()
    # wounds_grazed_max   : char.wounds_grazed_max()
    # wounds_hurt_max     : char.wounds_hurt_max()
    # wounds_injured_max  : char.wounds_injured_max()
    # wounds_crippled_max : char.wounds_crippled_max()
    # wounds_down_max     : char.wounds_down_max()
    # wounds_out_max      : char.wounds_out_max()

  sheet.regroup_effects('#fast_reference + div')
