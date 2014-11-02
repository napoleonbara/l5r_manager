
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
      for elem in $sel.toArray()
        category: varnamize($(elem).find('.col0 a').text())
        name    : $(elem).find('.col0').text()
        emphases: $(elem).find('.col1').text()
        rank    : Number($(elem).find('.col2').text())

SECONDARY_MAPPING =
  earth:
    where: '#general + div .table:nth-of-type(2) .row0 .col5'
    type: 'int'
    compute: ->
      min(@willpower, @stamina)
  water:
    where: '#general + div .table:nth-of-type(2) .row1 .col5'
    type: 'int'
    compute: ->
      min(@perception, @strength)
  fire:
    where: '#general + div .table:nth-of-type(2) .row2 .col5'
    type: 'int'
    compute: ->
      min(@intelligence, @agility)
  air:
    where: '#general + div .table:nth-of-type(2) .row3 .col5'
    type: 'int'
    compute: ->
      min(@awareness, @reflexes)
  insight:
    where: '#general + div .table:nth-of-type(1) .row1 .col1'
    type: 'int'
    compute: ->
      from_rings = (@earth + @water + @air + @fire + @void) * 10
      from_skills = 0
      from_mastery = 0
      for skill in @skills
        from_skills += skill.rank
        for insight_bonus_level in SKILLS[skill.category]
          if skill.rank >= insight_bonus_level
            from_mastery += SKILLS[skill.category][insight_bonus_level]
      from_rings + from_skills + from_mastery

  insight_rank:
    where: '#general + div .table:nth-of-type(1) .row1 .col3'
    type: 'int'
    compute: ->
      max(1, floor((@insight - 150) / 25) + 2)
  wounds_healthy_max:
    where: '#wounds + div .table:nth-of-type(1) .row1 .col1'
    type: 'int'
    compute: ->
      @earth * 2
  wounds_nicked_max:
    where: '#wounds + div .table:nth-of-type(1) .row2 .col1'
    type: 'int'
    compute: ->
      @earth * 2
  wounds_grazed_max:
    where: '#wounds + div .table:nth-of-type(1) .row3 .col1'
    type: 'int'
    compute: ->
      @earth * 2
  wounds_hurt_max:
    where: '#wounds + div .table:nth-of-type(1) .row4 .col1'
    type: 'int'
    compute: ->
      @earth * 2
  wounds_injured_max:
    where: '#wounds + div .table:nth-of-type(1) .row5 .col1'
    type: 'int'
    compute: ->
      @earth * 2
  wounds_crippled_max:
    where: '#wounds + div .table:nth-of-type(1) .row6 .col1'
    type: 'int'
    compute: ->
      @earth * 2
  wounds_down_max:
    where: '#wounds + div .table:nth-of-type(1) .row7 .col1'
    type: 'int'
    compute: ->
      @earth * 2
  wounds_out_max:
    where: '#wounds + div .table:nth-of-type(1) .row8 .col1'
    type: 'int'
    compute: ->
      @earth * 5

SHEET_MAPPING = merge_objects(PRIMARY_MAPPING, SECONDARY_MAPPING)