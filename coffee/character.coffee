class Character
  constructor: (attributes) ->
    for attribute_name of PRIMARY_MAPPING
      @[attribute_name] = attributes[attribute_name]

    for attribute_name of SECONDARY_MAPPING
      @[attribute_name] = @[attribute_name]()

  earth: ->
    Math.min(@stamina, @willpower)
  
  fire: -> 
    Math.min(@agility, @intelligence)
    
  water: ->
    Math.min(@strength, @perception)
    
  air: ->
    Math.min(@reflexes, @awareness)

  insight: ->
    from_rings = (@earth + @water + @air + @fire + @void) * 10
    from_skills = 0
    from_mastery = 0
    for skill in @skills
      from_skills += skill.rank
      for insight_bonus_level in SKILLS[skill.category]
        if skill.rank >= insight_bonus_level
          from_mastery += SKILLS[skill.category][insight_bonus_level]

    from_rings + from_skills + from_mastery

  wounds_healthy_max: ->
    @earth * 2

  wounds_nicked_max: ->
    @earth * 2

  wounds_grazed_max: ->
    @earth * 2

  wounds_hurt_max: ->
    @earth * 2

  wounds_injured_max: ->
    @earth * 2

  wounds_crippled_max: ->
    @earth * 2

  wounds_down_max: ->
    @earth * 2

  wounds_out_max: ->
    @earth * 5

  insight_rank: ->
    Math.max(1, Math.floor((@insight - 150) / 25) + 2)

Character.from_sheet = (sheet) ->
  new Character(sheet.get(PRIMARY_MAPPING))
