// Generated by CoffeeScript 1.6.3
(function() {
  $(function() {
    var apply_modificator, evaluate, evaluate_roll, exploding_d10_roll, fair_d10_roll, get_dice_result, parse, roll_each_die;
    parse = dice_roller_parser.parse;
    apply_modificator = function(roll, modif) {
      switch (modif.type) {
        case 'dice modificator':
          return roll.dice_modificator += modif.value;
        case 'explosion modificator':
          return roll.explosion_threshold = Math.min(modif.value, roll.explosion_threshold);
        case 'roll bonus':
          return roll.roll_modificator += modif.value;
        case 'roll penalty':
          return roll.roll_modificator -= modif.value;
      }
    };
    evaluate_roll = function(t) {
      var tmp;
      tmp = merge_objects({
        roll: 0,
        keep: 0,
        explode: true,
        explosion_threshold: 10,
        dice_modificator: 0,
        roll_modificator: 0,
        modificators: []
      }, evaluate(t));
      tmp.modificators.forEach(function(m) {
        return apply_modificator(tmp, m);
      });
      delete tmp.modificators;
      return tmp;
    };
    evaluate = function(t) {
      var a, b;
      switch (t.type) {
        case 'number':
          return Number(t.value);
        case 'symbol':
          return sheet.full_map()[t.value];
        case 'explicit roll':
          return {
            roll: evaluate(t.roll),
            keep: evaluate(t.keep),
            explode: t.explode,
            modificators: t.modificators.map(evaluate)
          };
        case 'skill roll':
          a = evaluate(t.trait);
          b = evaluate(t.skill);
          return {
            roll: a + b,
            keep: a,
            explode: t.explode,
            modificators: t.modificators.map(evaluate)
          };
        case 'trait roll':
          return {
            roll: evaluate(t.roll),
            keep: evaluate(t.roll),
            explode: t.explode,
            modificators: t.modificators.map(evaluate)
          };
        case 'flat roll':
          return {
            roll: evaluate(t.roll),
            explode: false
          };
        case 'dot':
          return evaluate(t.left)[evaluate(t.right)];
        case '+':
          return evaluate(t.left) + evaluate(t.right);
        case '-':
          return evaluate(t.left) - evaluate(t.right);
        case '*':
          return evaluate(t.left) * evaluate(t.right);
        case '/':
          return evaluate(t.left) / evaluate(t.right);
        case 'function call':
          return evaluate(t.name).apply(null, t["arguments"].map(evaluate));
        case 'dice modificator':
          return {
            type: 'dice modificator',
            value: evaluate(t.value)
          };
        case 'explosion modificator':
          return {
            type: 'explosion modificator',
            value: evaluate(t.value)
          };
        case 'roll bonus':
          return {
            type: 'roll bonus',
            value: evaluate(t.value)
          };
        case 'roll penalty':
          return {
            type: 'roll penalty',
            value: evaluate(t.value)
          };
      }
    };
    get_dice_result = function(roll_modificator) {
      var r;
      r = roll_modificator;
      $("#dice_result td").each(function() {
        if ($(this).hasClass('keep')) {
          return r += Number($(this).text());
        }
      });
      return $('#dices_sum').text("result: " + r);
    };
    $('#dice_roller input[type=button]').click(function() {
      var dices, i, input, out, roll, row, t, _i, _j, _ref, _ref1;
      input = $("#dice_roller input[type=text]").val();
      out = $("#dice_result");
      if (input.length) {
        try {
          t = parse(input);
          roll = evaluate_roll(t);
          dices = roll_each_die(roll);
          if (roll.type !== 'flat roll') {
            dices = dices.sort(function(a, b) {
              return a < b;
            });
          }
          out.html("<div id='summary'>" + roll.roll + "K" + roll.keep + ":<div>          <table><tr></tr></table>          <div id='dices_sum'><div>");
          row = out.find("tr");
          for (i = _i = 0, _ref = roll.roll; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
            row.append('<td>' + dices[i] + '</td>');
          }
          row.find('td').click(function() {
            $(this).toggleClass('keep');
            return get_dice_result(roll.roll_modificator);
          });
          for (i = _j = 0, _ref1 = roll.keep; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
            row.find("td:nth-child(" + (i + 1) + ")").toggleClass('keep');
          }
          return get_dice_result(roll.roll_modificator);
        } catch (_error) {
          return out.html("<div id='summary'>don't know how to roll " + input + "</div>");
        }
      }
    });
    roll_each_die = function(roll) {
      var dices, i, roll_method;
      roll_method = roll.explode ? exploding_d10_roll : fair_d10_roll;
      dices = (function() {
        var _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = roll.roll; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(roll_method(roll.explosion_threshold));
        }
        return _results;
      })();
      return dices.map(function(d) {
        return d + roll.dice_modificator;
      });
    };
    exploding_d10_roll = function(threshold) {
      var r, re_roll, result;
      if (threshold == null) {
        threshold = 10;
      }
      re_roll = true;
      result = 0;
      while (re_roll) {
        r = fair_d10_roll();
        result += r;
        re_roll = r >= threshold;
      }
      return result;
    };
    return fair_d10_roll = function() {
      return Math.floor(Math.random() * 10) + 1;
    };
  });

}).call(this);

/*
//@ sourceMappingURL=dices.map
*/
