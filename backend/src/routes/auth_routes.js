import passport from "passport";
import { failure, oauthCallback } from "../controllers/auth_controller";

const router = express.Router();

//Start Google Auth 
router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

// Google callback 
router.get('/google/callback', passport.authenticate('google', { failureRedirect: '/auth/failure' }), oauthCallback);


// Start Github OAuth 
router.get('/github', passport.authenticate('github', { scope: ['user:email'] }));

// Github callback 
router.get('/github/callback', passport.authenticate('github', { failureRedirect: '/auth/failure' }), oauthCallback);


// Failure route 
router.get('/failure', failure);

export default router;
