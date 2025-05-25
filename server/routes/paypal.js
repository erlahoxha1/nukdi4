const express = require('express');
const router = express.Router();
const paypal = require('@paypal/checkout-server-sdk');

const CLIENT_ID = 'YOUR_SANDBOX_CLIENT_ID';
const CLIENT_SECRET = 'YOUR_SANDBOX_SECRET';

const environment = new paypal.core.SandboxEnvironment(CLIENT_ID, CLIENT_SECRET);
const client = new paypal.core.PayPalHttpClient(environment);

// Create order
router.post('/api/create-paypal-order', async (req, res) => {
    const request = new paypal.orders.OrdersCreateRequest();
    request.prefer('return=representation');
    request.requestBody({
        intent: 'CAPTURE',
        purchase_units: [{
            amount: {
                currency_code: 'USD',
                value: '10.00'  // You can replace this with dynamic amount
            }
        }],
        application_context: {
            return_url: 'https://example.com/success',  // Replace later
            cancel_url: 'https://example.com/cancel'
        }
    });

    try {
        const order = await client.execute(request);
        const approvalUrl = order.result.links.find(link => link.rel === 'approve').href;
        res.json({ orderID: order.result.id, approvalUrl });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Capture order
router.post('/api/capture-paypal-order', async (req, res) => {
    const { orderID } = req.body;
    const request = new paypal.orders.OrdersCaptureRequest(orderID);
    request.requestBody({});

    try {
        const capture = await client.execute(request);
        res.json(capture.result);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;