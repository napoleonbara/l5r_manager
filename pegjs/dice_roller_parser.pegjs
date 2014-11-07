start
  = _ roll:dice_roll modificators:modif_list? _
  {
    roll.modificators = modificators || [];
    return roll;
  }

dice_roll
  = explosion_flag:"!"? roll:explosable_roll {roll.explode = !explosion_flag; return roll;}
  / flat_roll

explosable_roll
 = explicit_roll
  / skill_roll
  / trait_roll
  
flat_roll
  = roll:natural "d10"
  {
    return {
      type: 'flat roll',
      roll: roll,
    };
  }
  
skill_roll 
  = trait:symbol "/" skill:symbol
  {
    return {
      type: 'skill roll',
      trait: trait,
      skill: skill,
    };
  }

explicit_roll 
  = roll:explicit_roll_term "K" keep:explicit_roll_term
  {
    return {
      type: 'explicit roll',
      roll: roll,
      keep: keep,
    };
  }

explicit_roll_term
 = "(" _ expression:expression _ ")" {return expression;}
 / number
 / symbol

trait_roll 
  = roll:symbol
  {
    return {
      type: 'trait roll',
      roll: roll,
    };
  }
  
whitespace
  = " "
  / "\t"
  
_
  = whitespace*
  
natural
  = digits:[0-9]+
  {
    return {
      type: 'number',
      value: digits.join(''),
    };
  }
  
integer
  = minus:'-'? natural:natural
  {
    return {
      type: 'number',
      value: (minus || '') + natural.value,
    };
  }
  
variable
  = left:container right:symbol
  {
    return {
      type: "dot",
      left: left,
      right: right
    };
  }
  / symbol
  
symbol
  = head:[a-z] tail:[a-z_]+
  {
    return {
      type: 'symbol',
      value: head + (tail ? tail : []).join("")
    };
  }

container
  = head:[a-z] tail:[a-z_]+ "."
  {
    return {
      type: 'symbol',
      value: head + (tail ? tail : []).join("")
    };
  }

number
  = integral:integer decimal:decimal_part?
  {
    return {
      type: 'number',
      value: integral.value + (decimal ? '.' + decimal : ''),
    };
  }
  
decimal_part
  = '.' digits:natural { return digits.value; }

expression
  = left:mul_op _ "+" _ right:expression { return { type: "+", left: left, right: right }; }
  / left:mul_op _ "-" _ right:expression { return { type: "-", left: left, right: right }; }
  / mul_op

mul_op
  = left:primary _ "*" _ right:mul_op { return { type: "*", left: left, right: right }; }
  / left:primary _ "/" _ right:mul_op { return { type: "/", left: left, right: right }; }
  / primary

primary
  = function_call
  / number
  / variable
  / "(" _ exp:expression _ ")" { return exp; }

function_call
  = name:symbol _ "(" _ arguments:argument_list _ ")"
  {
    return {
      type: "function call",
      name: name.value,
      arguments: arguments
    };
  }
  

argument_list
  = head:expression _ ',' _ tail:argument_list
  {
    return [head].concat(tail);
  }
  / expression:expression
  {
    return [expression];
  }
  / ''
  {
    return [];
  }

  
modif_list
  = head:modificator tail:modif_list?
  {
    return [head].concat(tail || []);
  }
  
modificator
  = '^' value:modificator_value {return {type: 'dice modificator', value: value};}
  / '!' value:modificator_value {return {type: 'explosion modificator', value: value};}
  / '+' value:modificator_value {return {type: 'roll bonus', value: value};}
  / '-' value:modificator_value {return {type: 'roll penalty', value: value};}
  
modificator_value
 = "(" _ expression:expression _ ")" {return expression;}
 / integer
 / symbol