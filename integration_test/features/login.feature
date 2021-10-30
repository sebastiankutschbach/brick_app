Feature: Login

Scenario: User can login with correct credentials and api key
  Given A fresh app
  When I login
  Then I expect the "SetList" to be visible