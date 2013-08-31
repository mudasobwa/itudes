Feature: itudes library helps to handle everything against [lat,long]itudes
   In order to improve developer experience with [lat,long]itude handling
  A developer simply includes the library and yields class

   Scenario: handy instantiation with floats
      Given the itudes are instantiated with floats (57.3,37.5)
      When I call `to_s` method
      And I call `to_a` method
      Then the proper string is to be created
      And the proper array is to be created
      And the value is considered to be valid

   Scenario: handy instantiation with strings
      Given the itudes are instantiated with strings (57.3,37.5)
      When I call `to_s` method
      And I call `to_a` method
      Then the proper string is to be created
      And the proper array is to be created
      And the value is considered to be valid

   Scenario: handy instantiation with an array
      Given the itudes are instantiated with an array (57.3,37.5)
      When I call `to_s` method
      And I call `to_a` method
      Then the proper string is to be created
      And the proper array is to be created
      And the value is considered to be valid

   Scenario: handy instantiation with string
      Given the itudes are instantiated with a string (53°11′18″N,37°5′18″E)
      When I call `to_s` method
      And I call `to_a` method
      Then the proper string is to be created
      And the proper array is to be created
      And the value is considered to be valid
      And the rounded value should equal to (53.0,37.0)

   Scenario: invalid instantiation
      Given the itudes are instantiated with a string (foo:bad)
      Then the value is not considered to be valid

   Scenario: distance between two points
      Given the itudes are instantiated with a string (53°11′18″N,37°5′18″E)
      When the other itudes are instantiated with an array (58 38 38N,003 04 12W)
      Then the value is considered to be valid
      And the distance equals to 2533 km
      And the distance in miles equals to 1574 mi

   Scenario: distance between two points with lazy Itudes instantiation
      Given the itudes are instantiated with a string (53°11′18″N,37°5′18″E)
      When the distance is calculated by implicit “- "58 38 38N,003 04 12W"”
      Then the calculated distance equals to 2533 km

   Scenario: distance between two points thru class method
      Given the itudes are given with a string (53°11′18″N,37°5′18″E)
      And the other itudes are given with a string (58 38 38N,003 04 12W)
      Then the classs method gives distance equals to 2533 km
