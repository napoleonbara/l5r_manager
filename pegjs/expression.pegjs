
start
  = _ exp:expression _ { return exp; }

_ = " "*

expression
  = left:mul_op _ "+" _ right:expression { return { type: "+", left: left, right: right }; }
  / left:mul_op _ "-" _ right:expression { return { type: "-", left: left, right: right }; }
  / mul_op

mul_op
  = left:primary _ "*" _ right:mul_op { return { type: "*", left: left, right: right }; }
  / left:primary _ "/" _ right:mul_op { return { type: "/", left: left, right: right }; }
  / primary

primary
  = number
  / function_call
  / symbol
  / "(" _ exp:expression _ ")" { return exp; }

function_call
  = func:symbol _ "(" _ arg:expression _ ")"
  {
    return {
      type: "function call",
      func: func,
      arg: arg
    };
  }

symbol
  = left:container right:symbol
  {
    return {
      type: "dot",
      left: left,
      right: right
    };
  }
  / head:[a-z] tail:[a-z_]+
  {
    return {
      type: 'symbol',
      val: head + (tail ? tail : []).join("")
    };
  }

container
  = head:[a-z] tail:[a-z_]+ "."
  {
    return {
      type: 'symbol',
      val: head + (tail ? tail : []).join("")
    };
  }

number
  = minus:"-"? E:[0-9]+ decimals:("." [0-9]+)? 
  {
    return {
      type: 'number',
      val: parseFloat((minus ? minus : "")+E.join("")+(decimals ? decimals.join("") : ""))
    };
  }
  

