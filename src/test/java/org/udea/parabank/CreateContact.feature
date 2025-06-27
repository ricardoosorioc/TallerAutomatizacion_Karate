@appcontact_createcontact
Feature: create contact to app contact

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json' 

    # Función para generar un email único
    * def generateUniqueEmail = function() { return 'karate_test_contact_' + java.lang.System.currentTimeMillis() + '_' + karate.uuid() + '@example.com'; }
    * def faker = new karate.get('faker') // Acceder a la instancia de Faker definida en karate-config.js

  Scenario: Login y crear un nuevo contacto exitosamente con verificacion
    # Prerrequisito: Login para obtener un token
    Given path '/users/login'
    And request { "email": "ri@ro.com", "password": "1234567" }
    When method POST
    Then status 200
    * def authToken = response.token

    # Generar datos únicos para el contacto
    * def newEmail = generateUniqueEmail()
    * def contactFirstName = faker.name().firstName()
    * def contactLastName = faker.name().lastName()

    # Crear contacto
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request {
      "firstName": "#(contactFirstName)",
      "lastName": "#(contactLastName)",
      "birthdate": "1990-01-01",
      "email": "#(newEmail)",
      "phone": "8005555555",
      "street1": "1 Main St.",
      "street2": "Apartment A",
      "city": "Anytown",
      "stateProvince": "KS",
      "postalCode": "12345",
      "country": "USA"
    }
    When method POST
    Then status 201
    And match response.firstName == contactFirstName
    And match response.lastName == contactLastName
    And match response.email == newEmail
    * def contactId = response._id // Guardar el ID del contacto creado

    # Criterio: El contacto se debe poder recuperar vía API (/contacts) inmediatamente después de crearlo.
    Given path '/contacts/' + contactId
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200
    And match response.firstName == contactFirstName
    And match response.lastName == contactLastName
    And match response.email == newEmail

  Scenario: Fallar al crear contacto por falta de campo requerido (firstName)
    # Prerrequisito: Login para obtener un token
    Given path '/users/login'
    And request { "email": "ri@ro.com", "password": "1234567" }
    When method POST
    Then status 200
    * def authToken = response.token

    # Intentar crear contacto sin firstName
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request { "lastName": "Gomez", "email": "#(generateUniqueEmail())" }
    When method POST
    Then status 400
    And match response.message contains 'firstName'
    And match response.message contains 'required'    

  Scenario: Fallar al crear contacto con email duplicado
    # Prerrequisito: Login para obtener un token
    Given path '/users/login'
    And request { "email": "ri@ro.com", "password": "1234567" }
    When method POST
    Then status 200
    * def authToken = response.token

    * def duplicateEmail = generateUniqueEmail()

    # Primero: Crear un contacto con el email que queremos duplicar
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request { "firstName": "First", "lastName": "Contact", "email": "#(duplicateEmail)" }
    When method POST
    Then status 201
    * def firstContactId = response._id // Guardar el ID para limpieza

    # Segundo: Intentar crear otro contacto con el mismo email
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request { "firstName": "Second", "lastName": "Contact", "email": "#(duplicateEmail)" }
    When method POST
    Then status 400
    And match response.message == 'Email already exists'
    
