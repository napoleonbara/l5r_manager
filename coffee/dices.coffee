$ ->
  shuffle = (array) ->
    currentIndex = array.length

    # While there remain elements to shuffle...
    while 0 != currentIndex
      # Pick a remaining element...
      randomIndex = Math.floor(Math.random() * currentIndex)
      currentIndex -= 1

      # And swap it with the current element.
      temporaryValue = array[currentIndex]
      array[currentIndex] = array[randomIndex]
      array[randomIndex] = temporaryValue

    array.filter( (e)-> e? )


$ ->
  $('#roll-spinner, #keep-spinner').spinner(
    max: 10
    min: 1
  ).spinner('value', 1);
  
  $('#roll-button').click( ->
    to_roll = $('#roll-spinner').spinner('value')
    to_keep = $('#keep-spinner').spinner('value')
    explode = $('#explode-checkbox').prop('checked')
    dont_sort = $('#dont-sort-checkbox').prop('checked')
    loose_biggest = $('#loose-biggest-checkbox').prop('checked')

    roll_method = if explode then exploding_d10_roll else fair_d10_roll
    rolls = (roll_method() for i in [0...to_roll])

    results = (rolls[i] for i in [0...10])
    
    results = results
      .sort( (a,b) -> a < b )
      .map( (e, i) ->
        keep: i < to_keep
        result: e
      )
    
    if loose_biggest
      results.forEach( (e, i) ->
        e.keep = (0 < i and i < to_keep + 1)
      )

    if dont_sort
      results = shuffle(results)
      results.forEach( (e, i) -> e.keep = false )

    final_result = results
      .map( (p) -> if p.keep then p.result else 0 )
      .reduce( ((p,c) -> c + p), 0 )

    $row = $('<tr></tr>')
      .prependTo('#result')
        
    $(results).each( (i,e) ->
      if e.result?
        $("<td>#{e.result}</td>")
          .toggleClass('keep', e.keep)
          .appendTo($row)
      else
        $('<td class="empty"></td>').appendTo($row)

    )
    
    $("<td class='sum'>#{final_result}</td>").appendTo($row)
    
  )
  
  exploding_d10_roll = (threshold = 10) ->
    re_roll = true
    result = 0
    while re_roll
      r = fair_d10_roll()
      result += r
      re_roll = r >= threshold
    result
  
  fair_d10_roll = () -> Math.floor(Math.random() * 10) + 1

