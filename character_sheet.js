$(function(){
  var sheet_mapping = {
    stamina: {
      where: '.table.sectionedit10 .row0 .col1',
      type: 'int'
    },
    willpower: {
      where: '.table.sectionedit10 .row0 .col3',
      type: 'int'
    },
    earth: {
      where: '.table.sectionedit10 .row0 .col5',
      type: 'int'
    },
    strength: {
      where: '.table.sectionedit10 .row1 .col1',
      type: 'int'
    },
    perception: {
      where: '.table.sectionedit10 .row1 .col3',
      type: 'int'
    },
    water: {
      where: '.table.sectionedit10 .row1 .col5',
      type: 'int'
    },
    agility: {
      where: '.table.sectionedit10 .row2 .col1',
      type: 'int'
    },
    intelligence: {
      where: '.table.sectionedit10 .row2 .col3',
      type: 'int'
    },
    fire: {
      where: '.table.sectionedit10 .row2 .col5',
      type: 'int'
    },
    reflexes: {
      where: '.table.sectionedit10 .row3 .col1',
      type: 'int'
    },
    awareness: {
      where: '.table.sectionedit10 .row3 .col3',
      type: 'int'
    },
    air: {
      where: '.table.sectionedit10 .row3 .col5',
      type: 'int'
    },
    void: {
      where: '.table.sectionedit10 .row4 .col1',
      type: 'int'
    },
    status: {
      where: '.table.sectionedit11 .row0 .col1',
      type: 'rank'
    }, 
    glory: {
      where: '.table.sectionedit11 .row0 .col3',
      type: 'rank'
    },
    honor: {
      where: '.table.sectionedit11 .row0 .col5',
      type: 'rank'
    },
    taint: {
      where: '.table.sectionedit11 .row0 .col7',
      type: 'rank'
    },
  };
  
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
        switch(mapping[attr].type){
          case 'int':
            return Number(sheet[attr].text());
            break;
          case 'rank':
            return sheet[attr].text().split('.').map(Number);
                break; 
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
      
  function parse_character_sheet(sheet){
    return sheet.get({
      stamina: null,
      willpower: null,
      strength: null,
      perception: null,
      agility: null,
      intelligence: null,
      reflexes: null,
      awareness: null,
      void: null,
      status: null,  
      glory: null,
      honor: null,
      taint: null,
    });
  }

  var sheet = map_character_sheet(sheet_mapping);
  var char = parse_character_sheet(sheet);
  
  char.earth = Math.min(char.stamina, char.willpower);
  char.fire  = Math.min(char.agility, char.intelligence);
  char.water = Math.min(char.strength, char.perception);
  char.air   = Math.min(char.reflexes, char.awareness);
  
  sheet.set({
    earth: char.earth,
    water: char.water,
    fire: char.fire,
    air: char.air,
  });
});