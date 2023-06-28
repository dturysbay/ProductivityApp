//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//import XCTest
//@testable import ProductivityApp
//
//protocol AuthenticationService {
//    func createUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void)
//    func signIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void)
//}
//
//struct User {
//    let uid: String
//    let email: String
//}
//
//class FirebaseAuthenticationService: AuthenticationService {
//    func createUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
//    }
//
//    func signIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
//    }
//}

//class MockAuthenticationService: AuthenticationService {
//    var createUserResult: (User?, Error?) = (nil, nil)
//
//    func createUser(withEmail email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
//        completion(createUserResult.0, createUserResult.1)
//    }
//}

//class MockAuthenticationService: AuthenticationService {
//    var createUserResult: (AuthDataResult?, Error?) = (nil, nil)
//    var signInResult: (AuthDataResult?, Error?) = (nil, nil)
//
//    func createUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
//        completion(createUserResult.0, createUserResult.1)
//    }
//
//    func signIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
//        completion(signInResult.0, signInResult.1)
//    }
//}
//
//class AuthenticationController: ObservableObject {
//    @Published var user: User?
//        @Published var error: Error?
//        var auth: AuthenticationService
//
//        init(auth: AuthenticationService) {
//            self.auth = auth
//        }
//
//        func register(withEmail email: String, password: String) {
//            auth.createUser(withEmail: email, password: password) { (user, error) in
//                DispatchQueue.main.async {
//                    self.user = user
//                    self.error = error
//                }
//            }
//        }
//    func register(withEmail email: String, password: String) {
//        auth.createUser(withEmail: email, password: password) { (user, error) in
//            DispatchQueue.main.async {
//                self.user = user
//                self.error = error
//            }
//        }
//    }
//}
//
//class AuthenticationControllerTests: XCTestCase {
////    func testRegister() {
////            let mockAuth = MockAuthenticationService()
////            mockAuth.createUserResult = (User(uid: "testUID", email: "test@test.com"), nil)
////            let authController = AuthenticationController(auth: mockAuth)
////            let expectation = self.expectation(description: "User is created")
////
////            authController.register(withEmail: "test@test.com", password: "testPassword")
////
////            waitForExpectations(timeout: 5) { error in
////                if let error = error {
////                    XCTFail("waitForExpectations failed with error: \(error)")
////                }
////
////                XCTAssertEqual(authController.user?.uid, "testUID")
////                XCTAssertEqual(authController.user?.email, "test@test.com")
////                XCTAssertNil(authController.error)
////            }
////        }
//
//    func testLoginSuccess() {
//         let mockAuthService = MockAuthenticationService()
//         let controller = AuthenticationController(authService: mockAuthService)
//
//         // Set up a successful login
//         mockAuthService.signInResult = (AuthDataResult(), nil)
//
//         controller.login()
//
//         XCTAssertEqual(controller.screenState, .userAuthorized)
//     }
//    func testRegister() {
//            let mockAuth = MockAuthenticationService()
//            mockAuth.createUserResult = (User(uid: "testUID", email: "test@test.com"), nil)
//            let authController = AuthenticationController(auth: mockAuth)
//
//            // Set expectations for the completion handler
//            let expectation = self.expectation(description: "User is created")
//
//            authController.register(withEmail: "test@test.com", password: "testPassword")
//
//            // Wait for the completion handler to be called
//            waitForExpectations(timeout: 5) { error in
//                if let error = error {
//                    XCTFail("waitForExpectations failed with error: \(error)")
//                }
//
//                // Verify the results
//                XCTAssertEqual(authController.user?.uid, "testUID")
//                XCTAssertEqual(authController.user?.email, "test@test.com")
//                XCTAssertNil(authController.error)
//            }
//        }
//
////    func testRegisterFailure() {
////        let mockAuthService = MockAuthenticationService()
////        let authController = AuthenticationController(auth: mockAuthService)
////
////        let authError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
////        mockAuthService.createUserResult = (nil, authError)
////
////        authController.register(withEmail: "test@example.com", password: "password")
////
////        XCTAssertNil(authController.user, "User should be nil after failed registration")
////        XCTAssertNotNil(authController.error, "Error should not be nil after failed registration")
////        XCTAssertEqual(authController.error?.localizedDescription, authError.localizedDescription, "Error message should match the test error message")
////    }
//}
