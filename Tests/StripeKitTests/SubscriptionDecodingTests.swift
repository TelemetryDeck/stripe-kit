//
//  SubscriptionDecodingTests.swift
//
//

import XCTest
@testable import StripeKit

final class SubscriptionDecodingTests: XCTestCase {
    // Same configuration as the decoder in StripeRequest.
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    /// Stripe sends `percent_off` and `amount_percent` as decimals; fractional values
    /// (e.g. a 50.5% coupon) must not fail decoding of subscription webhook payloads.
    func testDecodesSubscriptionWithFractionalPercentOff() throws {
        let payload = """
        {
            "id": "sub_1MowQVLkdIwHu7ixeRlqHVzs",
            "object": "subscription",
            "automatic_tax": {
                "enabled": false
            },
            "created": 1679609767,
            "currency": "usd",
            "current_period_end": 1682288167,
            "current_period_start": 1679609767,
            "customer": "cus_Na6dX7aXxi11N4",
            "cancel_at_period_end": false,
            "discount": {
                "id": "di_1MowQVLkdIwHu7ix3EmkQzGr",
                "object": "discount",
                "coupon": {
                    "id": "fractional-coupon",
                    "object": "coupon",
                    "created": 1679609767,
                    "duration": "forever",
                    "livemode": false,
                    "percent_off": 50.5,
                    "times_redeemed": 1,
                    "valid": true
                },
                "customer": "cus_Na6dX7aXxi11N4",
                "start": 1679609767,
                "subscription": "sub_1MowQVLkdIwHu7ixeRlqHVzs"
            },
            "livemode": false,
            "status": "active",
            "transfer_data": {
                "amount_percent": 12.5,
                "destination": "acct_1MowQVLkdIwHu7ix"
            }
        }
        """

        let subscription = try decoder.decode(Subscription.self, from: Data(payload.utf8))

        XCTAssertEqual(subscription.discount?.coupon?.percentOff, Decimal(string: "50.5"))
        XCTAssertEqual(subscription.transferData?.amountPercent, Decimal(string: "12.5"))
    }

    func testDecodesCouponWithIntegralPercentOff() throws {
        let payload = """
        {
            "id": "whole-coupon",
            "object": "coupon",
            "created": 1679609767,
            "duration": "once",
            "percent_off": 100.0
        }
        """

        let coupon = try decoder.decode(Coupon.self, from: Data(payload.utf8))

        XCTAssertEqual(coupon.percentOff, 100)
    }
}
