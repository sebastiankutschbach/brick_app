Feature: Login

Scenario: User cannot login without api key
  Given A fresh app
  When I login with username, with password and without api key
  Then I expect the text "Please set your api key under settings" to be present

Scenario: User cannot login without username
  Given A fresh app
  When I login without username, with password and with api key
  Then I expect the text "Username cannot be empty" to be present

Scenario: User cannot login without password
  Given A fresh app
  When I login with username, without password and with api key
  Then I expect the text "Password cannot be empty" to be present

Scenario: User can login with correct credentials and api key
  Given A fresh app
  When I login with username, with password and with api key
  Then I expect the widget "SetList" to be visible
