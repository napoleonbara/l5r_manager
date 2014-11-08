$ ->
  parse = dice_roller_parser.parse
    
  evaluate = (t) ->
    switch t.type
      when 'number' then Number(t.value)
      when 'symbol' then sheet.full_map()[t.value]
      when 'explicit roll'

        roll: evaluate(t.roll)
        keep: evaluate(t.keep)
        explode: t.explode
      when 'skill roll'
        a = evaluate(t.trait);
        b = evaluate(t.skill);

        roll: a + b
        keep: a
        explode: t.explode

  get_dice_result = ->
    r = 0
    $("#dice_result td").each ->
      if $(this).hasClass('keep')
        r += Number($(this).text())
    $('#dices_sum').text("result: "+r)
  
  $('#dice_roller input[type=button]').click ->
    input = $("#dice_roller input[type=text]").val()
    out = $("#dice_result")
    if input.length
      t = parse(input)
      roll = evaluate(t)

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
          get_dice_result()

      for i in [0...roll.keep]
        row.find("td:nth-child(#{i+1})").toggleClass('keep')

      get_dice_result()

  roll_each_die = (roll) ->
    roll_method = if roll.explode then exploding_d10_roll else fair_d10_roll
    (roll_method() for i in [0...roll.roll])

  exploding_d10_roll = (threshold = 10) ->
    re_roll = true
    result = 0
    while re_roll
      r = fair_d10_roll()
      result += r
      re_roll = r >= threshold
    result
  
  fair_d10_roll = () -> Math.floor(Math.random() * 10) + 1


