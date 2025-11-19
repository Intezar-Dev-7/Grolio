/*app.js is responsible for defining the routes, middleware, and other application-level functionality. */


import express from "express";
const app = express();

app.get('/', (req, res) => {
    res.send('API is running....');
});

export default app;