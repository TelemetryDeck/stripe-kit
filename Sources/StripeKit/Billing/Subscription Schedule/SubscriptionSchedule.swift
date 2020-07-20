//
//  SubscriptionSchedule.swift
//  
//
//  Created by Andrew Edwards on 1/2/20.
//

import Foundation

/// The [Schedule Object](https://stripe.com/docs/api/subscription_schedules/object)
public struct StripeSubscriptionSchedule: StripeModel {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object’s type. Objects of the same type share the same value.
    public var object: String
    /// Time at which the subscription schedule was canceled. Measured in seconds since the Unix epoch.
    public var canceledAt: Date?
    /// Time at which the subscription schedule was completed. Measured in seconds since the Unix epoch.
    public var completedAt: Date?
    /// Time at which the object was created. Measured in seconds since the Unix epoch.
    public var created: Date
    /// Object representing the start and end dates for the current phase of the subscription schedule, if it is active.
    public var currentPhase: StripeSubscriptionScheduleCurrentPhase?
    /// ID of the customer who owns the subscription schedule.
    @Expandable<StripeCustomer> public var customer: String?
    /// Object representing the subscription schedule’s default settings.
    public var defaultSettings: StripeSubscriptionScheduleDefaultSettings?
    /// Behavior of the subscription schedule and underlying subscription when it ends.
    public var endBehavior: StripeSubscriptionScheduleEndBehavior?
    /// Has the value true if the object exists in live mode or the value false if the object exists in test mode.
    public var livemode: Bool?
    /// Set of key-value pairs that you can attach to an object. This can be useful for storing additional information about the object in a structured format.
    public var metadata: [String: String]?
    /// Configuration for the subscription schedule’s phases.
    public var phases: [StripeSubscriptionSchedulePhase]?
    /// Time at which the subscription schedule was released. Measured in seconds since the Unix epoch.
    public var releasedAt: Date?
    /// ID of the subscription once managed by the subscription schedule (if it is released).
    public var releasedSubscription: String?
    /// The present status of the subscription schedule. Possible values are not_started, active, completed, released, and canceled. You can read more about the different states in our behavior guide.
    public var status: StripeSubscriptionScheduleStatus?
    /// ID of the subscription managed by the subscription schedule.
    @Expandable<StripeSubscription> public var subscription: String?
}

public struct StripeSubscriptionScheduleCurrentPhase: StripeModel {
    /// The end of this phase of the subscription schedule.
    public var endDate: Date?
    /// The start of this phase of the subscription schedule.
    public var startDate: Date?
}

public struct StripeSubscriptionScheduleDefaultSettings: StripeModel {
    /// Possible values are `phase_start` or `automatic`. If `phase_start` then billing cycle anchor of the subscription is set to the start of the phase when entering the phase. If `automatic` then the billing cycle anchor is automatically modified as needed when entering the phase. For more information, see the billing cycle documentation.
    public var billingCycleAnchor: StripeSubscriptionScheduleBillingCycleAnchor?
    /// Define thresholds at which an invoice will be sent, and the subscription advanced to a new billing period
    public var billingThresholds: StripeSubscriptionBillingThresholds?
    /// Either `charge_automatically`, or `send_invoice`. When charging automatically, Stripe will attempt to pay the underlying subscription at the end of each billing cycle using the default source attached to the customer. When sending an invoice, Stripe will email your customer an invoice with payment instructions.
    public var collectionMethod: StripeInvoiceCollectionMethod?
    /// ID of the default payment method for the subscription schedule. If not set, invoices will use the default payment method in the customer’s invoice settings.
    @Expandable<StripePaymentMethod> public var defaultPaymentMethod: String?
    /// The subscription schedule’s default invoice settings.
    public var invoiceSettings: StripeSubscriptionScheduleInvoiceSettings?
    /// The account (if any) the subscription’s payments will be attributed to for tax reporting, and where funds from each payment will be transferred to for each of the subscription’s invoices.
    public var transferData: StripeSubscriptionTransferData?
}

