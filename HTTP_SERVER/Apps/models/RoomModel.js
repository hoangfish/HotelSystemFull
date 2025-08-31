const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const RoomSchema = new Schema({
    roomId: { type: String, required: true, unique: true, trim: true },
    roomNumber: { type: String, required: true, trim: true },
    status: { type: String, required: true, enum: ['available', 'booked'], default: 'available' },
    isCheckIn: { type: Boolean },
    isCheckOut: { type: Boolean },
    bedCount: { type: Number, required: true },
    roomType: { type: String, required: true },
    price: { type: Number, required: true },
    description: { type: String, required: true },
    image: { type: String, required: true },
    guests: { type: Number, required: true },
    area: { type: String, required: true }
});

const Room = mongoose.model('Room', RoomSchema);

module.exports = { Room };