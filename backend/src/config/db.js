
/*Mongoose is an Object Data Modeling (ODM) library for Node.js that provides a schema-based solution for interacting 
with MongoDB databases  */


import mongoose from "mongoose";
import dotenv from 'dotenv';
dotenv.config();

const connectDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI, {
            dbName: 'grolio'
        });
        console.log('Database Connected');
    } catch (error) {
        console.log('Database Connection Failed');
        console.log(error);
    }
}


export default connectDB;