var skills = {
  acting: {
      5: 2,
      10: 5,
    },
  artisan:  {
      5: 2,
      10: 5,
    },
  calligraphy:  {
      5: 2,
      10: 5,
    },
  courtier:  {
      5: 2,
      10: 5,
    },
  divination:  {
      5: 2,
      10: 5,
    },
  etiquette:  {
      5: 2,
      10: 5,
    },
  games:  {
      5: 4,
      10: 7,
    },
  instruction:  {
      5: 4,
      10: 7,
    },
  investigation:  {
      5: 2,
      10: 5,
    },
  lore:  {
      5: 4,
      10: 7,
    },
  medicine:  {
      5: 2,
      10: 5,
    },
  meditation:  {
      5: 2,
      7: 2,
      10: 5,
    },
  performance:  {
      5: 4,
      10: 7,
    },
  spellcraft:  {
      5: 2,
      10: 5,
    },
  storytelling:  {
      5: 4,
      10: 7,
    },
  tea_ceremony:  {
      5: 2,
      10: 5,
    },
  theology:  {
      5: 4,
      7: 2,
      10: 15,
    },
  animal_handling:  {
      5: 2,
      10: 5,
    },
  commerce:  {
      5: 2,
      10: 5,
    },
  craft:  {
      5: 4,
      10: 7,
    },
  engineering:  {
      5: 2,
      10: 5,
    },
  locksmith:  {
      5: 2,
      10: 5,
    },
  athletics:  {
      5: 2,
      10: 5,
    },
  battle:  {
      5: 2,
      10: 5,
    },
  chain_weapons:  {
      5: 2,
      10: 5,
    },
  heavy_weapons:  {
      5: 2,
      10: 5,
    },
  kenjutsu:  {
      5: 2,
      10: 5,
    },
  knives:  {
      5: 2,
      10: 5,
    },
  kyujutsu:  {
      5: 2,
      10: 5,
    },
  ninja_weapons:  {
      5: 2,
      10: 5,
    },
  peasant_weapons:  {
      5: 2,
      10: 5,
    },
  polearms:  {
      5: 2,
      10: 5,
    },
  spears:  {
      5: 2,
      10: 5,
    },
  staves:  {
      5: 2,
      10: 5,
    },
  war_fanｓ:  {
      5: 2,
      10: 5,
    },
  defense:  {
      5: 2,
      10: 5,
    },
  horsemanship:  {
      5: 2,
      10: 5,
    },
  hunting:  {
      5: 2,
      10: 5,
    },
  iaijutsu:  {
      5: 2,
      10: 5,
    },
  jiujutsu:  {
      5: 2,
      10: 5,
    },
  know_the_school:  {
      5: 2,
      10: 5,
    },
  anatomy:  {
      5: 2,
      10: 5,
    },
  deceit:  {
      5: 2,
      10: 5,
    },
  explosives:  {
      5: 2,
      10: 5,
    },
  forgery:  {
      5: 2,
      10: 5,
    },
  poison:  {
      5: 2,
      10: 5,
    },
  sleight_of_hand:  {
      5: 2,
      10: 5,
    },
  stealth:  {
      5: 2,
      10: 5,
    },
  traps:  {
      5: 2,
      10: 5,
    },
  underworld:  {
      5: 2,
      10: 5,
    },
};

function insight_rank(insight){
  return Math.max(1, Math.floor((insight - 150) / 25) + 2);
}

var primary_mapping = {
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
  void: {
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
    type: function($sel){
      var result = [];
      $sel.each(function(){
        var name = varnamize($(this).find('.col0 a').text());
        var val = Number($(this).find('.col2').text());
        result.push([name, val]);
      });
      return result;
    }
  }
};

var secondary_mapping = {
  earth: {
    where: '#general + div .table:nth-of-type(2) .row0 .col5',
    type: 'int'
  },
  water: {
    where: '#general + div .table:nth-of-type(2) .row1 .col5',
    type: 'int'
  },
  fire: {
    where: '#general + div .table:nth-of-type(2) .row2 .col5',
    type: 'int'
  },
  air: {
    where: '#general + div .table:nth-of-type(2) .row3 .col5',
    type: 'int'
  },
  insight: {
    where: '#general + div .table:nth-of-type(1) .row1 .col1',
    type: 'int'
  },
  insight_rank: {
    where: '#general + div .table:nth-of-type(1) .row1 .col3',
    type: 'int'
  },
  wounds_healthy_max: {
    where: '#wounds + div .table:nth-of-type(1) .row1 .col1',
    type: 'int'
  },
  wounds_nicked_max: {
    where: '#wounds + div .table:nth-of-type(1) .row2 .col1',
    type: 'int'
  },
  wounds_grazed_max: {
    where: '#wounds + div .table:nth-of-type(1) .row3 .col1',
    type: 'int'
  },
  wounds_hurt_max: {
    where: '#wounds + div .table:nth-of-type(1) .row4 .col1',
    type: 'int'
  },
  wounds_injured_max: {
    where: '#wounds + div .table:nth-of-type(1) .row5 .col1',
    type: 'int'
  },
  wounds_crippled_max: {
    where: '#wounds + div .table:nth-of-type(1) .row6 .col1',
    type: 'int'
  },
  wounds_down_max: {
    where: '#wounds + div .table:nth-of-type(1) .row7 .col1',
    type: 'int'
  },
  wounds_out_max: {
    where: '#wounds + div .table:nth-of-type(1) .row8 .col1',
    type: 'int'
  },
};

