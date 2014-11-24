
RESERVED_SYMBOLS = "+ - * / ( ) FUNCTION_CALL POOL_ROLL ROLL_AND_KEEP EXPLOSION_THRESHOLD DICE_MODIF".split(' ')

parse = dice_roller_parser.parse;

window.handle_rule = (ctx, rule) ->
  rule = parse(rule);
  switch
    when rule.hasOwnProperty('define')
      ctx[rule.define] = (new Expression(rule.as)).evaluate(ctx)
    when rule.hasOwnProperty('add')
      ctx[rule.to] = (new Expression([rule.to].concat(rule.add, '+'))).evaluate(ctx)
    when rule.hasOwnProperty('subtract')
      ctx[rule.from] = (new Expression([rule.from].concat(rule.subtract, '-'))).evaluate(ctx)


window.handle_query = (ctx, expression) ->
  expression = new Expression(expression)
  expression.evaluate(ctx)


class Expression
  
  constructor: (@origin) ->
    switch
      when typeof @origin == 'string'
        @rpn = parse(@origin)
      when @origin instanceof Array
        @rpn = @origin

  to_string: ->
    @scan(
      add: (copy, stack, top, args) ->
        copy.push("#{args[1]} + #{args[0]}")

      sub: (copy, stack, top, args) ->
        copy.push("#{args[1]} - #{args[0]}")

      mul: (copy, stack, top, args) ->
        copy.push("#{args[1]} * #{args[0]}")

      div: (copy, stack, top, args) ->
        copy.push("#{args[1]} / #{args[0]}")

      function_call: (copy, stack, top, args) ->
        func = stack.pop()
        i = stack.lastIndexOf('ARG_LIST_BOTTOM')
        args = stack.splice(i)
        args.shift()
        copy.push("#{func}(#{args.join(', ')})")

      arg_list_bottom:  (copy, stack, top, args) ->
        stack.push(top)
        
      pool_roll: (copy, stack, top, args) ->
        copy.push( "#{args[1]}D#{args[0]}" )

      roll_and_keep: (copy, stack, top, args) ->
        copy.push( "#{args[1]}K#{args[0]}" )

      open_parenthese: (copy, stack, top, args) ->
        stack.push(top)

      close_parenthese: (copy, stack, top, args) ->
        i = stack.lastIndexOf('(')
        rest = stack.splice(i)
        stack.push(rest.join('') + ')')

      symbol: (copy, stack, top, args) ->
        stack.push(top)

      number: (copy, stack, top, args) ->
        stack.push("#{top}")

      dont_know: (copy, stack, top, args) ->
        throw "WTF is " + top + "? "

      dice_modif: (copy, stack, top, args) ->
        copy.push("#{args[1]} ^ #{args[0]}")

      explosion_threshold: (copy, stack, top, args) ->
        copy.push("#{args[1]} ! #{args[0]}")
        
      explode_flag: (copy, stack, top, args) ->
        copy.push("!#{args[0]}}")
    )

  append: (exp) ->
    @rpn = @rpn.concat(exp.rpn)

  dependencies: ->
    @rpn.filter( (e) -> typeof e == 'string' and not Array.include(RESERVED_SYMBOLS, e) )
  
  required_computations: (ctx) ->
    @dependencies().filter( (e) -> not ctx.hasOwnProperty(e) )

  scan: (fs) ->
    copy = @rpn.slice().reverse()
    stack = []
    loop
      top = copy.pop()
      switch
        when top == '+'
          fs.add(copy, stack, top, Array.popn(stack, 2))
          
        when top == '-'
          fs.sub(copy, stack, top, Array.popn(stack, 2))
          
        when top == '*'
          fs.mul(copy, stack, top, Array.popn(stack, 2))
          
        when top == '/'
          fs.div(copy, stack, top, Array.popn(stack, 2))

        when top == 'FUNCTION_CALL'
          fs.function_call(copy, stack, top, [])
          
        when top == 'POOL_ROLL'
          fs.pool_roll(copy, stack, top, Array.popn(stack, 2))

        when top == 'ROLL_AND_KEEP'
          fs.roll_and_keep(copy, stack, top, Array.popn(stack, 2))
          
        when top == 'ARG_LIST_BOTTOM'
          fs.arg_list_bottom(copy, stack, top, [])

        when top == '('
          fs.open_parenthese(copy, stack, top, [])
          
        when top == ')'
          fs.close_parenthese(copy, stack, top, [])
          
        when top == 'EXPLOSION_THRESHOLD'
          fs.explosion_threshold(copy, stack, top, Array.popn(stack, 2))
          
        when top == 'EXPLODE_FLAG'
          fs.explode_flag(copy, stack, top, Array.popn(stack, 1))

        when top == 'DICE_MODIF'
          fs.dice_modif(copy, stack, top, Array.popn(stack, 2))
          
        when top instanceof Roll
          fs.roll(copy, stack, top, [])
        
        when typeof top == 'number'
          fs.number(copy, stack, top, [])
          
        when typeof top == 'string'
          fs.symbol(copy, stack, top, [])
          
        else
          fs.dont_know(copy, stack, top, [])
      break if copy.length == 0 and stack.length == 1
    
    stack[0]
  
  evaluate: (ctx) ->
    @scan(
      add: (copy, stack, top, args) ->
        stack.push(add(args[1], args[0]))

      sub: (copy, stack, top, args) ->
        stack.push(sub(args[1], args[0]))

      mul: (copy, stack, top, args) ->
        stack.push(mul(args[1], args[0]))

      div: (copy, stack, top, args) ->
        stack.push(div(args[1], args[0]))

      function_call: (copy, stack, top, args) ->
        func = stack.pop()
        i = stack.lastIndexOf('ARG_LIST_BOTTOM')
        args = stack.splice(i)
        args.shift()
        stack.push(func.call(null, args))

      arg_list_bottom:  (copy, stack, top, args) ->
        stack.push(top)

      pool_roll: (copy, stack, top, args) ->
        stack.push(new Roll(roll: args[1], type: args[0], mode: 'basic'))

      roll_and_keep: (copy, stack, top, args) ->
        stack.push(new Roll(type: 10, roll: args[1], keep: args[0], mode: 'L5R', explosion_threshold: 10, explode: true))

      open_parenthese: (copy, stack, top, args) ->

      close_parenthese: (copy, stack, top, args) ->

      symbol: (copy, stack, top, args) ->
        v = ctx[top]
        unless v? then throw "don't know the symbol " + top
        stack.push(v)

      number: (copy, stack, top, args) ->
        stack.push(top)

      roll: (copy, stack, top, args) ->
        stack.push(top)

      dont_know: (copy, stack, top, args) ->
        throw "WTF is #{top} ?"

      dice_modif: (copy, stack, top, args) ->
        args[1].dice_modif += args[0]
        stack.push(args[1])

      explosion_threshold: (copy, stack, top, args) ->
        args[1].explosion_threshold = Math.min(args[1].explosion_threshold, args[0])
        stack.push(args[1])
        
      explode_flag:  (copy, stack, top, args) ->
        args[0].explode = not args[0].explode
        stack.push(args[0])
    )


