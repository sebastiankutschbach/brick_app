Feature: SetList

Scenario: User can see set list overview
  Given A fresh app
  Given A logged in user
  Then I expect the widget "SetList" to be visible
