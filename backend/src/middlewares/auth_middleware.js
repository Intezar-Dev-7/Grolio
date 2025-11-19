import jwt from 'jsonwebtoken';


export const requireAuth = (req, res, next) => {
    const auth = req.header.authorization;
    if (!auth) return res.status(401).json({ error: 'No token' });
    const [scheme, token] = auth.split(' ');
    if (!token || scheme !== 'Bearer') return res.status(401).json({ error: ' Malformed authorization header' });

    try {
        const payload = jwt.verify(token, process.env.JWT_SECRET_KEY);
        req.user = payload;
        next();


    } catch (error) {
        return res.status(401).json({ error: 'Invalid or expired token' });

    }
}

/*Typical Authorization header Authorization: Bearer <token>.

Verifies JWT and attaches payload to req.user for downstream handlers.  */