function merge_objects(obj1,obj2){
  var obj3 = {};
  for (var attrname in obj1)if(obj1.hasOwnProperty(attrname)){ obj3[attrname] = obj1[attrname]; }
  for (var attrname in obj2)if(obj2.hasOwnProperty(attrname)){ obj3[attrname] = obj2[attrname]; }
  return obj3;
}

function varnamize(str){
  return str.toLowerCase().replace(/[ ']/, '_');
}

function object_keep(obj, list){
  var r = {};
  for(var i = 0; i < list.length; i++){
    r[list[i]] = obj[list[i]];
  }
  return r;
}

var sheet_mapping = merge_objects(primary_mapping, secondary_mapping);

function map_character_sheet(mapping){
  var sheet = {};
  
  for(var attr in mapping) if(mapping.hasOwnProperty(attr)){
    var selector = mapping[attr].where;
    sheet[attr] = $(selector);
  }
  
  sheet.set = function(attr, val){
    if(typeof attr == 'string'){
      switch(mapping[attr].type){
        case 'int':
          sheet[attr].text(val);
          break;
        case 'rank':
          sheet[attr].text(val.join('.'));
          break; 
      }
    }else{
      for(var attr_name in attr) if(attr.hasOwnProperty(attr_name)){
        sheet.set(attr_name, attr[attr_name]);
      }
    }
  };
  
  sheet.get = function(attr){
    if(typeof attr == 'string'){
      if(typeof mapping[attr].type == 'function'){
        return mapping[attr].type(sheet[attr]);
      }else{
        switch(mapping[attr].type){
          case 'int':
            return Number(sheet[attr].text());
            break;
          case 'rank':
            return sheet[attr].text().split('.').map(Number);
                break; 
            }
        }
      }else{
        var result = {};
        for(var attr_name in attr) if(attr.hasOwnProperty(attr_name)){
          result[attr_name] = sheet.get(attr_name);
        }
        return result;
      }
    };
  return sheet;
}

function compute_insight(char){
  var from_rings = (char.earth + char.water + char.air + char.fire + char.void) * 10;
  var from_skills = 0;
  char.skills.forEach(function(a){
    var name, val;
    name = a[0]; val = a[1];
    from_skills += val;
    for(var insight_bonus_level in skills[name]){
      if(val >= insight_bonus_level){
        from_skills += skills[name][insight_bonus_level];
      }
    }
  });
  return from_rings + from_skills;
}

function parse_character_sheet(sheet){
  return sheet.get(primary_mapping);
}

var sheet, char;

function get_all_effects(){
  var effects_record = {};
  $('.effects > *').each(function(){
    var tag = this.tagName.toLowerCase();
    var because = $(this).attr('because');
    var effect = $(this).text();
    
    if(!effects_record[tag]) effects_record[tag] = [];
    effects_record[tag].push({
      because: because,
      effect: effect
    });
  });
  return effects_record;
}

function regroup_effects(effects, where){
  var $where = $(where).find('ul');

  for(var domain in effects)if(effects.hasOwnProperty(domain)){
    var domain_effects = effects[domain];
    for(var i = 0; i < domain_effects.length; i++){
      var effect_attr = domain_effects[i];
      $where.append('<li class="level1" title="'+effect_attr.because+
      '"><div class="li"><strong>'+domain+'</strong>: '+effect_attr.effect+'</div></li>');
    }
  }
}

$(function(){

  sheet = map_character_sheet(sheet_mapping);
  char = parse_character_sheet(sheet);

  
  char.earth = Math.min(char.stamina, char.willpower);
  char.fire  = Math.min(char.agility, char.intelligence);
  char.water = Math.min(char.strength, char.perception);
  char.air   = Math.min(char.reflexes, char.awareness);
  char.insight = compute_insight(char);
  char.insight_rank = insight_rank(char.insight);
  char.wounds_healthy_max = char.earth * 2;
  char.wounds_nicked_max = char.earth * 2;
  char.wounds_grazed_max = char.earth * 2;
  char.wounds_hurt_max = char.earth * 2;
  char.wounds_injured_max = char.earth * 2;
  char.wounds_crippled_max = char.earth * 2;
  char.wounds_down_max = char.earth * 2;
  char.wounds_out_max = char.earth * 5;
  
  sheet.set(object_keep(char, Object.keys(secondary_mapping)));
  
  var all_effects = get_all_effects();
  regroup_effects(all_effects, '#fast_reference + div');
});