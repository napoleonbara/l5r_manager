SKILLS =
  acting:
    5: 2
    10: 5
  artisan:
    5: 2
    10: 5
  calligraphy:
    5: 2
    10: 5
  courtier:
    5: 2
    10: 5
  divination:
    5: 2
    10: 5
  etiquette:
    5: 2
    10: 5
  games:
    5: 4
    10: 7
  instruction:
    5: 4
    10: 7
  investigation:
      5: 2
      10: 5
  lore:
      5: 4
      10: 7
  medicine:
      5: 2
      10: 5
  meditation:
      5: 2
      7: 2
      10: 5
  performance:
      5: 4
      10: 7
  spellcraft:
      5: 2
      10: 5
  storytelling:
      5: 4
      10: 7
  tea_ceremony:
      5: 2
      10: 5
  theology:
      5: 4
      7: 2
      10: 15
  animal_handling:
      5: 2
      10: 5
  commerce:
      5: 2
      10: 5
  craft:
      5: 4
      10: 7
  engineering:
      5: 2
      10: 5
  locksmith:
      5: 2
      10: 5
  athletics:
      5: 2
      10: 5
  battle:
      5: 2
      10: 5
  chain_weapons:
      5: 2
      10: 5
  heavy_weapons:
      5: 2
      10: 5
  kenjutsu:
      5: 2
      10: 5
  knives:
      5: 2
      10: 5
  kyujutsu:
      5: 2
      10: 5
  ninja_weapons:
      5: 2
      10: 5
  peasant_weapons:
      5: 2
      10: 5
  polearms:
      5: 2
      10: 5
  spears:
      5: 2
      10: 5
  staves:
      5: 2
      10: 5
  war_fans:
      5: 2
      10: 5
  defense:
      5: 2
      10: 5
  horsemanship:
      5: 2
      10: 5
  hunting:
      5: 2
      10: 5
  iaijutsu:
      5: 2
      10: 5
  jiujutsu:
      5: 2
      10: 5
  know_the_school:
      5: 2
      10: 5
  anatomy:
      5: 2
      10: 5
  deceit:
      5: 2
      10: 5
  explosives:
      5: 2
      10: 5
  forgery:
      5: 2
      10: 5
  poison:
      5: 2
      10: 5
  sleight_of_hand:
      5: 2
      10: 5
  stealth:
      5: 2
      10: 5
  traps:
      5: 2
      10: 5
  underworld:
      5: 2
      10: 5

insight_rank = (insight) ->
  Math.max(1, Math.floor((insight - 150) / 25) + 2)

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

SHEET_MAPPING = merge_objects(PRIMARY_MAPPING, SECONDARY_MAPPING)

map_character_sheet = (mapping) ->
  sheet = {}

  for attr_name, properties of mapping
    sheet[attr_name] = $(properties.where)
  
  sheet.set = (attr, val) ->
    if typeof attr == 'string'
      switch mapping[attr].type
        when 'int'
          sheet[attr].text(val)
        when 'rank'
          sheet[attr].text(val.join('.'))
    else
      for attr_name, value of attr
        sheet.set(attr_name, value)

  sheet.get = (attr) ->
    if typeof attr == 'string'
      if typeof mapping[attr].type == 'function'
        return mapping[attr].type(sheet[attr])
      else
        switch mapping[attr].type
          when 'int'
            return Number(sheet[attr].text())
          when 'rank'
            return sheet[attr].text().split('.').map(Number)
    else
      result = {}
      for attr_name, value of attr
          result[attr_name] = sheet.get(attr_name)
      return result

  return sheet


compute_insight = (char) ->
  from_rings = (char.earth + char.water + char.air + char.fire + char.void) * 10
  from_skills = 0
  char.skills.forEach( (skill) ->
    [name, val] = skill
    from_skills += val
    for insight_bonus_level in SKILLS[name]
      if val >= insight_bonus_level
        from_skills += SKILLS[name][insight_bonus_level]
  )
  from_rings + from_skills


parse_character_sheet = (sheet) ->
  r = sheet.get(PRIMARY_MAPPING)
  r.skills.forEach( (skill) ->
    if ['iaijutsu'].indexOf(skill[0]) != -1 then r[skill[0]] = skill[1]
  )
  r


sheet = {}
char = {}

get_all_effects = ->
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


format_effect = (str) ->
  str = str.replace(/^\s+|\s+$/g, '')
  str = '"' + str.replace('#{','"+(').replace('}',')+"')+'"'
  str = str.replace('$', 'char.')
  try
    str = eval(str)
  catch err
    str = err

  return str


regroup_effects = (effects, where) ->
  $where = $(where).find('ul')

  for domain, domain_effects of effects
    for effect_attr in domain_effects
      effect_str = format_effect(effect_attr.effect)
      $where.append("<li class='level1' title='#{effect_attr.because}'>" + 
        "<div class='li'><strong>#{domain}</strong>: #{effect_str}</div></li>")

$ ->

  sheet = map_character_sheet(SHEET_MAPPING)
  char = parse_character_sheet(sheet)

  char.earth = Math.min(char.stamina, char.willpower)
  char.fire  = Math.min(char.agility, char.intelligence)
  char.water = Math.min(char.strength, char.perception)
  char.air   = Math.min(char.reflexes, char.awareness)
  char.insight = compute_insight(char)
  char.insight_rank = insight_rank(char.insight)
  char.wounds_healthy_max = char.earth * 2
  char.wounds_nicked_max = char.earth * 2
  char.wounds_grazed_max = char.earth * 2
  char.wounds_hurt_max = char.earth * 2
  char.wounds_injured_max = char.earth * 2
  char.wounds_crippled_max = char.earth * 2
  char.wounds_down_max = char.earth * 2
  char.wounds_out_max = char.earth * 5

  sheet.set(object_keep(char, Object.keys(SECONDARY_MAPPING)))

  all_effects = get_all_effects()
  regroup_effects(all_effects, '#fast_reference + div')