//
//  DateCalculatorTests.swift
//  SubscriptionAppTests
//
//  Created by José Guerra on 29-06-24.
//

import XCTest
@testable import SubscriptionApp

final class DateCalculatorTests: XCTestCase {
    
    var dateCalculator: DateCalculator!
    let formatter = DateFormatter()
    var testCaseDate = Date.now

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
    
    /// Falta testear los años bisciestos.
    
    /// Funcion para testear que calcule bien de un fecha a otra mes a mes.
    func testCalculateMonthlyCycleDate() {
        
        // Test case 1: Dia 15 del siguiente mes.
        let startDate1 = formatter.date(from: "15-06-2024")!
        let now1 = formatter.date(from: "01-07-2024")!
        let expectedDate1 = formatter.date(from: "15-07-2024")!
        
        let sut1 = dateCalculator.getNextPaymentDateMonthly(startDate: startDate1, testDate: now1)
        
        XCTAssertEqual(sut1, expectedDate1, "Deberia aumentar solo el mes")
        
        
        
        // Test case 2: Dia 31 cuando el siguiente mes solo tiene 29 dias.
        let startDate2 = formatter.date(from: "31-12-2023")!
        let now2 = formatter.date(from: "01-02-2024")!
        let expectedDate2 = formatter.date(from: "29-02-2024")!
        
        let sut2 = dateCalculator.getNextPaymentDateMonthly(startDate: startDate2, testDate: now2)
        
        XCTAssertEqual(sut2, expectedDate2, "Si la fecha seleccionada tiene un dia que no tiene el mes siguiente, deberia tomar el ultimo dia de ese mes")
        
     
        
        //Test case 3: Paso de un año a otro
        let startDate3 = formatter.date(from: "25-05-2024")!
        let now3 = formatter.date(from: "29-12-2024")!
        let expectedDate3 = formatter.date(from: "25-01-2025")!
        
        let sut3 = dateCalculator.getNextPaymentDateMonthly(startDate: startDate3, testDate: now3)
        
        XCTAssertEqual(expectedDate3, sut3)

        
    }
    
    
    /// Funcion para testear que calcule bien los dias restantes de factura de manera mensual.
    func testCalculateMonthlyDaysUntilPayment() {
        
        //Test 1: Calcular los dias en el siguiente mes.
        let startDate = formatter.date(from: "15-01-2024")!
        let testDate = formatter.date(from: "10-02-2024")
        let expectedResult = 5
        
        let sut1 = dateCalculator.daysUntilMonthly(startDate: startDate, now: testDate!)

        XCTAssertEqual(sut1, expectedResult)
        
        
        
        //Test 2: Calcular bien los dias de un año a otro.
        let startDate2 = formatter.date(from: "20-07-2024")!
        let testDate2 = formatter.date(from: "10-01-2025")
        let expectedResult2 = 10
        
        let sut2 = dateCalculator.daysUntilMonthly(startDate: startDate2, now: testDate2!)
        
        XCTAssertEqual(sut2, expectedResult2)
        
        
        
        
    }
    
    
    /// Funcion para testear que calcule bien de una fecha a otra las subscripciones cada 3 meses.
    func testCalculateThreeMonthsCycleDate() {
        
        // Test 1: Calculando de 01-01-2024 al 01-03-2024
        let startDate = formatter.date(from: "01-01-2024")
        let testDate = formatter.date(from: "05-02-2024")
        let expectedDate = formatter.date(from: "01-04-2024")
        
        let sut1 = dateCalculator.getNextPaymentDateThreeMonths(startDate: startDate!, testDate: testDate!)
        
        XCTAssertEqual(sut1, expectedDate)
        
        
        // Test 1.1: Caso exepcional: 07/06/2024
        let startDate11 = formatter.date(from: "07-06-2024")
        let testDate11 = formatter.date(from: "08-06-2024")
        let expectedDate11 = formatter.date(from: "07-09-2024")
        
        let sut11 = dateCalculator.getNextPaymentDateThreeMonths(startDate: startDate11!, testDate: testDate11!)
        
        XCTAssertEqual(sut11, expectedDate11)
        
        
        // Test 2: Calculando de un año a otro
        let startDate2 = formatter.date(from: "01-10-2024")
        let testDate2 = formatter.date(from: "05-10-2024")
        let expectedDate2 = formatter.date(from: "01-01-2025")
        
        let sut2 = dateCalculator.getNextPaymentDateThreeMonths(startDate: startDate2!, testDate: testDate2!)
        
        XCTAssertEqual(sut2, expectedDate2)
        
        
        
        // Test 2.1: Calculando de un año a otro estando en el año siguiente
        let startDate21 = formatter.date(from: "15-10-2024")
        let testDate21 = formatter.date(from: "05-01-2025")
        let expectedDate21 = formatter.date(from: "15-01-2025")
        
        let sut21 = dateCalculator.getNextPaymentDateThreeMonths(startDate: startDate21!, testDate: testDate21!)
        
        XCTAssertEqual(sut21, expectedDate21)
 
        
        
        // Test 3: Calculando cuando el mes de inicio tiene un dia que el mes actual no tiene
        let startDate3 = formatter.date(from: "31-01-2024")
        let testDate3 = formatter.date(from: "02-02-2024")
        let expectedDate3 = formatter.date(from: "30-04-2024")
        
        let sut3 = dateCalculator.getNextPaymentDateThreeMonths(startDate: startDate3!, testDate: testDate3!)
        
        XCTAssertEqual(sut3, expectedDate3)
        
        
        
        
    }
    
    
    /// Funcion para testear que calcule bien los dias restantes de factura de manera tri-mestral.
    func testCalculateThreeMonthsDaysUntilPayment() {
        
        // Test 1: Calcular los dias en el siguiente mes.
        let startDate = formatter.date(from: "15-01-2024")!
        let testDate = formatter.date(from: "10-04-2024")!
        let expectedResult = 5
        
        let sut1 = dateCalculator.daysUntilThreeMonths(startDate: startDate, testDate: testDate)

        XCTAssertEqual(sut1, expectedResult)
        
        
        // Test 2: Calcular los dias de un año a otro.
        let startDate2 = formatter.date(from: "15-10-2024")!
        let testDate2 = formatter.date(from: "5-01-2025")!
        let expectedResult2 = 10
        
        let sut2 = dateCalculator.daysUntilThreeMonths(startDate: startDate2, testDate: testDate2)
        
        XCTAssertEqual(sut2, expectedResult2)
        
        
        
        // Test 3: Calcular los dias que no existen en el mes de pago
        let startDate3 = formatter.date(from: "31-03-2024")
        let testDate3 = formatter.date(from: "13-04-2024")
        let expectedResult3 = 78
        
        let sut3 = dateCalculator.daysUntilThreeMonths(startDate: startDate3!, testDate: testDate3!)
        
        XCTAssertEqual(sut3, expectedResult3)
        
        
        
    }
    
    
    /// Funcion para testear que calcule bien de una fecha a otra las subscripciones cada 6 meses.
    func testCalculateSixMonthsCycleDate() {
        
        // Test 1: Calcular la fecha de un dia a 6 meses despues
        let startDate = formatter.date(from: "01-01-2024")
        let testDate = formatter.date(from: "01-02-2024")
        let expectedDate = formatter.date(from: "01-06-2024")
        
        let sut = dateCalculator.getNextPaymentDateSixMonths(startDate: startDate!, testDate: testDate!)
        
        XCTAssertEqual(sut, expectedDate)
        
        
        // Test 2: Calcular la fecha de un año a otro
        let startDate2 = formatter.date(from: "08-08-2024")
        let testDate2 = formatter.date(from: "09-09-2024")
        let expectedDate2 = formatter.date(from: "08-01-2025")
        
        let sut2 = dateCalculator.getNextPaymentDateSixMonths(startDate: startDate2!, testDate: testDate2!)
        
        XCTAssertEqual(sut2, expectedDate2)
        
        
        // Test 3: Calcular los dias que no existen en el mes de pago
        let startDate3 = formatter.date(from: "31-03-2028")
        let testDate3 = formatter.date(from: "05-05-2028")
        let expectedDate3 = formatter.date(from: "30-09-2028")
        
        let sut3 = dateCalculator.getNextPaymentDateSixMonths(startDate: startDate3!, testDate: testDate3!)
        
        XCTAssertEqual(sut3, expectedDate3)
        
        
    }
    
    
    /// Funcion para testear que calcule bien los dias restantes de factura cada 6 meses.
    func testCalculateSixMonthsDaysUntilPayment() {
        
        
        // Test 1: Calcular los dias en el siguiente mes.
        let startDate = formatter.date(from: "15-01-2024")!
        let testDate = formatter.date(from: "10-07-2024")!
        let expectedResult = 5
        
        let sut1 = dateCalculator.daysUntilSixMonths(startDate: startDate, testDate: testDate)

        XCTAssertEqual(sut1, expectedResult)
        
        
        
        // Test 2: Calcular los dias de un año a otro.
        let startDate2 = formatter.date(from: "15-07-2024")!
        let testDate2 = formatter.date(from: "05-01-2025")!
        let expectedResult2 = 10
        
        let sut2 = dateCalculator.daysUntilSixMonths(startDate: startDate2, testDate: testDate2)
        
        XCTAssertEqual(sut2, expectedResult2)
        
        
        // Test 3: Calcular los dias que no existen en el mes de pago
        let startDate3 = formatter.date(from: "31-10-2024")
        let testDate3 = formatter.date(from: "13-04-2025")
        let expectedResult3 = 17
        
        let sut3 = dateCalculator.daysUntilSixMonths(startDate: startDate3!, testDate: testDate3!)
        
        XCTAssertEqual(sut3, expectedResult3)
        
    }
    
}
