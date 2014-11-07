parse = dice_roller_parser.parse

describe "Dice Roller Parser", ->

  describe 'parsing flat dice rolls', ->

    it '"3d10"', ->
      t = parse "3d10"
      expect(t).toEqual
        type: 'flat roll'
        modificators: []
        roll:
          type: 'number'
          value: '3'
          
    it '"7d10   "', ->
      t = parse "7d10   "
      expect(t).toEqual(parse "7d10")

    it '"   4d10"', ->
      t = parse "   4d10"
      expect(t).toEqual(parse "4d10")

    it 'throw an error on interspercing space "4 d10"', ->
      parse_bad = ->
        parse "4 d10"
      expect(parse_bad).toThrow()
      

  describe 'parsing trait rolls', ->
    
    it '"fire"', ->
      t = parse "fire"
      expect(t).toEqual
        type: 'trait roll'
        explode: true
        modificators: []
        roll:
          type: 'symbol'
          value: 'fire'
          
    it '"water   "', ->
      t = parse "water   "
      expect(t).toEqual(parse "water")
          
    it '"   willpower"', ->
      t = parse "   willpower"
      expect(t).toEqual(parse "willpower")


  describe 'parsing skill rolls', ->
    
    it '"trait/skill"', ->
      t = parse "trait/skill"
      expect(t).toEqual
        type: 'skill roll'
        explode: true
        modificators: []
        trait:
          type: 'symbol'
          value: 'trait'
        skill:
          type: 'symbol'
          value: 'skill'

    it '"trait/skill   "', ->
      t = parse "trait/skill"
      expect(t).toEqual(parse "trait/skill")

    it '"   trait/skill"', ->
      t = parse "trait/skill"
      expect(t).toEqual(parse "trait/skill")
    
  describe 'parsing explicit rolls', ->

    it '"4K3"', ->
      t = parse "4K3"
      expect(t).toEqual
        type: 'explicit roll'
        explode: true
        modificators: []
        roll:
          type: 'number'
          value: '4'
        keep:
          type: 'number'
          value: '3'
          
    it '"(agility + iaijutsu)Kagility"', ->
      t = parse "(agility + iaijutsu)Kagility"
      expect(t).toEqual
        type: 'explicit roll'
        explode: true
        modificators: []
        roll:
          type: '+'
          left:
            type: 'symbol'
            value: 'agility'
          right:
            type: 'symbol'
            value: 'iaijutsu'
        keep:
          type: 'symbol'
          value: 'agility'
          
    it '"(agility + iaijutsu)K(agility)"', ->
      t = parse "(agility + iaijutsu)Kagility"
      expect(t).toEqual(parse "(agility + iaijutsu)Kagility")

    it '"(agility + iaijutsu)K3"', ->
      t = parse "(agility + iaijutsu)K3"
      expect(t).toEqual
        type: 'explicit roll'
        explode: true
        modificators: []
        roll:
          type: '+'
          left:
            type: 'symbol'
            value: 'agility'
          right:
            type: 'symbol'
            value: 'iaijutsu'
        keep:
          type: 'number'
          value: '3'
          
    it '"(strength * 1.5 + 3)K2"', ->
      t = parse "(strength * 1.5 + 3)K2"
      expect(t).toEqual
        type: 'explicit roll'
        explode: true
        modificators: []
        roll:
          type: '+'
          left:
            type: '*'
            left: 
              type: 'symbol'
              value: 'strength'
            right:
              type: 'number'
              value: '1.5'
          right:
            type: 'number'
            value: '3'
        keep:
          type: 'number'
          value: '2'
          
    it '"(floor(strength * 1.5) + 3)K2"', ->
      t = parse "(floor(strength * 1.5) + 3)K2"
      expect(t).toEqual
        type: 'explicit roll'
        modificators: []
        explode: true
        roll:
          type: '+'
          left:
            type: 'function call'
            name: 'floor'
            arguments: [
              type: '*'
              left:
                type: 'symbol'
                value: 'strength'
              right:
                type: 'number'
                value: '1.5'
            ]
          right:
            type: 'number'
            value: '3'
        keep:
          type: 'number'
          value: '2'
          
    it '"(max(strength, perception)K2"', ->
      t = parse "(max(strength, perception))K2"
      expect(t).toEqual
        type: 'explicit roll'
        explode: true
        modificators: []
        roll:
          type: 'function call'
          name: 'max'
          arguments: [
            (type: 'symbol', value: 'strength')
            (type: 'symbol', value: 'perception')
          ]
        keep:
          type: 'number'
          value: '2'
          
    it '"   8K5"', ->
      t = parse "   8K5"
      expect(t).toEqual(parse "8K5")
      
    it '"7K1    "', ->
      t = parse "7K1    "
      expect(t).toEqual(parse "7K1")

  describe 'dice modificator option', ->
    
    it '"3K2^2"', ->
      t = parse "3K2^2"
      expect(t.modificators).toEqual [
          type: 'dice modificator'
          value:
            type: 'number'
            value: '2'
        ]
          
    it '"3K2^-2"', ->
      t = parse "3K2^-2"
      expect(t.modificators).toEqual [
          type: 'dice modificator'
          value:
            type: 'number'
            value: '-2'
        ]

    it '"3K2^earth"', ->
      t = parse "3K2^earth"
      expect(t.modificators).toEqual [
          type: 'dice modificator'
          value: 
            type: 'symbol'
            value: 'earth'
        ]

    it '"3K2^(honor.rank * 2)"', ->
      t = parse "3K2^(honor.rank * 2)"
      expect(t.modificators).toEqual [
          type: 'dice modificator'
          value:
            type: '*'
            right:
              type: 'number'
              value: '2'
            left:
              type: 'dot'
              right:
                type: 'symbol'
                value: 'rank'
              left:
                type: 'symbol'
                value: 'honor'
        ]

  describe 'roll modificator option', ->
    
    it '"3K2+2"', ->
      t = parse "3K2+2"
      expect(t.modificators).toEqual [
          type: 'roll bonus'
          value:
            type: 'number'
            value: '2'
        ]

    it '"3K2-2"', ->
      t = parse "3K2-2"
      expect(t.modificators).toEqual [
          type: 'roll penalty'
          value:
            type: 'number'
            value: '2'
        ]

    it '"3K2+(earth * 2)"', ->
      t = parse "3K2+(earth * 2)"
      expect(t.modificators).toEqual [
          type: 'roll bonus'
          value:
            type: '*'
            left:
              type: 'symbol'
              value: 'earth'
            right:
              type: 'number'
              value: '2'
        ]

  describe 'explosion threshold option', ->
    
    it '"3K2!9"', ->
      t = parse "3K2!9"
      expect(t.modificators).toEqual [
          type: 'explosion modificator'
          value:
            type: 'number'
            value: '9'
        ]

    it '"3K2!earth"', ->
      t = parse "3K2!earth"
      expect(t.modificators).toEqual [
          type: 'explosion modificator'
          value:
            type: 'symbol'
            value: 'earth'
        ]

    it '"3K2!(earth * 2)"', ->
      t = parse "3K2!(earth * 2)"
      expect(t.modificators).toEqual [
          type: 'explosion modificator'
          value:
            type: '*'
            left:
              type: 'symbol'
              value: 'earth'
            right:
              type: 'number'
              value: '2'
        ]
          
  describe 'no explosion option', ->

    it '"!3K2"', ->
      t = parse "!3K2"
      expect(t.explode).toBeFalsy()

  describe 'chaining options', ->

    it '"3K2!(earth * 2)^2"', ->
      t = parse "3K2!(earth * 2)^2"
      expect(t.modificators).toEqual [
          {
            type: 'explosion modificator'
            value:
              type: '*'
              left:
                type: 'symbol'
                value: 'earth'
              right:
                type: 'number'
                value: '2'
          }
          {
            type: 'dice modificator'
            value:
              type: 'number'
              value: '2'
          }
        ]