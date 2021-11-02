Feature: Set List

Scenario: User can see sets in set list
  Given A fresh app
  Given A logged in user
  When I tap the widget with the key "overviewListTile_Empty List"
  Then I expect the widget "setList" to be visible

#Scenario: User can add sets to a list
#  Given A fresh app
#  Given A logged in user
#  When I tap the widget with the key "createSetList"
#  When I fill the "setListName" field with "myNewlyCreatedList"
#  When I tap the button that contains the text "Create"
#  Then I expect the text "myNewlyCreatedList" to be present
#
#Scenario: User can delete sets from a list
#  Given A fresh app
#  Given A logged in user
#  When I tap the widget with the key "deleteSetList_myNewlyCreatedList"
#  When I tap the button that contains the text "Delete"
#  Then I expect the text "myNewlyCreatedList" to be absent
