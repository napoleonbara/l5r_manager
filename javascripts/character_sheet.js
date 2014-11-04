// Generated by CoffeeScript 1.6.3
(function() {
  var CharacterSheet, PRIMARY_MAPPING, SECONDARY_MAPPING, SHEET_MAPPING, SKILLS, ceil, floor, max, merge_objects, min, object_keep, trim, varnamize,
    __slice = [].slice;

  SKILLS = {
    acting: {
      5: 2,
      10: 5
    },
    artisan: {
      5: 2,
      10: 5
    },
    calligraphy: {
      5: 2,
      10: 5
    },
    courtier: {
      5: 2,
      10: 5
    },
    divination: {
      5: 2,
      10: 5
    },
    etiquette: {
      5: 2,
      10: 5
    },
    games: {
      5: 4,
      10: 7
    },
    instruction: {
      5: 4,
      10: 7
    },
    investigation: {
      5: 2,
      10: 5
    },
    lore: {
      5: 4,
      10: 7
    },
    medicine: {
      5: 2,
      10: 5
    },
    meditation: {
      5: 2,
      7: 2,
      10: 5
    },
    performance: {
      5: 4,
      10: 7
    },
    spellcraft: {
      5: 2,
      10: 5
    },
    storytelling: {
      5: 4,
      10: 7
    },
    tea_ceremony: {
      5: 2,
      10: 5
    },
    theology: {
      5: 4,
      7: 2,
      10: 15
    },
    animal_handling: {
      5: 2,
      10: 5
    },
    commerce: {
      5: 2,
      10: 5
    },
    craft: {
      5: 4,
      10: 7
    },
    engineering: {
      5: 2,
      10: 5
    },
    locksmith: {
      5: 2,
      10: 5
    },
    athletics: {
      5: 2,
      10: 5
    },
    battle: {
      5: 2,
      10: 5
    },
    chain_weapons: {
      5: 2,
      10: 5
    },
    heavy_weapons: {
      5: 2,
      10: 5
    },
    kenjutsu: {
      5: 2,
      10: 5
    },
    knives: {
      5: 2,
      10: 5
    },
    kyujutsu: {
      5: 2,
      10: 5
    },
    ninja_weapons: {
      5: 2,
      10: 5
    },
    peasant_weapons: {
      5: 2,
      10: 5
    },
    polearms: {
      5: 2,
      10: 5
    },
    spears: {
      5: 2,
      10: 5
    },
    staves: {
      5: 2,
      10: 5
    },
    war_fans: {
      5: 2,
      10: 5
    },
    defense: {
      5: 2,
      10: 5
    },
    horsemanship: {
      5: 2,
      10: 5
    },
    hunting: {
      5: 2,
      10: 5
    },
    iaijutsu: {
      5: 2,
      10: 5
    },
    jiujutsu: {
      5: 2,
      10: 5
    },
    know_the_school: {
      5: 2,
      10: 5
    },
    anatomy: {
      5: 2,
      10: 5
    },
    deceit: {
      5: 2,
      10: 5
    },
    explosives: {
      5: 2,
      10: 5
    },
    forgery: {
      5: 2,
      10: 5
    },
    poison: {
      5: 2,
      10: 5
    },
    sleight_of_hand: {
      5: 2,
      10: 5
    },
    stealth: {
      5: 2,
      10: 5
    },
    traps: {
      5: 2,
      10: 5
    },
    underworld: {
      5: 2,
      10: 5
    }
  };

  merge_objects = function() {
    var n, obj, objs, r, v, _i, _len;
    objs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    r = {};
    for (_i = 0, _len = objs.length; _i < _len; _i++) {
      obj = objs[_i];
      for (n in obj) {
        v = obj[n];
        r[n] = v;
      }
    }
    return r;
  };

  varnamize = function(str) {
    str = trim(str);
    str = str.toLowerCase();
    str = str.replace(/[\s':]/g, '_');
    return str = str.replace(/_+/g, '_');
  };

  trim = function(str) {
    return str.replace(/^\s+|\s+$/g, '');
  };

  object_keep = function(obj, list) {
    var i, r, _i, _ref;
    r = {};
    for (i = _i = 0, _ref = list.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      r[list[i]] = obj[list[i]];
    }
    return r;
  };

  min = Math.min;

  max = Math.max;

  floor = Math.floor;

  ceil = Math.ceil;

  PRIMARY_MAPPING = {
    stamina: {
      where: '#general + div .table:nth-of-type(2) .row0 .col1',
      type: 'int'
    },
    willpower: {
      where: '#general + div .table:nth-of-type(2) .row0 .col3',
      type: 'int'
    },
    strength: {
      where: '#general + div .table:nth-of-type(2) .row1 .col1',
      type: 'int'
    },
    perception: {
      where: '#general + div .table:nth-of-type(2) .row1 .col3',
      type: 'int'
    },
    agility: {
      where: '#general + div .table:nth-of-type(2) .row2 .col1',
      type: 'int'
    },
    intelligence: {
      where: '#general + div .table:nth-of-type(2) .row2 .col3',
      type: 'int'
    },
    reflexes: {
      where: '#general + div .table:nth-of-type(2) .row3 .col1',
      type: 'int'
    },
    awareness: {
      where: '#general + div .table:nth-of-type(2) .row3 .col3',
      type: 'int'
    },
    "void": {
      where: '#general + div .table:nth-of-type(2) .row4 .col1',
      type: 'int'
    },
    status: {
      where: '#general + div .table:nth-of-type(3) .row0 .col1',
      type: 'rank'
    },
    glory: {
      where: '#general + div .table:nth-of-type(3) .row0 .col3',
      type: 'rank'
    },
    honor: {
      where: '#general + div .table:nth-of-type(3) .row0 .col5',
      type: 'rank'
    },
    taint: {
      where: '#general + div .table:nth-of-type(3) .row0 .col7',
      type: 'rank'
    },
    wounds_healthy: {
      where: '#wounds + div .table:nth-of-type(1) .row1 .col2',
      type: 'int'
    },
    wounds_nicked: {
      where: '#wounds + div .table:nth-of-type(1) .row2 .col2',
      type: 'int'
    },
    wounds_grazed: {
      where: '#wounds + div .table:nth-of-type(1) .row3 .col2',
      type: 'int'
    },
    wounds_hurt: {
      where: '#wounds + div .table:nth-of-type(1) .row4 .col2',
      type: 'int'
    },
    wounds_injured: {
      where: '#wounds + div .table:nth-of-type(1) .row5 .col2',
      type: 'int'
    },
    wounds_crippled: {
      where: '#wounds + div .table:nth-of-type(1) .row6 .col2',
      type: 'int'
    },
    wounds_down: {
      where: '#wounds + div .table:nth-of-type(1) .row7 .col2',
      type: 'int'
    },
    wounds_out: {
      where: '#wounds + div .table:nth-of-type(1) .row8 .col2',
      type: 'int'
    },
    skills: {
      where: '#skills + div .table:nth-of-type(1) tr:gt(0)',
      type: function($sel) {
        var elem, _i, _len, _ref, _results;
        _ref = $sel.toArray();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          elem = _ref[_i];
          _results.push({
            category: varnamize($(elem).find('.col0 a').text()),
            var_name: varnamize($(elem).find('.col0').text()),
            pretty_name: $(elem).find('.col0').text(),
            emphases: $(elem).find('.col1').text(),
            rank: Number($(elem).find('.col2').text())
          });
        }
        return _results;
      }
    }
  };

  SECONDARY_MAPPING = {
    earth: {
      where: '#general + div .table:nth-of-type(2) .row0 .col5',
      type: 'int',
      compute: function() {
        return min(this.willpower, this.stamina);
      }
    },
    water: {
      where: '#general + div .table:nth-of-type(2) .row1 .col5',
      type: 'int',
      compute: function() {
        return min(this.perception, this.strength);
      }
    },
    fire: {
      where: '#general + div .table:nth-of-type(2) .row2 .col5',
      type: 'int',
      compute: function() {
        return min(this.intelligence, this.agility);
      }
    },
    air: {
      where: '#general + div .table:nth-of-type(2) .row3 .col5',
      type: 'int',
      compute: function() {
        return min(this.awareness, this.reflexes);
      }
    },
    insight: {
      where: '#general + div .table:nth-of-type(1) .row1 .col1',
      type: 'int',
      compute: function() {
        var from_mastery, from_rings, from_skills, insight_bonus_level, skill, _i, _j, _len, _len1, _ref, _ref1;
        from_rings = (this.earth + this.water + this.air + this.fire + this["void"]) * 10;
        from_skills = 0;
        from_mastery = 0;
        _ref = this.skills;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          skill = _ref[_i];
          from_skills += skill.rank;
          _ref1 = SKILLS[skill.category];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            insight_bonus_level = _ref1[_j];
            if (skill.rank >= insight_bonus_level) {
              from_mastery += SKILLS[skill.category][insight_bonus_level];
            }
          }
        }
        return from_rings + from_skills + from_mastery;
      }
    },
    insight_rank: {
      where: '#general + div .table:nth-of-type(1) .row1 .col3',
      type: 'int',
      compute: function() {
        return max(1, floor((this.insight - 150) / 25) + 2);
      }
    },
    wounds_healthy_max: {
      where: '#wounds + div .table:nth-of-type(1) .row1 .col1',
      type: 'int',
      compute: function() {
        return this.earth * 2;
      }
    },
    wounds_nicked_max: {
      where: '#wounds + div .table:nth-of-type(1) .row2 .col1',
      type: 'int',
      compute: function() {
        return this.earth * 2;
      }
    },
    wounds_grazed_max: {
      where: '#wounds + div .table:nth-of-type(1) .row3 .col1',
      type: 'int',
      compute: function() {
        return this.earth * 2;
      }
    },
    wounds_hurt_max: {
      where: '#wounds + div .table:nth-of-type(1) .row4 .col1',
      type: 'int',
      compute: function() {
        return this.earth * 2;
      }
    },
    wounds_injured_max: {
      where: '#wounds + div .table:nth-of-type(1) .row5 .col1',
      type: 'int',
      compute: function() {
        return this.earth * 2;
      }
    },
    wounds_crippled_max: {
      where: '#wounds + div .table:nth-of-type(1) .row6 .col1',
      type: 'int',
      compute: function() {
        return this.earth * 2;
      }
    },
    wounds_down_max: {
      where: '#wounds + div .table:nth-of-type(1) .row7 .col1',
      type: 'int',
      compute: function() {
        return this.earth * 2;
      }
    },
    wounds_out_max: {
      where: '#wounds + div .table:nth-of-type(1) .row8 .col1',
      type: 'int',
      compute: function() {
        return this.earth * 5;
      }
    }
  };

  SHEET_MAPPING = merge_objects(PRIMARY_MAPPING, SECONDARY_MAPPING);

  CharacterSheet = (function() {
    function CharacterSheet(primaries, secondaries) {
      var attr_name, properties, _ref;
      this.primaries = primaries;
      this.secondaries = secondaries;
      this.mapping = merge_objects(this.primaries, this.secondaries);
      _ref = this.mapping;
      for (attr_name in _ref) {
        properties = _ref[attr_name];
        this[attr_name] = $(properties.where);
      }
    }

    CharacterSheet.prototype.set = function(attr, val) {
      var attr_name, value, _results;
      if (typeof attr === 'string') {
        switch (this.mapping[attr].type) {
          case 'int':
            return this[attr].text(val);
          case 'rank':
            return this[attr].text("" + val.rank + "." + val.points);
        }
      } else {
        _results = [];
        for (attr_name in attr) {
          value = attr[attr_name];
          _results.push(this.set(attr_name, value));
        }
        return _results;
      }
    };

    CharacterSheet.prototype.get = function(attr) {
      var attr_name, points, rank, result, value, _ref;
      if (typeof attr === 'string') {
        if (typeof this.mapping[attr].type === 'function') {
          return this.mapping[attr].type(this[attr]);
        } else {
          switch (this.mapping[attr].type) {
            case 'int':
              return Number(this[attr].text());
            case 'rank':
              _ref = this[attr].text().split('.').map(Number), rank = _ref[0], points = _ref[1];
              return {
                rank: rank,
                points: points
              };
          }
        }
        result = {};
        for (attr_name in attr) {
          value = attr[attr_name];
          result[attr_name] = this.get(attr_name);
        }
        return result;
      }
    };

    CharacterSheet.prototype.regroup_effects = function(where) {
      var $where, category, content, effect_attr, effect_dict, effect_str, effects, _results;
      $where = $(where).find('ul');
      effect_dict = this.get_all_effects();
      _results = [];
      for (category in effect_dict) {
        effects = effect_dict[category];
        _results.push((function() {
          var _i, _len, _results1;
          _results1 = [];
          for (_i = 0, _len = effects.length; _i < _len; _i++) {
            effect_attr = effects[_i];
            effect_str = this.format_effect(effect_attr.effect);
            content = ["<strong>" + category + "</strong>:", effect_str];
            if (effect_attr.why != null) {
              content.push("<em>(" + effect_attr.why + ")<em>");
            }
            _results1.push($where.append("<li class='level1' ><div class='li'>" + content.join(' ') + "</div></li>"));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    CharacterSheet.prototype.get_all_effects = function() {
      var effects_record;
      effects_record = {};
      $('effect').each(function() {
        var category, effect, why;
        category = $(this).attr('cat');
        why = $(this).attr('why');
        effect = $(this).attr('effect');
        if (!effects_record[category]) {
          effects_record[category] = [];
        }
        return effects_record[category].push({
          why: why,
          effect: effect
        });
      });
      return effects_record;
    };

    CharacterSheet.prototype.map = function(dict, with_skills) {
      var n, r, s, _i, _len, _ref;
      if (with_skills == null) {
        with_skills = false;
      }
      r = {};
      for (n in dict) {
        r[n] = this.get(n);
      }
      if (with_skills) {
        _ref = this.get('skills');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          s = _ref[_i];
          r[s.var_name] = s.rank;
        }
      }
      return r;
    };

    CharacterSheet.prototype.format_effect = function(str) {
      var expression, expressions, i, map, parsed, values, _i, _ref;
      expressions = str.match(/#\{[^\}]+\}/g);
      if (expressions) {
        map = merge_objects(this.map(this.mapping, true), {
          floor: Math.floor,
          ceil: Math.ceil,
          max: Math.max,
          min: Math.min
        });
        values = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = expressions.length; _i < _len; _i++) {
            expression = expressions[_i];
            expression = expression.replace('#{', '').replace('}', '');
            parsed = expression_parser.parse(expression);
            _results.push(this.evaluate(parsed, map));
          }
          return _results;
        }).call(this);
        for (i = _i = 0, _ref = expressions.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          str = str.replace(expressions[i], values[i]);
        }
      }
      return str;
    };

    CharacterSheet.prototype.evaluate = function(tree, map) {
      switch (tree.type) {
        case 'symbol':
          return map[tree.val];
        case 'number':
          return tree.val;
        case 'function call':
          return this.evaluate(tree.func, map)(this.evaluate(tree.arg, map));
        case '*':
          return this.evaluate(tree.left, map) * this.evaluate(tree.right, map);
        case '/':
          return this.evaluate(tree.left, map) / this.evaluate(tree.right, map);
        case '+':
          return this.evaluate(tree.left, map) + this.evaluate(tree.right, map);
        case '-':
          return this.evaluate(tree.left, map) - this.evaluate(tree.right, map);
        case 'dot':
          return this.evaluate(tree.left, map)[tree.right.val];
      }
    };

    CharacterSheet.prototype.complete = function() {
      var map, name, properties, _ref, _results;
      map = this.map(this.primaries);
      _ref = this.secondaries;
      _results = [];
      for (name in _ref) {
        properties = _ref[name];
        map[name] = properties.compute.call(map);
        _results.push(this.set(name, map[name]));
      }
      return _results;
    };

    CharacterSheet.prototype.hide_skills_zero = function() {
      return this.skills.find('.col2').filter(function() {
        return Number(trim($(this).text())) === 0;
      }).parent().hide();
    };

    return CharacterSheet;

  })();

  $(function() {
    var sheet;
    sheet = new CharacterSheet(PRIMARY_MAPPING, SECONDARY_MAPPING);
    sheet.complete();
    sheet.regroup_effects('#fast_reference + div');
    return sheet.hide_skills_zero();
  });

}).call(this);

/*
//@ sourceMappingURL=character_sheet.map
*/