public enum StripeSubscriptionScheduleEndBehavior: String, StripeModel {
    case release
    case cancel
}

public struct StripeSubscriptionScheduleInvoiceSettings: StripeModel {
    /// Number of days within which a customer must pay invoices generated by this subscription schedule. This value will be `null` for subscription schedules where `billing=charge_automatically`.
    public var daysUntilDue: Int?
}

public struct StripeSubscriptionSchedulePhase: StripeModel {
    /// A list of prices and quantities that will generate invoice items appended to the first invoice for this phase.
    public var addInvoiceItems: [StripeSubscriptionSchedulePhaseAddInvoiceItem]?
    /// A non-negative decimal between 0 and 100, with at most two decimal places. This represents the percentage of the subscription invoice subtotal that will be transferred to the application owner’s Stripe account during this phase of the schedule.
    public var applicationFeePercent: Decimal?
    /// Possible values are `phase_start` or `automatic`. If phase_start then billing cycle anchor of the subscription is set to the start of the phase when entering the phase. If automatic then the billing cycle anchor is automatically modified as needed when entering the phase. For more information, see the billing cycle documentation.
    public var billingCycleAnchor: StripeSubscriptionScheduleBillingCycleAnchor?
    /// Define thresholds at which an invoice will be sent, and the subscription advanced to a new billing period
    public var billingThresholds: StripeSubscriptionBillingThresholds?
    /// Either `charge_automatically`, or `send_invoice`. When charging automatically, Stripe will attempt to pay the underlying subscription at the end of each billing cycle using the default source attached to the customer. When sending an invoice, Stripe will email your customer an invoice with payment instructions.
    public var collectionMethod: StripeInvoiceCollectionMethod?
    /// ID of the coupon to use during this phase of the subscription schedule.
    @Expandable<StripeCoupon> public var coupon: String?
    /// ID of the default payment method for the subscription schedule. It must belong to the customer associated with the subscription schedule. If not set, invoices will use the default payment method in the customer’s invoice settings.
    @Expandable<StripePaymentMethod> public var defaultPaymentMethod: String?
    /// The default tax rates to apply to the subscription during this phase of the subscription schedule.
    public var defaultTaxRates: [StripeTaxRate]?
    /// The end of this phase of the subscription schedule.
    public var endDate: Date?
    /// The subscription schedule’s default invoice settings.
    public var invoiceSettings: StripeSubscriptionScheduleInvoiceSettings?
    /// Plans to subscribe during this phase of the subscription schedule.
    public var plans: [StripePlan]?
    /// Controls whether or not the subscription schedule will prorate when transitioning to this phase. Values are `create_prorations` and `none`.
    public var prorationBehavior: StripeSubscriptionSchedulePhaseProrationBehavior?
    /// The start of this phase of the subscription schedule.
    public var startDate: Date?
    /// The account (if any) the subscription’s payments will be attributed to for tax reporting, and where funds from each payment will be transferred to for each of the subscription’s invoices.
    public var transferData: StripeSubscriptionTransferData?
    /// When the trial ends within the phase.
    public var trialEnd: Date?
}

public struct StripeSubscriptionSchedulePhaseAddInvoiceItem: StripeModel {
    // TODO: - Price
    /// ID of the price used to generate the invoice item.
    public var price: String?
    /// The quantity of the invoice item.
    public var quantity: Int?
}

public enum StripeSubscriptionScheduleBillingCycleAnchor: String, StripeModel {
    case phaseStart = "phase_start"
    case automatic
}


public enum StripeSubscriptionScheduleStatus: String, StripeModel {
    case notStarted = "not_started"
    case active
    case completed
    case released
    case canceled
}

public enum StripeSubscriptionSchedulePhaseProrationBehavior: String, StripeModel {
    case createProrations = "create_prorations"
    case none
}

public struct StripeSubscriptionScheduleList: StripeModel {
    public var object: String
    public var hasMore: Bool?
    public var url: String?
    public var data: [StripeSubscriptionSchedule]?
}
