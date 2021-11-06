Feature: Set List

Scenario: User can see sets in set list
  Given A fresh app
  Given A logged in user
  When I tap the "overviewListTile_Empty List" widget
  Then I expect the widget "setList" to be visible

Scenario: User can add sets to a list
  Given A fresh app
  Given A logged in user
  When I tap the "overviewListTile_Empty List" widget
  When I tap the "addSetButton" button
  When I fill the "setIdInput" field with "71234-1"
  When I tap the button that contains the text "Add to list"
  Then I expect the text "Sensei Wu Fun Pack" to be present

Scenario: User can delete sets from a list
  Given A fresh app
  Given A logged in user
  When I tap the widget with the key "overviewListTile_Empty List"
  When I tap the "delete_from_list_button_71234-1" button
  Then I expect the text "Sensei Wu Fun Pack" to be absent
