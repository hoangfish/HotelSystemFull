const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const { v4: uuidv4 } = require('uuid');

const RoomSchema = new Schema({
    roomId: { type: String, required: true, trim: true },
    roomNumber: { type: String, trim: true },
    price: { type: Number },
    bookingCode: { type: String },
    checkInDate: { type: Date, required: true },
    isCheckIn: { type: Boolean },
    isCheckOut: { type: Boolean },
    checkOutDate: { type: Date, required: true },
    status: { type: String, default: 'booked', enum: ['booked', 'cancelled'] }
}, { _id: true });

const UserSchema = new Schema({
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    userId: { type: String, unique: true, default: uuidv4 },
    email: { type: String, required: true, unique: true, lowercase: true, match: [/^\S+@\S+\.\S+$/, 'Invalid email format'] },
    phone: { type: String, required: true, unique: true, match: [/^\d{10,11}$/, 'Phone number must be 10-11 digits'] },
    createdAt: { type: Date, default: Date.now },
    RoomList: { type: [RoomSchema], default: [] }
});

const adminSchema = new Schema({
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    adminId: { type: String, unique: true, default: uuidv4 },
    email: { type: String, required: true, unique: true, lowercase: true, match: [/^\S+@\S+\.\S+$/, 'Invalid email format'] },
    phone: { type: String, required: true, unique: true, match: [/^\d{10,11}$/, 'Phone number must be 10-11 digits'] },
    password: { type: String, required: true, minlength: [6, 'Password must be at least 6 characters'] },
    createdAt: { type: Date, default: Date.now },
    UserList: { type: [UserSchema], default: [] }
});

const AdminModel = mongoose.model('AdminModel', adminSchema);

module.exports = { AdminModel };