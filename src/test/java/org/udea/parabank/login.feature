@appcontact_login
Feature: Login to app contact

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  Scenario: Customer Login
    Given path '/users/login'
    And request {"email": "ri@ro.com","password": "1234567"}
    When method POST
    Then status 200
     And match response.user._id == '#string'
    And match response.user.firstName == '#string'
    And match response.user.lastName == '#string'
    And match response.user.email == 'ri@ro.com' // Validar que el email retornado sea el que enviamos
    And match response.user.__v == '#number'
    And match response.token == '#string'

  Scenario: Login con credenciales inválidas (email o password incorrectos)
    Given path '/users/login'
    And request {"email": "ri@ro.com","password": "password_invalido"}
    When method POST
    Then status 401
    And match response.error == 'Incorrect email or password' // Mensaje de error claro

  Scenario: Login con email no existente
    Given path '/users/login'
    And request {"email": "noexiste@example.com","password": "1234567"}
    When method POST
    Then status 401
    And match response.error == 'Incorrect email or password'

  Scenario: Login con email sin formato válido (a nivel de API)
    Given path '/users/login'
    And request {"email": "email_invalido","password": "1234567"}
    When method POST
    Then status 401
    And match response.message == 'User validation failed: email: is not a valid email address'  

  Scenario: Login con campos requeridos faltantes (email ausente)
    Given path '/users/login'
    And request {"password": "1234567"}
    When method POST
    Then status 401
    And match response.message contains 'email'

  Scenario: Login con campos requeridos faltantes (password ausente)
    Given path '/users/login'
    And request {"email": "ri@ro.com"}
    When method POST
    Then status 401
    And match response.message contains 'password'
