class Character
  constructor: (attributes) ->
    for attribute, value of attributes
      @[attribute] = value

    @earth               = @earth()
    @fire                = @fire()
    @water               = @water()
    @air                 = @air()
    @insight             = @insight()
    @insight_rank        = @insight_rank()
    @wounds_healthy_max  = @wounds_healthy_max()
    @wounds_nicked_max   = @wounds_nicked_max()
    @wounds_grazed_max   = @wounds_grazed_max()
    @wounds_hurt_max     = @wounds_hurt_max()
    @wounds_injured_max  = @wounds_injured_max()
    @wounds_crippled_max = @wounds_crippled_max()
    @wounds_down_max     = @wounds_down_max()
    @wounds_out_max      = @wounds_out_max()

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
      [name, val] = skill
      from_skills += val
      for insight_bonus_level in SKILLS[name]
        if val >= insight_bonus_level
          from_mastery += SKILLS[name][insight_bonus_level]

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
