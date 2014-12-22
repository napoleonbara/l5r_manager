$ ->

  get_dice_result = (roll_modificator)->
    r = roll_modificator
    $("#dice_result td").each ->
      if $(this).hasClass('keep')
        r += Number($(this).text())
    $('#dices_sum').text("result: "+r)
  
  $('#dice_roller input[type=button]').click ->
    input = $("#dice_roller input[type=text]").val()
    out = $("#dice_result")

    handle_query = if window.sheet?
      (q) -> window.sheet.handle_query(q)
    else
      window.handle_query 
    
    if input.length
      try
        [result, summary] = handle_query(input)

        switch 
          when typeof result == 'number'
            put_number_result(input, result, summary)
          
          when result.mode == 'L5R'
            roll_l5r(input, result, summary)
          
          when result.mode == 'basic'
            roll_basic(input, result, summary)

      catch err
        message = switch
          when err.name == "SyntaxError"
            "Don't know how to roll \"#{input}\""
          else
            err
        out.html("<div id='summary' style='color: red; font-weight: bold;'>#{message}</div>")

  put_number_result = (input, result, summary) ->
    out = $("#dice_result")
    out.html("<div id='summary'>#{input} = #{result}<div>")

  roll_basic =  (input, result, summary) ->
    out = $("#dice_result")
    dice = roll_each_die(result)
    roll_num = dice.length

    out.html("<div id='summary'>#{result.to_string()}:<div>
              <table><tr></tr></table>
              <div id='dices_sum'><div>")

    row = out.find("tr")
    for i in [0...roll_num]
      row.append('<td>'+dice[i]+'</td>')

  roll_l5r = (input, result, summary) ->
    out = $("#dice_result")
    dice = roll_each_die(result).sort((a,b)-> a < b)
    roll_num = dice.length
    keep_num = result.keep

    out.html("<div id='summary'>#{summary}:<div>
              <div id='thrown'>#{result.to_string()}:<div>
              <table><tr></tr></table>
              <div id='dices_sum'><div>")

    row = out.find("tr")
    for i in [0...roll_num]
      row.append('<td>'+dice[i]+'</td>')

      row.find('td')
        .click ->
          $(this).toggleClass('keep')
          get_dice_result(result.roll_modif)

    for i in [0...keep_num]
      row.find("td:nth-child(#{i+1})").toggleClass('keep')

    get_dice_result(result.roll_modif)

  roll_each_die = (roll) ->
    roll_num = roll.roll
    roll_method = if roll.explode then exploding_roll else fair_roll
    dices = (roll_method(roll.type, roll.explosion_threshold) for i in [0...roll_num])
    dices.map((d)-> d + roll.dice_modif)


  exploding_roll = (type = 6, threshold = null) ->
    threshold ?= type
    re_roll = true
    result = 0
    while re_roll
      r = fair_roll(type)
      result += r
      re_roll = r >= threshold
    result
  
  fair_roll = (type = 6) -> Math.floor(Math.random() * type) + 1


