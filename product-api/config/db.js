const mogoose = require('mongoose');
require('dotenv').config();

const connectDB = async () => {
    try{
        await mogoose.connect(process.env.MONGO_URI);
        console.log('MongoDB connected succesfully');
    }catch(error){
        console.error('MongoDB connection error:', error);
        process.exit(1);
    }
};

module.exports = connectDB;