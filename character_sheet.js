$(function(){
  var primary_mapping = {
    stamina: {
      where: '.table.sectionedit10 .row0 .col1',
      type: 'int'
    },
    willpower: {
      where: '.table.sectionedit10 .row0 .col3',
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
    agility: {
      where: '.table.sectionedit10 .row2 .col1',
      type: 'int'
    },
    intelligence: {
      where: '.table.sectionedit10 .row2 .col3',
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
  
  var secondary_mapping = {
    earth: {
      where: '.table.sectionedit10 .row0 .col5',
      type: 'int'
    },
    water: {
      where: '.table.sectionedit10 .row1 .col5',
      type: 'int'
    },
    fire: {
      where: '.table.sectionedit10 .row2 .col5',
      type: 'int'
    },
    air: {
      where: '.table.sectionedit10 .row3 .col5',
      type: 'int'
    },
  };
  
  function merge_objects(obj1,obj2){
    var obj3 = {};
    for (var attrname in obj1)if(obj1.hasOwnProperty(attrname)){ obj3[attrname] = obj1[attrname]; }
    for (var attrname in obj2)if(obj1.hasOwnProperty(attrname)){ obj3[attrname] = obj2[attrname]; }
    return obj3;
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
    return sheet.get(primary_mapping);
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