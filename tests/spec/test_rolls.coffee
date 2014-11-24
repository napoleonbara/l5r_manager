
parse = parser.parse

symbol = (value) ->
  type: 'symbol'
  value: value

number = (value) ->
  type: 'number'
  value: String(value)

dice_modifier = (value) ->
  type: 'dice modifier'
  value: value
  
explosion_modifier = (value) ->
  type: 'explosion modifier'
  value: value
  
generic_roll = (opts) ->
  type: 'generic roll'
  dice_number: opts.dice_number ? null
  dice_type: opts.dice_type ? null
  
skill_roll = (opts) ->
  type: 'skill roll'
  trait: opts.trait ? null
  skill: opts.skill ? null

roll_and_keep = (opts) ->
  type: 'roll and keep'
  roll: opts.roll ? null
  keep: opts.keep ? null
  
roll = (opts) ->
  type: 'roll'
  modifiers: opts.modifiers ? null
  explode: opts.explode ? null
  description: opts.description ? null
 
mult = (left, right) ->
  type: '*'
  left: left
  right: right

add = (left, right) ->
  type: '+'
  left: left
  right: right
  
assignment = (opts) ->
  type: 'assignment'
  var_name: opts.var_name ? null
  l_value: opts.l_value ? null

appendage = (opts) ->
  type: 'appendage'
  var_name: opts.var_name ? null
  l_value: opts.l_value ? null

describe 'definitions', ->

  it 'works with arbitrary expressions', ->
    expect(parse('initiative = reflexes/insight_rank + iaijutsu * 2')).toEqual 
      assignment
        var_name: symbol('initiative')
        l_value: add
          roll
            modifiers: []
            explode: false
            description: skill_roll
              trait: symbol('reflexes')
              skill: symbol('insight_rank')
          mult
            symbol('iaijutsu')
            number(2)

describe 'appendage', ->

  it 'works with a roll and keep dice roll', ->
    expect(parse('damages += 1K0')).toEqual 
      appendage
        var_name: symbol('damages')
        modifiers: roll
          modifiers: []
          explode: false
          description: roll_and_keep
            roll: number(1)
            keep: number(0)
            
  it 'works with an arbitrary expression', ->
    expect(parse('damages += earth * 2')).toEqual 
      appendage
        var_name: symbol('damages')
        modifiers: mult
          symbol('earth'),
          number(2)

  it 'works with modifiers', ->
    expect(parse('damages += ^ 2 ! 9')).toEqual 
      appendage
        var_name: symbol('damages')
        modifiers: [
          dice_modifier(number(2))
          exlosion_modifier(number(9)),
        ]
          
describe 'generic rolls', ->

  describe 'basic definition', ->
  
    it 'can be natural numbers', ->
      expect(parse('4D8')).toEqual roll
        modifiers: null
        explode: false
        description: generic_roll
          dice_number: number(4)
          dice_type: number(8)
          
    it 'can be symbols and expressions in parentheses', ->
      expect(parse('a_symbolD(another_symbol * 2)')).toEqual roll
        modifiers: null
        explode: false
        description: generic roll
          dice_number: symbol('a_symbol')
          dice_type: mult
            symbol('another_symbol'),
            number(2)

    it 'can omit the number of dice', ->
      expect(parse('D6')).toEqual roll
        modifiers: null
        explode: false
        description: generic roll
          dice_number: null
          dice_type: 6
          
    it 'can omit the type of dice', ->
      expect(parse('4D')).toEqual roll
        modifiers: null
        explode: false
        description: generic roll
          dice_number: 4
          dice_type: null
          
    it 'can omit both type and number of dice', ->
      expect(parse('D')).toEqual roll
        modifiers: null
        explode: false
        description: generic roll
          dice_number: null
          dice_type: null
          
  describe 'modifiers', ->
  
    it 'can take a explosion flag option', ->
      expect(parse('!3D6')).toEqual roll
        modifiers: null
        explode: true
        description: generic_roll
          dice_number: number(3)
          dice_type: number(6)
    
    it 'can take a explosion threshold', ->
      expect(parse('3D6 ! 5')).toEqual roll
        modifiers: [exlosion_modifier(number(5))]
        explode: false
        description: generic_roll
          dice_number: number(3)
          dice_type: number(6)
          
    it 'can take a per dice modifier option', ->
      expect(parse('3D6 ^ 2')).toEqual roll
        modifiers: [dice_modifier(number(2))]
        explode: false
        description: generic_roll
          dice_number: number(3)
          dice_type: number(6)
          
    it 'can take combined options', ->
      expect(parse('!3D6 ! 5 ^ 6')).toEqual roll
        modifiers: [exlosion_modifier(number(5)), dice_modifier(number(6))]
        explode: true
        description: generic_roll
          dice_number: number(3)
          dice_type: number(6)