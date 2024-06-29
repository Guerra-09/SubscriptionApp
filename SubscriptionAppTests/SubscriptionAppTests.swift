//
//  SubscriptionAppTests.swift
//  SubscriptionAppTests
//
//  Created by José Guerra on 10-04-24.
//
//
//import XCTest
//@testable import Subscription
//
//final class SubscriptionAppTests: XCTestCase {
//
//    func textInitialization() {
//        let name = "Test"
//        let price = 3.5
//        let startDate = Date()
//        var cycle = "monthly"
//        var description = "This is a test description"
//        var reminder = true
//        var reminderTime = "the same day"
//        var disableService = false
//        
//        let logo = "netflix_logo"
//        let logoColor = "000000"
//        let backgroundColor = "FFFFFF"
//        let textColor = "000000"
//        
//        let metaData = SubscriptionMetadata(
//            id: .init(),
//            logo: logo,
//            logoColor: logoColor,
//            backgroundColor: backgroundColor,
//            textColor: textColor
//        )
//        
//        let susbcription = Subscription(id: .init(),
//                                  name: name,
//                                        price: price ?? 0.0,
//                                  startDay: startDate,
//                                  cycle: cycle,
//                                  descriptionText: description,
//                                  reminder: reminder,
//                                  reminderTime: reminderTime,
//                                  disableService: disableService,
//                                  subscriptionMetadata: metaData)
//        
//        
//        XCTAssertEqual(subscription.name, name)
//    }
//
//}
