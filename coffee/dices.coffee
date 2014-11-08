$ ->
  parse = dice_roller_parser.parse
  
  apply_modificator = (roll, modif) ->
    switch modif.type
      when 'dice modificator'
        roll.dice_modificator += modif.value
      when 'explosion modificator'
        roll.explosion_threshold = Math.min(modif.value, roll.explosion_threshold)
      when 'roll bonus'
        roll.roll_modificator += modif.value
      when 'roll penalty'
        roll.roll_modificator -= modif.value

  evaluate_roll = (t) ->
    tmp = merge_objects(
      {
        roll: 0
        keep: 0
        explode: true
        explosion_threshold: 10
        dice_modificator: 0
        roll_modificator: 0
        modificators: []
      },
      evaluate(t))
    
    tmp.modificators.forEach (m) ->
      apply_modificator(tmp, m)
    
    delete tmp.modificators
    
    tmp 
     
  evaluate = (t) ->
    switch t.type
      when 'number' then Number(t.value)
      when 'symbol' then sheet.full_map()[t.value]
      when 'explicit roll'

        roll: evaluate(t.roll)
        keep: evaluate(t.keep)
        explode: t.explode
        modificators: t.modificators.map(evaluate)
        
      when 'skill roll'
        a = evaluate(t.trait);
        b = evaluate(t.skill);

        roll: a + b
        keep: a
        explode: t.explode
        modificators: t.modificators.map(evaluate)

      when 'trait roll'

        roll: evaluate(t.roll)
        keep: evaluate(t.roll)
        explode: t.explode
        modificators: t.modificators.map(evaluate)

      when 'flat roll'
        roll: evaluate(t.roll)
        explode: false
      when 'dot'
        evaluate(t.left)[evaluate(t.right)]
      when '+'
        evaluate(t.left) + evaluate(t.right)
      when '-'
        evaluate(t.left) - evaluate(t.right)
      when '*'
        evaluate(t.left) * evaluate(t.right)
      when '/'
        evaluate(t.left) / evaluate(t.right)
      when 'function call'
        evaluate(t.name).apply(null, t.arguments.map(evaluate))
      when 'dice modificator'
        type: 'dice modificator'
        value: evaluate(t.value)
      when 'explosion modificator'
        type: 'explosion modificator'
        value: evaluate(t.value)
      when 'roll bonus'
        type: 'roll bonus'
        value: evaluate(t.value)
      when 'roll penalty'
        type: 'roll penalty'
        value: evaluate(t.value)
  
  get_dice_result = (roll_modificator)->
    r = roll_modificator
    $("#dice_result td").each ->
      if $(this).hasClass('keep')
        r += Number($(this).text())
    $('#dices_sum').text("result: "+r)
  
  $('#dice_roller input[type=button]').click ->
    input = $("#dice_roller input[type=text]").val()
    out = $("#dice_result")
    if input.length
      try
        t = parse(input)
        roll = evaluate_roll(t)
         
        dices = roll_each_die(roll).sort((a,b) -> a < b)
      
        out.html("<div id='summary'>#{roll.roll}K#{roll.keep}:<div>
          <table><tr></tr></table>
          <div id='dices_sum'><div>")
                 
        row = out.find("tr")
  
        for i in [0...roll.roll]
          row.append('<td>'+dices[i]+'</td>')
  
        row.find('td')
          .click ->
            $(this).toggleClass('keep')
            get_dice_result(roll.roll_modificator)
  
        for i in [0...roll.keep]
          row.find("td:nth-child(#{i+1})").toggleClass('keep')
  
        get_dice_result(roll.roll_modificator)
      
      catch
        out.html("<div id='summary'>don't know how to roll #{input}</div>")

  roll_each_die = (roll) ->
    roll_method = if roll.explode then exploding_d10_roll else fair_d10_roll
    dices = (roll_method(roll.explosion_threshold) for i in [0...roll.roll])
    dices.map((d)-> d + roll.dice_modificator)


  exploding_d10_roll = (threshold = 10) ->
    re_roll = true
    result = 0
    while re_roll
      r = fair_d10_roll()
      result += r
      re_roll = r >= threshold
    result
  
  fair_d10_roll = () -> Math.floor(Math.random() * 10) + 1


