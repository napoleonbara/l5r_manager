
describe "Expression", ->

  parse = dice_roller_parser.parse
  Roll = window.Roll
  Expression = window.Expression

  it 'can be contructed with a string', ->
    str = '1D10 + 4'
    e = new Expression(str)
    expect(e.origin).toEqual str
    expect(e.rpn).toEqual parse(str)

  it 'can be contructed with a RPN array', ->
    rpn = [4, 5, '+', 3, '*']
    e = new Expression(rpn)
    expect(e.origin).toEqual rpn
    expect(e.rpn).toEqual rpn
          

  describe '#to_string', ->

    it '"3D10" => "3D10"', ->
      str = "3D10"
      e = new Expression(str)
      expect(e.to_string()).toEqual str

    it '"(3 + 5) * 2" => "(3 + 5) * 2"', ->
      str = "(3 + 5) * 2"
      e = new Expression(str)
      expect(e.to_string()).toEqual str

  describe '#evaluate', ->
    
    it 'can handle numerics', ->
      e = new Expression('(5 + 6) * 3 + 4')
      expect(e.evaluate({})).toEqual 37

    it 'can handle variables with a context', ->
      e = new Expression('(var one + 6) * var two + 4')
      expect(e.evaluate({'var one': 5, 'var two': 3})).toEqual 37

    it 'can handle function calls with a context', ->
      e = new Expression('first(a, b, c, d)')
      ctx =
        first: (args) ->
          args[0]
        a: 5
        b: 4
        c: 3
        d: 8
      expect(e.evaluate(ctx)).toEqual ctx.a
     
    it 'can handle simple dice rolls', ->
      e = new Expression('(three)D(eight)')
      ctx =
        three: 3
        eight: 8
      expect(e.evaluate(ctx)).toEqual new Roll(roll: 3, type: 8)

    it 'generates non explosive rolls by default', ->
      e = new Expression('(four)D6')
      ctx =
        four: 4
      roll = e.evaluate(ctx)
      expect(roll.explode).toEqual false
      
    it 'can handle L5R "roll and keep" dice rolls', ->
      e = new Expression('(eight)K(three)')
      ctx =
        three: 3
        eight: 8
      expect(e.evaluate(ctx)).toEqual new Roll(mode: 'L5R', roll: 8, keep: 3, explosion_threshold: 10, explode: true)

    it 'can handle L5R skill rolls', ->
      e = new Expression('(two)|(three)')
      ctx =
        three: 3
        two: 2
      expect(e.evaluate(ctx)).toEqual new Roll(mode: 'L5R', roll: 5, keep: 2, explosion_threshold: 10, explode: true)
      
    it 'generates explosive L5R rolls by default', ->
      e = new Expression('(four)K(three)')
      ctx =
        three: 3
        four: 4
      roll = e.evaluate(ctx)
      expect(roll.explode).toEqual true

    it 'can handle non explosive dice rolls', ->
      e = new Expression('!(four)K(three)')
      ctx =
        three: 3
        four: 4
      roll = e.evaluate(ctx)
      expect(roll.explode).toEqual false

    it 'can handle complex roll bonuses', ->
      e = new Expression('(four)K(three) + three * 2')
      ctx =
        three: 3
        four: 4
      expect(e.evaluate(ctx).roll_modif).toEqual 6
      
    it 'can handle complex roll penalty', ->
      e = new Expression('(four)K(three) - three * 2')
      ctx =
        three: 3
        four: 4
      expect(e.evaluate(ctx).roll_modif).toEqual -6
     
    it 'can chain roll modificators', ->
      e = new Expression('(four)K(three) + three * 2 - wound penalty')
      ctx =
        three: 3
        four: 4
        'wound penalty': 10
      expect(e.evaluate(ctx).roll_modif).toEqual -4
     
    it 'can add roll dices to each other', ->
      e = new Expression('(four)K(three) + 1K2')
      ctx =
        three: 3
        four: 4
      expect(e.evaluate(ctx)).toEqual  new Roll(mode: 'L5R', roll: 4+1, keep: 3+2, explosion_threshold: 10, explode: true)
      
    it 'can compute insight rank', ->
      e = new Expression 'max(1, floor((insight - 150) / 25) + 2)'
      ctx =
        floor: (args) -> Math.floor(args[0])
        max: (args) -> Math.max.apply(null, args)
      ctx.insight = 149
      expect(e.evaluate(ctx)).toEqual  1
      ctx.insight = 150
      expect(e.evaluate(ctx)).toEqual  2
      ctx.insight = 174
      expect(e.evaluate(ctx)).toEqual  2
      ctx.insight = 175
      expect(e.evaluate(ctx)).toEqual  3
      ctx.insight = 199
      expect(e.evaluate(ctx)).toEqual  3
      ctx.insight = 200
      expect(e.evaluate(ctx)).toEqual  4
      ctx.insight = 224
      expect(e.evaluate(ctx)).toEqual  4
      ctx.insight = 225
      expect(e.evaluate(ctx)).toEqual  5
      
      
  describe 'handle_rule', ->
  
    handle_rule = window.handle_rule
    
    describe "operator =", ->
      
      it "can create new variables in the context", ->
        ctx =
          eight: 8
          four: 4
          two: 2
        handle_rule(ctx, 'sixteen = eight * four / two')
        expect(ctx).toEqual(
          eight: 8
          four: 4
          two: 2
          sixteen: 16)

      it "overwrites exsisting variables", ->
        ctx =
          eight: 8

        handle_rule(ctx, 'eight = 4')
        expect(ctx.eight).toEqual(4)
          
    describe "operator +=", ->
      
      it "can add to old variables in the context", ->
        ctx_1 =
          reflexes: 3
          "insight rank": 1
          iaijutsu: 4
          
        ctx_2 = 
          reflexes: 3
          "insight rank": 1
          iaijutsu: 4

        handle_rule(ctx_1, 'initiative = reflexes|insight rank')
        handle_rule(ctx_1, 'initiative += iaijutsu * 2')
        
        handle_rule(ctx_2, 'initiative = reflexes|insight rank + iaijutsu * 2')
        
        expect(ctx_1.initiative).toEqual(ctx_2.initiative)

      it "throws on adding to uncknown variables", ->
        ctx =
          iaijutsu: 4
          
        expect(-> handle_rule(ctx, 'initiative += iaijutsu * 2')).toThrow("don't know the symbol initiative")


    describe "operator -=", ->
      
      it "can add to old variables in the context", ->
        ctx_1 =
          reflexes: 3
          "wound penalty": 10
          iaijutsu: 4
          
        ctx_2 = 
          reflexes: 3
          "wound penalty": 10
          iaijutsu: 4

        handle_rule(ctx_1, 'attack = reflexes|iaijutsu')
        handle_rule(ctx_1, 'attack -= wound penalty')
        
        handle_rule(ctx_2, 'attack = reflexes|iaijutsu - wound penalty')
        
        expect(ctx_1.attack).toEqual(ctx_2.attack)

      it "throws on adding to uncknown variables", ->
        ctx =
          iaijutsu: 4
          
        expect(-> handle_rule(ctx, 'initiative -= iaijutsu * 2')).toThrow("don't know the symbol initiative")
          
# describe 'handle_query'
    
