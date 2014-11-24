
describe "Helpers", ->

  describe "Object.merge(args...)", ->
    
    it "merges objects", ->
      a = {i: 3, j: 4}
      b = {f: 2, j: 7}
      expect(Object.merge(a, b)).toEqual {i:3, j:7, f:2}

  describe "Object.merge_with(target, args...)", ->
    
    it "merges objects in place", ->
      a = {i: 3, j: 4}
      b = {f: 2, j: 7}
      Object.merge_with(a, b)
      expect(a).toEqual {i:3, j:7, f:2}
 
  describe "Object.keep_only(o, keys...)", ->
    
    it "make a copy of the object, keeping only the required keys", ->
      a = {i: 3, j: 4, f: 2, u: 7}
      b = Object.keep_only(a, 'j', 'f')
      expect(a).not.toBe b
      expect(b).toEqual {j: 4, f: 2}
 
  describe "Object.keep_if(o, predicate)", ->
    
    it "make a copy of the object, keeping only the key/value pair that return true", ->
      a = {i: 3, j: 4, f: 2, u: 7}
      b = Object.keep_if(a, (k, v) -> return v % 2 == 0)
      expect(a).not.toBe b
      expect(b).toEqual {j: 4, f: 2}

  describe "Array.equal(a, b)", ->
    
    it "returns true if both arrays have the same elements in same order", ->
      a = [1,2,3,4,5]
      b = [1,2,3,4,5]
      c = [8,5,8,]
      d = [1,2,3,5,4]
      expect(Array.equal(a, b)).toBe true
      expect(Array.equal(a, c)).toBe false
      expect(Array.equal(a, d)).toBe false
 
  describe "Array.include(a, o)", ->
    it "says if an element is in an array", ->
      a = [1,2,3,4,5]
      expect(Array.include(a, 4)).toBe true
      expect(Array.include(a, 18)).toBe false
 
  describe "Array.popn(a, n)", ->
    it "pops n elements of the array", ->
      a = [1,2,3,4,5]
      b = Array.popn(a, 3)
      expect(a).toEqual [1,2]
      expect(b).toEqual [5,4,3]
      
  describe "String.trim(s)", ->
    it "removes spaces on the sides", ->
      a = " a  string    with   spaces on sides    "
      expect(String.trim(a)).toEqual "a  string    with   spaces on sides"

  describe "String.snake_case(s)", ->
    it "replaces spaces and ' with _", ->
      a = "Behold The String's Case Is All Camel"
      expect(String.snake_case(a)).toEqual "behold_the_string_s_case_is_all_camel"
      
    it "replaces consecutive spaces to one _", ->
      a = "Behold        The String"
      expect(String.snake_case(a)).toEqual "behold_the_string"
