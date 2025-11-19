import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    provider: {
        type: String,
        required: true

    },
    providerId: {
        type: String, required: true, index: true
    },
    email: {
        type: String, index: true, sparse: true
    },
    name: {
        type: String,
        required: true,
    },
    avatar: String,
    createdAt: { type: Date, default: Date.now }
});


const newUser = mongoose.model(
    "newUser",
    userSchema
);

export default newUser;

/*
mongoose.model() = creates a link between schema and MongoDB collection.
NewInventoryBooking = the class you use in code to interact with that collection.
export default = allows you to import and use it anywhere else in your app.
*/