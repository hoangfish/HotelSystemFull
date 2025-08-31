const mongoose = require('mongoose')

const DBconnection = async() => {
    const conn = await mongoose
        .connect("mongodb+srv://phphuc2417:V1uuaGFlxh8nCkhO@hotelsystem.7gqfhgv.mongodb.net/?retryWrites=true&w=majority&appName=HotelSystem", {
        })
        .catch(err => {
            console.log(`Can't connect to the DB`.red, err)
        })
    console.log(`MongoDB Connected: ${conn.connection.host}`.cyan.underline.bold)
}

module.exports = DBconnection