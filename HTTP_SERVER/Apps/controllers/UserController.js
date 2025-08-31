const asyncHandler = require('../middlewares/async');
const { UserModel } = require('../models/UserModel');
const { Room } = require('../models/RoomModel');
const { AdminModel } = require('../models/AdminModel');
const bcrypt = require('bcryptjs');

const registerUser = asyncHandler(async (req, res) => {
    const { firstName, lastName, email, phone, password } = req.body;

    if (!firstName || !lastName || !email || !phone || !password) {
        return res.status(400).json({ success: false, message: 'Please fill in all fields' });
    }

    const existingUser = await UserModel.findOne({ $or: [{ email }, { phone }] });
    if (existingUser) {
        return res.status(400).json({ success: false, message: 'Email or phone number already in use' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = new UserModel({
        firstName,
        lastName,
        email,
        phone,
        password: hashedPassword
    });

    const savedUser = await user.save();
    if (!savedUser) {
        return res.status(400).json({ success: false, message: 'Registration failed' });
    }

    // Thêm user vào UserList của admin
    const admin = await AdminModel.findOne();
    if (admin) {
        admin.UserList.push({
            userId: savedUser.userId,
            firstName: savedUser.firstName,
            lastName: savedUser.lastName,
            email: savedUser.email,
            phone: savedUser.phone,
            RoomList: savedUser.RoomList
        });
        await admin.save();
    }

    res.status(201).json({ success: true, message: 'Registration successful', data: { userId: savedUser.userId } });
});

const loginUser = asyncHandler(async (req, res) => {
    const { emailOrPhone, password } = req.body;

    if (!emailOrPhone || !password) {
        return res.status(400).json({ success: false, message: 'Please provide email/phone and password' });
    }

    const user = await UserModel.findOne({
        $or: [{ email: emailOrPhone }, { phone: emailOrPhone }]
    });

    if (!user) {
        return res.status(400).json({ success: false, message: 'Email or phone number not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        return res.status(400).json({ success: false, message: 'Incorrect password' });
    }

    // Cập nhật UserList của admin khi user đăng nhập
    const admin = await AdminModel.findOne();
    if (admin) {
        const userIndex = admin.UserList.findIndex(u => u.userId === user.userId);
        if (userIndex >= 0) {
            admin.UserList[userIndex] = {
                userId: user.userId,
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                phone: user.phone,
                RoomList: user.RoomList
            };
        } else {
            admin.UserList.push({
                userId: user.userId,
                firstName: user.firstName,
                lastName: user.lastName,
                email: user.email,
                phone: user.phone,
                RoomList: user.RoomList
            });
        }
        await admin.save();
    }

    res.status(200).json({
        success: true,
        message: 'Login successful',
        data: {
            firstName: user.firstName,
            lastName: user.lastName,
            userId: user.userId,
            email: user.email,
            phone: user.phone
        }
    });
});

const logoutUser = asyncHandler(async (req, res) => {
    try {
        res.status(200).json({ success: true, message: 'Logout successful' });
    } catch (error) {
        console.error('Logout failed:', error.message);
        res.status(500).json({ success: false, message: 'Logout failed: ' + error.message });
    }
});

const updateListRoomForUser = asyncHandler(async (req, res) => {
    try {
        const { bookingCode, roomId, userId, checkInDate, checkOutDate } = req.body;

        if (!userId || !roomId || !checkInDate || !checkOutDate) {
            return res.status(400).json({ success: false, message: 'Missing required fields' });
        }

        const room = await Room.findOne({ roomId });
        if (!room) {
            return res.status(404).json({ success: false, message: 'Room not found' });
        }

        const newRoom = {
            bookingCode: bookingCode,
            roomId: roomId,
            roomNumber: room.roomNumber,
            price: room.price,
            isCheckIn: false,
            isCheckOut: false,
            checkInDate: new Date(checkInDate),
            checkOutDate: new Date(checkOutDate),
            status: 'booked'
        };

        const updatedUser = await UserModel.findOneAndUpdate(
            { userId: userId },
            { $push: { RoomList: newRoom } },
            { new: true, runValidators: true }
        );

        if (!updatedUser) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        // Cập nhật RoomList trong UserList của admin
        const admin = await AdminModel.findOne();
        if (admin) {
            const userIndex = admin.UserList.findIndex(u => u.userId === updatedUser.userId);
            if (userIndex >= 0) {
                admin.UserList[userIndex].RoomList = updatedUser.RoomList;
                await admin.save();
            }
        }

        res.status(200).json({ success: true, data: updatedUser.RoomList });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

const getUserBookings = asyncHandler(async (req, res) => {
    const user = await UserModel.findOne({ userId: req.params.id });
    if (!user) {
        return res.status(404).json({ success: false, message: 'User not found' });
    }
    res.status(200).json({ success: true, data: user.RoomList });
});

const cancelBooking = asyncHandler(async (req, res) => {
    const { userId, roomId, bookingCode, action } = req.body;

    if (!userId || !bookingCode || !action) {
        return res.status(400).json({ success: false, message: 'Thiếu userId, roomId hoặc action' });
    }

    const user = await UserModel.findOne({ userId });
    if (!user) {
        return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng' });
    }

    const booking = user.RoomList.find(booking => booking.bookingCode === bookingCode);
    if (!booking) {
        return res.status(404).json({ success: false, message: 'Không tìm thấy đặt phòng' });
    }

    const room = await Room.findOne({ roomId });
    if (!room) {
        return res.status(404).json({ success: false, message: 'Không tìm thấy phòng' });
    }

    if (action === 'cancel') {
        const now = new Date();
        const checkInDate = new Date(booking.checkInDate);

        // Lấy ngày (0h00)
        const nowDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const checkInDateOnly = new Date(checkInDate.getFullYear(), checkInDate.getMonth(), checkInDate.getDate());

        if (nowDate >= checkInDateOnly) {
            return res.status(400).json({ success: false, message: 'Không thể hủy đặt phòng vào hoặc sau ngày check-in' });
        }

        // Update status to cancelled and remove booking from RoomList
        booking.status = 'cancelled';
        user.RoomList = user.RoomList.filter(booking => booking.bookingCode !== bookingCode);
        await user.save();

        // Update room status to available
        room.status = 'available';
        await room.save();

        // Cập nhật RoomList trong UserList của admin
        const admin = await AdminModel.findOne();
        if (admin) {
            const userIndex = admin.UserList.findIndex(u => u.userId === user.userId);
            if (userIndex >= 0) {
                admin.UserList[userIndex].RoomList = user.RoomList;
                await admin.save();
            }
        }

        return res.status(200).json({ success: true, message: `Hủy đặt phòng ${bookingCode} thành công!` });
    } else if (action === 'checkIn') {
        // Check if check-in is allowed (on or after check-in date)
        const now = new Date();
        const checkInDate = new Date(booking.checkInDate);
        const nowDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const checkInDateOnly = new Date(checkInDate.getFullYear(), checkInDate.getMonth(), checkInDate.getDate());

        if (nowDate < checkInDateOnly) {
            return res.status(400).json({ success: false, message: 'Không thể check-in trước ngày check-in' });
        }

        // Update booking in RoomList
        booking.isCheckIn = true;
        await user.save();

        // Cập nhật RoomList trong UserList của admin
        const admin = await AdminModel.findOne();
        if (admin) {
            const userIndex = admin.UserList.findIndex(u => u.userId === user.userId);
            if (userIndex >= 0) {
                admin.UserList[userIndex].RoomList = user.RoomList;
                await admin.save();
            }
        }

        return res.status(200).json({ success: true, message: `Đã check-in phòng ${bookingCode}!` });
    } else if (action === 'checkOut') {
        // Check if check-out is allowed (after check-in and before or on check-out date)
        const now = new Date();
        const checkOutDate = new Date(booking.checkOutDate);
        const nowDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const checkOutDateOnly = new Date(checkOutDate.getFullYear(), checkOutDate.getMonth(), checkOutDate.getDate());

        if (!booking.isCheckIn) {
            return res.status(400).json({ success: false, message: 'Không thể check-out trước khi check-in' });
        }
        if (nowDate > checkOutDateOnly) {
            return res.status(400).json({ success: false, message: 'Không thể check-out sau ngày check-out' });
        }

        // Update booking in RoomList
        booking.isCheckOut = true;
        await user.save();

        // Update room status to available
        room.status = 'available';
        await room.save();

        // Cập nhật RoomList trong UserList của admin
        const admin = await AdminModel.findOne();
        if (admin) {
            const userIndex = admin.UserList.findIndex(u => u.userId === user.userId);
            if (userIndex >= 0) {
                admin.UserList[userIndex].RoomList = user.RoomList;
                await admin.save();
            }
        }

        return res.status(200).json({ success: true, message: `Đã check-out phòng ${bookingCode}!` });
    } else {
        return res.status(400).json({ success: false, message: 'Hành động không hợp lệ' });
    }
});

module.exports = { registerUser, loginUser, logoutUser, updateListRoomForUser, getUserBookings, cancelBooking };