window.Expression = Expression

class Roll
  
  constructor: (opts) ->
    Object.merge_with( @, 
      mode                : 'basic'
      roll                : 1
      type                : 6
      sum                 : false
      dice_modif          : 0
      roll_modif          : 0
      explode             : false
      explosion_threshold : 6
    ,
    opts )

  add_roll: (other) ->
    Object.merge_with( @, 
      roll                : @roll + other.roll
      keep                : @keep + other.keep
      sum                 : @sum or other.sum
      dice_modif          : @dice_modif + other.dice_modif
      roll_modif          : @roll_modif + other.roll_modif
      explode             : @explode or other.explode
      explosion_threshold : Math.min(@explosion_threshold, other.explosion_threshold)
    )
    
    @

  add_number: (num) ->
    @sum = true
    @roll_modif += num
    @

  sub_number: (num) ->
    @sum = true
    @roll_modif -= num
    @

  sub_roll: (other) ->
    Object.merge_with( @, 
      roll                : @roll - other.roll
      keep                : @keep - other.keep
      sum                 : @sum or other.sum
      dice_modif          : @dice_modif - other.dice_modif
      roll_modif          : @roll_modif - other.roll_modif
      explode             : @explode or other.explode
      explosion_threshold : Math.min(@explosion_threshold, other.explosion_threshold)
    )
    
    @
    
  to_string: ->
    switch @mode
      when 'basic'
        exp = if @explode then '!' else ''
        dm = if @dice_modif != 0 then "^#{@dice_modif}" else ''
        rm = if @roll_modif != 0 then "#{if @roll_modif > 0 then '+' else ''}#{@roll_modif}" else ''
        et = if @explosion_threshold != @type then "!#{@explosion_threshold}" else ''
        "#{exp}#{@roll}D#{@type}#{dm}#{et}#{rm}"
      when 'L5R'
        exp = unless @explode then '!' else ''
        dm = if @dice_modif != 0 then "^#{@dice_modif}" else ''
        rm = if @roll_modif != 0 then "#{if @roll_modif > 0 then '+' else ''}#{@roll_modif}" else ''
        et = if @explosion_threshold != 10 then "!#{@explosion_threshold}" else ''
        "#{exp}#{@roll}K#{@keep}#{dm}#{et}#{rm}"


Roll.merge_dice_pools = (pool_1, pool_2) ->
  r = Object.merge({}, pool_1)
  for type, num of pool_2
    unless r[type]? then r[type] = 0
    r[type] += num
  r
  
Roll.subtract_dice_pools = (pool_1, pool_2) ->
  # won't take from pool 1 dice that do not exist
  # will keep a minimum of 1 die
  r = Object.merge({}, pool_1)
  for type, num of pool_2
    if r[type]?
      r[type] = Math.max(1, r[type] - num)
  r

window.Roll = Roll

add = (lop, rop) ->
  types = [typeof lop, typeof rop]
  switch
    when Array.equal(types, ['number', 'number'])
      lop + rop
    when Array.equal(types, ['object', 'number'])
      lop.add_number(rop)
    when Array.equal(types, ['object', 'object'])
      lop.add_roll(rop)
    else
      undefined


mul = (lop, rop) ->
  types = [typeof lop, typeof rop]
  switch
    when Array.equal(types, ['number', 'number'])
      lop * rop
    else
      undefined


div = (lop, rop) ->
  types = [typeof lop, typeof rop]
  switch
    when Array.equal(types, ['number', 'number'])
      lop / rop
    else
      undefined

sub = (lop, rop) ->
  types = [typeof lop, typeof rop]
  switch
    when Array.equal(types, ['number', 'number'])
      lop - rop;
    when Array.equal(types, ['object', 'number'])
      lop.sub_number(rop)
    when Array.equal(types, ['object', 'object'])
      lop.sub_roll(rop)
    else
      undefined
