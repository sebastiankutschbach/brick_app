Feature: SetList

Scenario: User can see set list overview
  Given A fresh app
  Given A logged in user
  Then I expect the widget "SetList" to be visible
  Then I expect the text "Empty List" to be present

Scenario: User can add set list
  Given A fresh app
  Given A logged in user
  When I tap the button of type "FloatingActionButton"
  When I fill the "setListName" field with "myNewlyCreatedList"
  When I tap the button that contains the text "Create"
  Then I expect the text "myNewlyCreatedList" to be present

Scenario: User can delete set list
  Given A fresh app
  Given A logged in user
  When I tap the element of type "IconButton" within the "overviewListTile_myNewlyCreatedList"
  When I tap the button that contains the text "Delete"
  Then I expect the text "myNewlyCreatedList" to be absent
