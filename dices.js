$(function(){
  function shuffle(array) {
    var currentIndex = array.length, temporaryValue, randomIndex ;

    // While there remain elements to shuffle...
    while (0 !== currentIndex) {

      // Pick a remaining element...
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex -= 1;

      // And swap it with the current element.
      temporaryValue = array[currentIndex];
      array[currentIndex] = array[randomIndex];
      array[randomIndex] = temporaryValue;
    }

    return array.filter(function(e){return typeof e !== 'undefined'});
  }

  $(function(){
    $('#roll-spinner, #keep-spinner').spinner({
      max: 10,
      min: 1
    }).spinner('value', 1);
    
    $('#roll-button').on('click', function(){
      var to_roll = $('#roll-spinner').spinner('value'),
          to_keep = $('#keep-spinner').spinner('value'),
          reroll_ten = $('#explode-checkbox').prop('checked'),
          dont_sort = $('#dont-sort-checkbox').prop('checked'),
          loose_biggest = $('#loose-biggest-checkbox').prop('checked');
        
      rolls = [];
      for(var r = 0; r < to_roll; r++){
        var series = [];
        do{
          series.push(fair_d10_roll())
        }while(series[series.length - 1] == 10 && reroll_ten);
        rolls.push(series);
      }
      
      var results = new Array(10);
      rolls.forEach(function(roll, i){
        var value = roll.reduce(function(p,c){ return  c + p; }, 0);
        results[i] = value;
      });
      
      results = results
        .sort(function(a,b){return a < b;})
        .map(function(e, i){return {keep: (i < to_keep), result: e};})
      
      if(loose_biggest){
        results.forEach(function(e, i){
          e.keep = (0 < i && i < to_keep + 1);
        });
      }
      
      if(dont_sort){
        results = shuffle(results);
        console.log(results)
        results.forEach(function(e, i){e.keep = false;});
      }
      
      final_result = results
        .map(function(p){return p.keep ? p.result : 0;})
        .reduce(function(p,c){ return  c + p; }, 0);
      
      var $row = $('<tr></tr>')
          .prependTo('#result');
          
      $(results).each(function(i,e){
        if(typeof e != 'undefined'){
          $('<td>'+e.result+'</td>')
            .toggleClass('keep', e.keep)
            .appendTo($row);
        }else{
          $('<td class="empty"></td>').appendTo($row);
        }
      });
      
      $('<td class="sum">'+final_result+'</td>').appendTo($row);
      
    });
    
    function fair_d10_roll(){
      return Math.floor(Math.random() * 10) + 1;
    }
  });
});
