const asyncHandler = require('../middlewares/async');
const { AdminModel } = require('../models/AdminModel');
const { UserModel } = require('../models/UserModel');
const { Room } = require('../models/RoomModel');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');

const registerAdmin = asyncHandler(async (req, res) => {
    const { firstName, lastName, email, phone, password } = req.body;

    if (!firstName || !lastName || !email || !phone || !password) {
        return res.status(400).json({ success: false, message: 'Please fill in all fields' });
    }

    const existingAdmin = await AdminModel.findOne({ $or: [{ email }, { phone }] });
    if (existingAdmin) {
        return res.status(400).json({ success: false, message: 'Email or phone number already in use' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const admin = new AdminModel({
        firstName,
        lastName,
        adminId: uuidv4(),
        email,
        phone,
        password: hashedPassword,
        UserList: []
    });

    const savedAdmin = await admin.save();
    if (!savedAdmin) {
        return res.status(400).json({ success: false, message: 'Registration failed' });
    }

    res.status(201).json({ success: true, message: 'Admin registration successful', data: { adminId: savedAdmin.adminId } });
});

const loginAdmin = asyncHandler(async (req, res) => {
    const { emailOrPhone, password } = req.body;

    if (!emailOrPhone || !password) {
        return res.status(400).json({ success: false, message: 'Please provide email/phone and password' });
    }

    const admin = await AdminModel.findOne({
        $or: [
            { email: emailOrPhone },
            { phone: emailOrPhone }
        ]
    });

    if (!admin) {
        return res.status(400).json({ success: false, message: 'Email or phone not found' });
    }

    const isMatch = await bcrypt.compare(password, admin.password);
    if (!isMatch) {
        return res.status(400).json({ success: false, message: 'Incorrect password' });
    }

    res.status(200).json({
        success: true,
        message: 'Admin login successful',
        data: {
            adminId: admin.adminId,
            firstName: admin.firstName,
            lastName: admin.lastName,
            email: admin.email,
            phone: admin.phone
        }
    });
});

const logoutAdmin = asyncHandler(async (req, res) => {
    try {
        res.status(200).json({ success: true, message: 'Admin logout successful' });
    } catch (error) {
        console.error('Admin logout failed:', error.message);
        res.status(500).json({ success: false, message: 'Admin logout failed: ' + error.message });
    }
});

const getAllUsers = asyncHandler(async (req, res) => {
    const { booker, roomId, checkInDate } = req.query;

    const admin = await AdminModel.findOne();
    if (!admin) {
        return res.status(404).json({ success: false, message: 'Admin not found' });
    }

    // Đồng bộ UserList từ UserModel nếu rỗng
    if (admin.UserList.length === 0) {
        const users = await UserModel.find();
        admin.UserList = users.map(user => ({
            userId: user.userId,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            phone: user.phone,
            RoomList: user.RoomList
        }));
        await admin.save();
    }

    // Bắt đầu với tất cả users
    let filteredUsers = admin.UserList;

    // Áp dụng bộ lọc cho RoomList của từng user
    let hasRoomFilter = roomId || checkInDate;
    let finalUsers = filteredUsers.map(user => {
        let filteredRoomList = user.RoomList || [];

        // Lọc RoomList nếu có bộ lọc roomId hoặc checkInDate
        if (roomId) {
            filteredRoomList = filteredRoomList.filter(room => 
                room.roomId.toString().toLowerCase().includes(roomId.toLowerCase()));
        }

        if (checkInDate) {
            filteredRoomList = filteredRoomList.filter(room => 
                new Date(room.checkInDate).toISOString().split('T')[0] === checkInDate);
        }

        return {
            userId: user.userId,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            phone: user.phone,
            RoomList: filteredRoomList
        };
    });

    // Lọc users theo booker nếu có
    if (booker) {
        finalUsers = finalUsers.filter(user => 
            `${user.firstName} ${user.lastName}`.toLowerCase().includes(booker.toLowerCase()));
    }

    // Chỉ giữ users có RoomList không rỗng nếu có bộ lọc room
    if (hasRoomFilter) {
        finalUsers = finalUsers.filter(user => user.RoomList.length > 0);
    } else {
        // Nếu không có bộ lọc room, chỉ giữ users có RoomList không rỗng
        finalUsers = finalUsers.filter(user => user.RoomList.length > 0);
    }

    return res.status(200).json({ success: true, data: finalUsers });
});

const cancelBooking = asyncHandler(async (req, res) => {
    const { bookingCode, roomId, action } = req.body;

    if (!bookingCode || !roomId || !action) {
        return res.status(400).json({ success: false, message: 'Thiếu bookingCode, roomId hoặc action' });
    }

    const user = await UserModel.findOne({ 'RoomList.bookingCode': bookingCode });
    if (!user) {
        return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng với bookingCode này' });
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
        const nowDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const checkInDateOnly = new Date(checkInDate.getFullYear(), checkInDate.getMonth(), checkInDate.getDate());

        if (nowDate >= checkInDateOnly) {
            return res.status(400).json({ success: false, message: 'Không thể hủy đặt phòng vào hoặc sau ngày check-in' });
        }

        booking.status = 'cancelled';
        user.RoomList = user.RoomList.filter(booking => booking.bookingCode !== bookingCode);
        await user.save();

        room.status = 'available';
        await room.save();

        const admin = await AdminModel.findOne();
        if (admin) {
            const userIndex = admin.UserList.findIndex(u => u.userId === user.userId);
            if (userIndex >= 0) {
                admin.UserList[userIndex].RoomList = user.RoomList;
                await admin.save();
            }
        }

        return res.status(200).json({ success: true, message: `Hủy đặt phòng ${bookingCode} thành công`, action: 'cancel', roomId });
    } else if (action === 'checkIn') {
        const now = new Date();
        const checkInDate = new Date(booking.checkInDate);
        const nowDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const checkInDateOnly = new Date(checkInDate.getFullYear(), checkInDate.getMonth(), checkInDate.getDate());

        if (nowDate < checkInDateOnly) {
            return res.status(400).json({ success: false, message: 'Không thể check-in trước ngày check-in' });
        }

        booking.isCheckIn = true;
        await user.save();

        const admin = await AdminModel.findOne();
        if (admin) {
            const userIndex = admin.UserList.findIndex(u => u.userId === user.userId);
            if (userIndex >= 0) {
                admin.UserList[userIndex].RoomList = user.RoomList;
                await admin.save();
            }
        }

        return res.status(200).json({ success: true, message: `Đã check-in phòng ${bookingCode}`, action: 'checkIn', roomId });
    } else if (action === 'checkOut') {
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

        booking.isCheckOut = true;
        await user.save();

        room.status = 'available';
        await room.save();

        const admin = await AdminModel.findOne();
        if (admin) {
            const userIndex = admin.UserList.findIndex(u => u.userId === user.userId);
            if (userIndex >= 0) {
                admin.UserList[userIndex].RoomList = user.RoomList;
                await admin.save();
            }
        }

        return res.status(200).json({ success: true, message: `Đã check-out phòng ${bookingCode}`, action: 'checkOut', roomId });
    } else {
        return res.status(400).json({ success: false, message: 'Hành động không hợp lệ' });
    }
});

module.exports = { registerAdmin, loginAdmin, logoutAdmin, getAllUsers, cancelBooking };