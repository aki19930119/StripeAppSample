import * as functions from 'firebase-functions';

const stripe = require('stripe')(functions.config().stripe.token);

// MARK: - stripeのcustomerを作ってcustomerIdを返す
exports.createStripeCustomer = functions.https.onCall(async (data, context) => {
    const email = data.email;
    const customer = await stripe.customers.create({email: email});
    const customerId = customer.id;
    return { customerId: customerId }
});

// MARK: - Stripeのワンタイムトークンを発行する
exports.createStripeEphemeralKeys = functions.https.onCall((data, context) => {
    const customerId = data.customerId;
    const stripe_version = data.stripe_version;
    return stripe.ephemeralKeys
        .create({
            customer: customerId,
            stripe_version: stripe_version
        })
});

// MARK: - Stripeの決済する
exports.createStripeCharge = functions.https.onCall((data, context) => {
    const customer = data.customerId;
    const source = data.sourceId;
    const amount = data.amount;

    return stripe.charges.create({
        customer: customer,
        source: source,
        amount: amount,
        currency: "jpy",
    })
});