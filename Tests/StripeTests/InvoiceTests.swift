//
//  InvoiceTests.swift
//  Stripe
//
//  Created by Anthony Castelli on 9/5/17.
//
//

import XCTest
@testable import Stripe
@testable import Vapor

class InvoiceTests: XCTestCase {
    let invoiceString = """
{
    "amount_due": 0,
    "attempt_count": 0,
    "attempted": false,
    "billing": "charge_automatically",
    "closed": false,
    "currency": "usd",
    "customer": "cus_CCiTI4Tpghl0nK",
    "date": 1234567890,
    "due_date": 1234567890,
    "forgiven": false,
    "id": "in_1BoJ2NKrZ43eBVAbQ8jb0Xfj",
    "lines": {
        "data": [
            {
                "amount": 1000,
                "currency": "usd",
                "description": "My First Invoice Item (created for API docs)",
                "discountable": true,
                "id": "ii_1BoJ2NKrZ43eBVAby2HbDsY5",
                "livemode": false,
                "metadata": {},
                "object": "line_item",
                "period": {
                    "end": 1516918659,
                    "start": 1516918659
                },
                "proration": false,
                "type": "invoiceitem"
            }
        ],
        "has_more": false,
        "object": "list",
        "url": "/v1/invoices/in_1BoJ2NKrZ43eBVAbQ8jb0Xfj/lines"
    },
    "livemode": false,
    "metadata": {},
    "next_payment_attempt": 1234567890,
    "number": "fe61cc956c-0001",
    "object": "invoice",
    "paid": false,
    "period_end": 1234567890,
    "period_start": 1234567890,
    "starting_balance": 0,
    "subtotal": 0,
    "total": 0,
    "webhooks_delivered_at": 1234567890
}
"""
    
    func testInvoiceParsedProperly() throws {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let body = HTTPBody(string: invoiceString)
            let futureInvoice = try decoder.decode(StripeInvoice.self, from: body, maxSize: 65_536, on: EmbeddedEventLoop())
            
            futureInvoice.do { (invoice) in
                XCTAssertEqual(invoice.id, "in_1BoJ2NKrZ43eBVAbQ8jb0Xfj")
                XCTAssertEqual(invoice.amountDue, 0)
                XCTAssertEqual(invoice.attemptCount, 0)
                XCTAssertEqual(invoice.attempted, false)
                XCTAssertEqual(invoice.billing, "charge_automatically")
                XCTAssertEqual(invoice.closed, false)
                XCTAssertEqual(invoice.currency, .usd)
                XCTAssertEqual(invoice.customer, "cus_CCiTI4Tpghl0nK")
                XCTAssertEqual(invoice.date, Date(timeIntervalSince1970: 1234567890))
                XCTAssertEqual(invoice.dueDate, Date(timeIntervalSince1970: 1234567890))
                XCTAssertEqual(invoice.forgiven, false)
                XCTAssertEqual(invoice.livemode, false)
                XCTAssertEqual(invoice.nextPaymentAttempt, Date(timeIntervalSince1970: 1234567890))
                XCTAssertEqual(invoice.number, "fe61cc956c-0001")
                XCTAssertEqual(invoice.object, "invoice")
                XCTAssertEqual(invoice.paid, false)
                XCTAssertEqual(invoice.periodEnd, Date(timeIntervalSince1970: 1234567890))
                XCTAssertEqual(invoice.periodStart, Date(timeIntervalSince1970: 1234567890))
                XCTAssertEqual(invoice.startingBalance, 0)
                XCTAssertEqual(invoice.subtotal, 0)
                XCTAssertEqual(invoice.total, 0)
                XCTAssertEqual(invoice.webhooksDeliveredAt, Date(timeIntervalSince1970: 1234567890))
                
                // Test for invoice lineItem
                XCTAssertEqual(invoice.lines?.hasMore, false)
                XCTAssertEqual(invoice.lines?.object, "list")
                XCTAssertEqual(invoice.lines?.url, "/v1/invoices/in_1BoJ2NKrZ43eBVAbQ8jb0Xfj/lines")
                XCTAssertEqual(invoice.lines?.data?[0].amount, 1000)
                XCTAssertEqual(invoice.lines?.data?[0].currency, .usd)
                XCTAssertEqual(invoice.lines?.data?[0].description, "My First Invoice Item (created for API docs)")
                XCTAssertEqual(invoice.lines?.data?[0].discountable, true)
                XCTAssertEqual(invoice.lines?.data?[0].id, "ii_1BoJ2NKrZ43eBVAby2HbDsY5")
                XCTAssertEqual(invoice.lines?.data?[0].livemode, false)
                XCTAssertEqual(invoice.lines?.data?[0].object, "line_item")
                XCTAssertEqual(invoice.lines?.data?[0].proration, false)
                XCTAssertEqual(invoice.lines?.data?[0].type, "invoiceitem")
                XCTAssertEqual(invoice.lines?.data?[0].period?.start, Date(timeIntervalSince1970: 1516918659))
                XCTAssertEqual(invoice.lines?.data?[0].period?.end, Date(timeIntervalSince1970: 1516918659))
                
                }.catch { (error) in
                    XCTFail("\(error.localizedDescription)")
            }
        }
        catch {
            XCTFail("\(error.localizedDescription)")
        }
    }
    
    let invoiceItemString = """
{
  "id": "ii_1BtydB2eZvKYlo2CzeKs27EC",
  "object": "invoiceitem",
  "amount": 2500,
  "currency": "usd",
  "customer": "cus_CIaBoYfVixDHWf",
  "date": 1518270185,
  "description": "One-time setup fee",
  "discountable": true,
  "invoice": "in_1BtydF2eZvKYlo2COZpiUqSi",
  "livemode": false,
  "metadata": {
  },
  "period": {
    "start": 1518270185,
    "end": 1518270185
  },
  "plan": null,
  "proration": false,
  "quantity": null,
  "subscription": null
}
"""
    
    func testInvoiceItemParsedProperly() throws {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let body = HTTPBody(string: invoiceItemString)
            let futureInvoiceItem = try decoder.decode(StripeInvoiceItem.self, from: body, maxSize: 65_536, on: EmbeddedEventLoop())
            
            futureInvoiceItem.do { (invoiceItem) in
                XCTAssertEqual(invoiceItem.id, "ii_1BtydB2eZvKYlo2CzeKs27EC")
                XCTAssertEqual(invoiceItem.object, "invoiceitem")
                XCTAssertEqual(invoiceItem.amount, 2500)
                XCTAssertEqual(invoiceItem.currency, .usd)
                XCTAssertEqual(invoiceItem.customer, "cus_CIaBoYfVixDHWf")
                XCTAssertEqual(invoiceItem.date, Date(timeIntervalSince1970: 1518270185))
                XCTAssertEqual(invoiceItem.description, "One-time setup fee")
                XCTAssertEqual(invoiceItem.discountable, true)
                XCTAssertEqual(invoiceItem.invoice, "in_1BtydF2eZvKYlo2COZpiUqSi")
                XCTAssertEqual(invoiceItem.livemode, false)
                XCTAssertEqual(invoiceItem.proration, false)
                XCTAssertEqual(invoiceItem.quantity, nil)
                XCTAssertEqual(invoiceItem.subscription, nil)
                
                }.catch { (error) in
                    XCTFail("\(error.localizedDescription)")
            }
        }
        catch {
            XCTFail("\(error.localizedDescription)")
        }
    }
}
