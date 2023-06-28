//
//  ProductivityAppUITests.swift
//  ProductivityAppUITests
//
//  Created by Dinmukhambet Turysbay on 17.06.2023.
//

import XCTest

class AuthViewIsPresented: XCTestCase {
    
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func test_LoginScreenIsDisplayed() {
        XCTAssertTrue(app.textFields["emailTextField"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.secureTextFields["passwordTextField"].exists)
        XCTAssertTrue(app.buttons["loginButton"].exists)
    }
    
    func test_LoginProcess() {
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField =  app.secureTextFields["passwordTextField"]
        
        emailTextField.tap()
        emailTextField.typeText("test@email.com")
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123")
        
        let loginButton = app.buttons["loginButton"]
        loginButton.tap()
    }
    
    func test_RegistrationScreenIsDisplayed() {
        let goToRegisterButton = app.buttons["registerButton"]
        goToRegisterButton.tap()

        XCTAssertTrue(app.textFields["nameTextField"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.textFields["surnameTextField"].exists)
        XCTAssertTrue(app.textFields["emailTextField"].exists)
        XCTAssertTrue(app.secureTextFields["passwordTextField"].exists)
        XCTAssertTrue(app.buttons["registerButton"].exists)
    }
    
    func test_RegistrationProcess() {
        let goToRegisterButton = app.buttons["registerButton"]
        goToRegisterButton.tap()

        let nameTextField = app.textFields["nameTextField"]
        let surnameTextField = app.textFields["surnameTextField"]
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField =  app.secureTextFields["passwordTextField"]
        
        nameTextField.tap()
        nameTextField.typeText("John")
        
        surnameTextField.tap()
        surnameTextField.typeText("Doe")
        
        emailTextField.tap()
        emailTextField.typeText("john.doe@email.com")
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123")
        
        let registerButton = app.buttons["registerButton"]
        registerButton.tap()
    }
}

