// Generated by CoffeeScript 1.6.3
(function() {
  describe("Helpers", function() {
    describe("Object.merge(args...)", function() {
      return it("merges objects", function() {
        var a, b;
        a = {
          i: 3,
          j: 4
        };
        b = {
          f: 2,
          j: 7
        };
        return expect(Object.merge(a, b)).toEqual({
          i: 3,
          j: 7,
          f: 2
        });
      });
    });
    describe("Object.merge_with(target, args...)", function() {
      return it("merges objects in place", function() {
        var a, b;
        a = {
          i: 3,
          j: 4
        };
        b = {
          f: 2,
          j: 7
        };
        Object.merge_with(a, b);
        return expect(a).toEqual({
          i: 3,
          j: 7,
          f: 2
        });
      });
    });
    describe("Object.keep_only(o, keys...)", function() {
      return it("make a copy of the object, keeping only the required keys", function() {
        var a, b;
        a = {
          i: 3,
          j: 4,
          f: 2,
          u: 7
        };
        b = Object.keep_only(a, 'j', 'f');
        expect(a).not.toBe(b);
        return expect(b).toEqual({
          j: 4,
          f: 2
        });
      });
    });
    describe("Object.keep_if(o, predicate)", function() {
      return it("make a copy of the object, keeping only the key/value pair that return true", function() {
        var a, b;
        a = {
          i: 3,
          j: 4,
          f: 2,
          u: 7
        };
        b = Object.keep_if(a, function(k, v) {
          return v % 2 === 0;
        });
        expect(a).not.toBe(b);
        return expect(b).toEqual({
          j: 4,
          f: 2
        });
      });
    });
    describe("Array.equal(a, b)", function() {
      return it("returns true if both arrays have the same elements in same order", function() {
        var a, b, c, d;
        a = [1, 2, 3, 4, 5];
        b = [1, 2, 3, 4, 5];
        c = [8, 5, 8];
        d = [1, 2, 3, 5, 4];
        expect(Array.equal(a, b)).toBe(true);
        expect(Array.equal(a, c)).toBe(false);
        return expect(Array.equal(a, d)).toBe(false);
      });
    });
    describe("Array.include(a, o)", function() {
      return it("says if an element is in an array", function() {
        var a;
        a = [1, 2, 3, 4, 5];
        expect(Array.include(a, 4)).toBe(true);
        return expect(Array.include(a, 18)).toBe(false);
      });
    });
    describe("Array.popn(a, n)", function() {
      return it("pops n elements of the array", function() {
        var a, b;
        a = [1, 2, 3, 4, 5];
        b = Array.popn(a, 3);
        expect(a).toEqual([1, 2]);
        return expect(b).toEqual([5, 4, 3]);
      });
    });
    describe("String.trim(s)", function() {
      return it("removes spaces on the sides", function() {
        var a;
        a = " a  string    with   spaces on sides    ";
        return expect(String.trim(a)).toEqual("a  string    with   spaces on sides");
      });
    });
    return describe("String.snake_case(s)", function() {
      it("replaces spaces and ' with _", function() {
        var a;
        a = "Behold The String's Case Is All Camel";
        return expect(String.snake_case(a)).toEqual("behold_the_string_s_case_is_all_camel");
      });
      return it("replaces consecutive spaces to one _", function() {
        var a;
        a = "Behold        The String";
        return expect(String.snake_case(a)).toEqual("behold_the_string");
      });
    });
  });

}).call(this);
