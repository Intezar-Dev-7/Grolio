/*
app.js is responsible for defining the routes, middleware, and other application-level functionality. */



import express from "express";
import passport from "passport";
import dotenv from 'dotenv';
import setupPassport from './config/passport.js';
import connectDB from "./config/db.js";
import authRoutes from './routes/auth_routes.js';


dotenv.config();
const app = express();

// PARSE JSON REQUESTS 
app.use(express.json());

// CONNECT DATABASE
connectDB();

// PASSPORT STRATEGIES (Google + Github)
setupPassport();
app.use(passport.initialize());


// ROUTES
app.use('/auth', authRoutes);

// HEALTH CHECK 
app.get('/', (req, res) => {
    res.send('Grolio Auth Backend Is Running');
});


// ERROR HANDLER 
app.use((err, req, res, next) => {
    console.log(err);
    res.status(500).json({ error: 'Internal server error' });

})
export default app;