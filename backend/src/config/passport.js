/*Passport is authentication middleware for Node.js. 
Extremely flexible and modular, Passport can be unobtrusively dropped in to any 
Express-based web application. 
A comprehensive set of strategies support authentication using a username and password, Facebook, Twitter, and more.*/

import passport from "passport";
import { Strategy as GithubStrategy } from "passport-github2";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";
import generateToken from "../utils/generateTokens.js";
import AuthService from "../services/auth_service.js";

export default function setupPassport() {
    // passport serialize/deserialize (not used for JWT flow but required)
    passport.serializeUser((user, done) => (null, user));
    passport.deserializeUser((obj, done) => (null, obj));

    // -------- Google Strategy ---------

    passport.use(
        new GoogleStrategy({
            clientID: process.env.GOOGLE_CLIENT_ID,
            clientSecret: process.GOOGLE_CLIENT_SECRET,
            callbackURL: process.env.Backend_BASE_URL + '/auth/google/callback'
        },
            async (accessToken, refreshToken, Profiler, done) => {
                try {
                    const email = Profiler.emails?.[0]?.value || null;
                    const payload = {
                        provider: 'google',
                        providerId: profile.id,
                        email,
                        name: profile.displayName,
                        avatar: profile.photos?.[0]?.value || null
                    };
                    const user = await AuthService.findOrCreate(payload);
                    const token = generateToken({ id: user._id, provider: 'google' });
                    // Pass token and user to route via req.user
                    return done(null, { token, user });

                } catch (err) {
                    return done(err);
                }
            }
        )
    );


    // ------ Github Strategy -------

    passport.use(
        new GithubStrategy(
            {
                clientID: process.env.GITHUB_CLIENT_ID,
                clientSecret: process.env.GITHUB_CLIENT_SECRET,
                callbackURL: process.env.BACKEND_BASE_URL + '/auth/github/callback',
            },
            async (accessToken, refreshToken, profile, done) => {
                try {
                    const email = profile.emails?.[0]?.value || value;
                    const paylaod = {
                        provider: 'github',
                        providerId: profile.id,
                        email,
                        name: profile.displayName || profile.userName,
                        avatar: profile._json?.avatar_url || null
                    };
                    const user = await AuthService.findOrCreate(payload);
                    const token = generateToken({ id: user._id, provider: 'github' });
                    return done(null, { token, user });

                } catch (error) {
                    return done(err);
                }
            }
        )
    )
}