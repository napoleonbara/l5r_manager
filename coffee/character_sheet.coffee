
 class CharacterSheet
  constructor: (@mapping) ->
    
    is_computable = (v) -> v.compute?
    primary_attributes =  Object.keep_if(@mapping, (k,v) -> not is_computable(v))
    #computable_attributes = Object.keep_if(@mapping, (k,v) -> is_computable(v))

    for attr_name, properties of @mapping
      properties.where = $(properties.where)
    
    # mapping rank attributes
    
    for attr_name, properties of primary_attributes
      switch properties.type
        when 'rank'
          value = properties.where.text()
          [rank, points] = value.split('.').map(Number)
          @mapping["#{attr_name} rank"] =
            value: rank
          @mapping["#{attr_name} points"] =
            value: points
          delete @mapping[attr_name]
        when 'int'
          properties.value = Number(properties.where.text())

    # mapping skills

    sheet_mapping = @mapping
    @mapping.skills.where.each (i, elem) ->
      var_name = String.trim(String.small_case($(elem).find('.col0').text()))
      sheet_mapping[var_name] =
        pretty_name : String.trim($(elem).find('.col0').text())
        category    : String.snake_case(String.trim($(elem).find('.col0 a').text()))
        emphases    : String.trim($(elem).find('.col1').text())
        value       : Number($(elem).find('.col2').text())
    delete @mapping.skills


  complete: ->
    # mapping computables
    context = @evaluation_context()
    
    for trait in [ "earth", "fire", "water", "air", "wound level normal", "wound level out",
      "tn to be hit", "insight", "insight rank", "initiative"]
      
      val = switch trait
        when 'insight'
          @compute_insight()
        when 'insight rank'
          @compute_insight_rank()
        else
          window.handle_query(context, @mapping[trait].compute)
      
      @mapping[trait].value = context[trait] = val
      @mapping[trait].where.text(val) if @mapping[trait].where?

    sheet.apply_rules()
    sheet.put_notes()
  

  evaluation_context: ->
    unless @context?
      @context = context = {}
      for attr_name, properties of @mapping
        if properties.value?
          context[attr_name] = properties.value
          
      @context = Object.merge(context,
        floor: (args) -> Math.floor(args[0])
        max: (args) -> Math.max.apply(null, args)
        min: (args) -> Math.min.apply(null, args)
        ceil: (args) -> Math.ceil(args[0])
        'void point': @handle_query('1K1')
      )
    @context

  compute_insight_rank: ->
    Math.max(1, Math.floor((@mapping.insight.value - 150) / 25) + 2)

  compute_insight: ->
    mapping = @mapping
    from_rings = ["earth", "fire", "water", "air", "void"].reduce(((r, e) -> r + mapping[e].value), 0) * 10
    from_skills = 0
    from_mastery = 0
    for name, skill of Object.keep_if( @mapping, (k,v) -> v.emphases? )
      from_skills += skill.value
      for insight_bonus_level in SKILLS[skill.category]
        if skill.rank >= insight_bonus_level
          from_mastery += SKILLS[skill.category][insight_bonus_level]
    from_rings + from_skills + from_mastery

  handle_rule: (rule) ->
    window.handle_rule(@evaluation_context(), rule)

  handle_query: (exp) ->
    window.handle_query(@evaluation_context(), exp)

  apply_rules: ->
    i = 0
    ids = while (id = "#rules#{if i > 0 then i else ''}"; i++; $(id).length > 0)
      id
    rules = $(ids.join(', ')).next().find('p').map(-> String.trim($(@).text())).toArray()

    for rule in rules
      @handle_rule(rule)

  put_notes: ->
    i = 0
    ids = while (id = "#notes#{if i > 0 then i else ''}"; i++; $(id).length > 0)
      id
    notes = $(ids.join(', ')).next().find('p').map(-> String.trim($(@).text())).toArray()

    for note in notes
      $('#fast_reference + div ul').append("<li>#{note}</li>")


$ ->

  window.sheet = sheet = new CharacterSheet(MAPPING)
  
  sheet.complete()
  
  $('#dice_roller input[type=button]').click ->
    expression = $('#dice_roller input[type=text]').val()
    result = sheet.handle_query(expression)

