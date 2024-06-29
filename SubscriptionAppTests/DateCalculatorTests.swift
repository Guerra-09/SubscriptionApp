//
//  DateCalculatorTests.swift
//  SubscriptionAppTests
//
//  Created by José Guerra on 29-06-24.
//

import XCTest
@testable import SubscriptionApp

final class DateCalculatorTests: XCTestCase {
    /// Importante: Debido a que la funcion calcula las fechas en base a la fecha actual, no se pueden hacer tests, de fechas anteriores o futuras, hay que ir cambiando las fechas al presente.
    
    var dateCalculator: DateCalculator!
    let formatter = DateFormatter()

    override func setUp() {
        super.setUp()
        dateCalculator = DateCalculator()
        
        formatter.dateFormat = "d-MM-yyyy"
        formatter.timeZone = TimeZone.current
    }
    
    override func tearDown() {
        dateCalculator = nil
        super.tearDown()
    }
    
    
    /// Funcion para testear que calcule bien los dias faltantes hasta la siguiente notificacion/facturacion .
    func testCalculateMonthlyCycleDays() {
     
        // Test 1: Un par de dias despues
        let startDate = formatter.date(from: "02-06-2024")
        let expectedDays = 3
        let calculatedDays = dateCalculator.daysUntilMonthly(startDate: startDate!)
        XCTAssertEqual(calculatedDays, expectedDays, "")
        
        // Test 2: El mismo dia
        let startDate2 = formatter.date(from: "29-06-2024")
        let expectedDays2 = 0
        let calculatedDays2 = dateCalculator.daysUntilMonthly(startDate: startDate2!)
        XCTAssertEqual(calculatedDays2, expectedDays2, "")
        
        // Test 3: Cuando el mes anterior tiene 31 dias y el mes de ahora 30
        let startDate3 = formatter.date(from: "31-05-2024")
        let expectedDays3 = 1
        let calculatedDays3 = dateCalculator.daysUntilMonthly(startDate: startDate3!)
        XCTAssertEqual(calculatedDays3, expectedDays3, "Deberia dar 1 solo dia, ya que no tiene mas dias.")
    }
  
    
    /// Funcion para testear que calcule bien de un fecha a otra.
    func testCalculateMonthlyCycleDate() {

        // Test case 1: Dia 15 del siguiente mes.
        let startDate1 = formatter.date(from: "15-06-2024")
        let expectedDate1 = formatter.date(from: "15-07-2024")
        let calculatedDate1 = dateCalculator.getNextPaymentDateMonthly(startDate: startDate1!)
        XCTAssertEqual(calculatedDate1, expectedDate1, "Deberia aumentar solo el mes")
        
        
        // Test case 2: Dia 31 cuando el siguiente mes solo tiene 30 dias.
        let startDate2 = formatter.date(from: "31-05-2024")
        let expectedDate2 = formatter.date(from: "30-06-2024")
        let calculatedDate2 = dateCalculator.getNextPaymentDateMonthly(startDate: startDate2!)
        XCTAssertEqual(calculatedDate2, expectedDate2, "Si la fecha seleccionada tiene un dia que no tiene el mes siguiente, deberia tomar el ultimo dia de ese mes")
    }
    
    
    /// Funcion para testear que calcule bien los dias faltantes hasta la siguiente notificacion/facturacion .
    func testCalculateThreeMonthsDays() {
        
        // Test 1: Un par de dias despues
        let startDate = formatter.date(from: "31-03-2024")
        let expectedDays = 2
        let calculatedDays = dateCalculator.daysUntilThreeMonths(startDate: startDate!)
        XCTAssertEqual(calculatedDays, expectedDays, "")
        
        
    }
    
    
}
