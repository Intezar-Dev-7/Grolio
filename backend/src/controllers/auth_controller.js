export const oauthCallback = (req, res) => {
    // Passport sets req.user to {token, user}
    const token = req.user?.token;
    if (!token) return res.status(500).send('No token generated');

    // Redirect to the mobile deep link (or web frontend) with token 
    const deep = process.env.APP_DEEP_LINK || 'grolio://auth';
    // NOTE: encode token or sensitive data if needed ; we we append as query param for demo
    return res.redirect(`${deep}?token=${token}`);

};

export const failure = (req, res) => res.status(401).send('Authentication Failed');