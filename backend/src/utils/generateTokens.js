/*Signs payload into JWT using secret and expiry.

Throws if secret missing (safety).*/


import jwt from "jsonwebtoken";


export default function generateToken(payload = {}) {
    const secret = process.env.JWT_SECRET;
    if (!secret) throw new Error("JWT_Secret not found");
    const ExpireToken = {
        expiresIn: '1h',
    }
    return jwt.sign(payload, secret, ({ ExpireToken }))
}

