
start
  = _ statement:statement _ {return statement;}

whiteSpace "whitespace"
  = "\t"
  / " "
_
  = whiteSpace*

statement
  = target:symbol _ "="  _ value:expression { return { define: target[0], as: value }; }
  / target:symbol _ "+=" _ value:expression { return { add: value, to: target[0] }; }
  / target:symbol _ "-=" _ value:expression { return { subtract: value, from: target[0] }; }
  / expression

  
expression
  = additive_expression
  / modifier_list
  
additive_expression
  = left:multiplicative_expression _ "+" _ right:additive_expression { return left.concat(right, '+'); }
  / left:multiplicative_expression _ "-" _ right:additive_expression { return left.concat(right, '-'); }
  / multiplicative_expression

multiplicative_expression
  = left:primary_expression _ "*" _ right:multiplicative_expression { return left.concat(right, '*'); }
  / left:primary_expression _ "/" _ right:multiplicative_expression { return left.concat(right, '/'); }
  / primary_expression

primary_expression
  = roll_expression
  / function_call
  / number
  / atomic

atomic
  = natural
  / symbol
  / "(" _ expression:expression _ ")" { return expression; }
  
function_call
  = name:symbol _ "(" _ args:argument_list? _ ")" { return ['ARG_LIST_BOTTOM'].concat(args, name, 'FUNCTION_CALL'); }
  
argument_list
  = head:expression _ tail:argument_list_tail { return head.concat(tail); }
  
argument_list_tail
  = tail:("," _ expression)* { r = []; for(var i in tail){r = r.concat(tail[i][2]);}; return r; }
  
number
  = integral:integer decimal:("." natural)? { return [ Number((''+integral[0]) + (decimal ? ('.'+decimal[1][0]) : '')) ]; }
  
integer
  = minus:"-"? natural:natural {return [ Number((minus || "") + natural[0]) ]; }

natural
  = digits:[0-9]+ { return [ Number(digits.join('')) ]; }
  
symbol
  = first:word rest:( _ word)* { return [[first].concat(rest.map(function(e){return e[1]})).join(' ')]; }

word
  = chars:[a-z]+ {return chars.join(''); }
  
roll_expression
  = explode:"!"? _ basic_roll:basic_roll _ modifiers:modifier_list?
  { return basic_roll.concat(modifiers ? modifiers : [], explode ? 'EXPLODE_FLAG' : []); }

basic_roll
  = pool_roll
  / roll_and_keep
  / skill_roll

pool_roll
  = number:atomic? _ "D" _ type:atomic? { return (number || [1]).concat(type || [6], 'POOL_ROLL'); }
  
roll_and_keep
  = roll:atomic? _ "K" _ keep:atomic { return (roll || keep).concat(keep, 'ROLL_AND_KEEP'); }
  
modifier_list
  = head:modifier tail:(_ modifier)* { r = head; for(var i in tail){r = r.concat(tail[i][1]);}; return r; }

modifier
  = explosion_modifier
  / dice_modifier

  
explosion_modifier
  = "!" _ value:atomic { return value.concat('EXPLOSION_THRESHOLD'); }
  
dice_modifier
  = "^" _ value:atomic { return value.concat('DICE_MODIF'); }
  
skill_roll
  = trait:atomic _ "|" _ skill:atomic { return trait.concat(skill, '+', trait, 'ROLL_AND_KEEP'); }
  
