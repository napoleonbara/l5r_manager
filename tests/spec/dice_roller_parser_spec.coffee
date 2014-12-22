parse = dice_roller_parser.parse

describe "Dice Roller Parser in RPN", ->

  describe 'parsing flat dice rolls', ->

    it '"  3D10   "', ->
      t = parse "  3D10   "
      expect(t).toEqual [3, 10, 'POOL_ROLL']

    it '"4 D 8"', ->
      t = parse "4 D 8"
      expect(t).toEqual [4, 8, 'POOL_ROLL']
      

  describe 'parsing trait rolls', ->
    
    it '"K fire"', ->
      t = parse "K fire"
      expect(t).toEqual ['fire', 'fire', 'ROLL_AND_KEEP']

  describe 'parsing skill rolls', ->
    
    it '"trait | skill"', ->
      t = parse "trait | skill"
      expect(t).toEqual ['trait', 'skill', '+', 'trait', 'ROLL_AND_KEEP']

  describe 'parsing explicit rolls', ->

    it '"4 K 3"', ->
      t = parse "4 K 3"
      expect(t).toEqual [4, 3, 'ROLL_AND_KEEP']
          
    it '"(agility + iaijutsu - 2)Kagility"', ->
      t = parse "(agility + iaijutsu - 2)Kagility"
      expect(t).toEqual ['agility', 'iaijutsu', 2, '-',  '+', 'agility', 'ROLL_AND_KEEP']
          
    it '"(strength * 1.5 + 3)K2"', ->
      t = parse "(strength * 1.5 + 3)K2"
      expect(t).toEqual ['strength', 1.5, '*', 3, '+', 2, 'ROLL_AND_KEEP']
          
    it '"(floor(strength * 1.5) + 3)K2"', ->
      t = parse "(floor(strength * 1.5) + 3)K2"
      expect(t).toEqual ['ARG_LIST_BOTTOM', 'strength', 1.5, '*', 'floor', 'FUNCTION_CALL', 3, '+', 2, 'ROLL_AND_KEEP']
          
    it '"(max(strength, perception))K2"', ->
      t = parse "(max(strength, perception))K2"
      expect(t).toEqual ['ARG_LIST_BOTTOM', 'strength', 'perception', 'max', 'FUNCTION_CALL', 2, 'ROLL_AND_KEEP']
          


  describe 'dice modificator option', ->
    
    it '"3K2 ^ 2"', ->
      t = parse "3K2 ^ 2"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 2, 'DICE_MODIF']
          
    it '"3K2^-2"', ->
      t = parse "3K2^(-2)"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', -2, 'DICE_MODIF']

    it '"3K2^earth"', ->
      t = parse "3K2^earth"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 'earth', 'DICE_MODIF']

    it '"3K2^(honor.rank * 2)"', ->
      t = parse "3K2^(honor rank * 2)"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 'honor rank', 2, '*', 'DICE_MODIF']

  describe 'roll modificator option', ->
    
    it '"3K2+2"', ->
      t = parse "3K2+2"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 2, '+']

    it '"3K2-2"', ->
      t = parse "3K2-2"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 2, '-']

    it '"3K2+(earth * 2)"', ->
      t = parse "3K2+(earth * 2)"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 'earth', 2, '*', '+']

  describe 'explosion threshold option', ->
    
    it '"3K2!9"', ->
      t = parse "3K2!9"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 9, 'EXPLOSION_THRESHOLD']

    it '"3K2!earth"', ->
      t = parse "3K2!earth"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 'earth', 'EXPLOSION_THRESHOLD']
          
  describe 'no explosion option', ->

    it '"!3K2"', ->
      t = parse "!3K2"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 'EXPLODE_FLAG']

  describe 'chaining options', ->

    it '"3K2!(earth * 2)^2"', ->
      t = parse "3K2!(earth * 2)^2"
      expect(t).toEqual [3, 2, 'ROLL_AND_KEEP', 'earth', 2, '*', 'EXPLOSION_THRESHOLD', 2, 'DICE_MODIF']

  describe 'statements', ->
    
    describe 'definition', ->
      
      it '"initiative = reflexes|insight rank"', ->
        t = parse "initiative = reflexes|insight rank"
        expect(t).toEqual { define: 'initiative', as: [ 'reflexes', 'insight rank', '+', 'reflexes', 'ROLL_AND_KEEP' ] }

    describe 'addition', ->
      
      it '"initiative += iaijutsu * 2"', ->
        t = parse "initiative += iaijutsu * 2"
        expect(t).toEqual { add: [ 'iaijutsu', 2, '*' ], to: 'initiative' } 
        
    describe 'substration', ->
      
      it '"initiative -= wound penalty"', ->
        t = parse "initiative -= wound penalty"
        expect(t).toEqual { subtract: [ 'wound penalty' ], from:  'initiative' }