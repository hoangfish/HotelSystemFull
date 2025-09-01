const asyncHandler = require('../middlewares/async');
const { Room } = require('../models/RoomModel');

const getRooms = asyncHandler(async (req, res) => {
    const rooms = await Room.find();
    res.status(200).json({
        success: true,
        data: rooms
    });
});

const getRoomsByType = asyncHandler(async (req, res) => {
  const { type } = req.body;

  const rooms = await Room.find({ roomType: type });

  if (!rooms || rooms.length === 0) {
    return res.status(404).json({
      success: false,
      message: `No rooms found for type: ${type}`,
    });
  }

  res.status(200).json({
    success: true,
    data: rooms,
  });
});

const getRoomById = asyncHandler(async (req, res) => {
    const room = await Room.findOne({ roomId: req.params.id });
    if (!room) {
        return res.status(404).json({
            success: false,
            message: 'Room not found'
        });
    }
    res.status(200).json({
        success: true,
        data: room
    });
});

const createRoom = asyncHandler(async (req, res) => {
    const { roomId, roomNumber,isCheckIn,isCheckOut, status, bedCount, roomType, price, description, image, guests, area } = req.body;

    // Kiểm tra các trường bắt buộc
    if (!roomId || !roomNumber || !bedCount || !roomType || !price || !description || !image || !guests || !area) {
        return res.status(400).json({
            success: false,
            message: 'Please provide all required fields: roomId, roomNumber, bedCount, roomType, price, description, image, guests, area'
        });
    }

    // Kiểm tra roomType hợp lệ
    const validRoomTypes = ['single', 'double', 'family'];
    if (!validRoomTypes.includes(roomType)) {
        return res.status(400).json({
            success: false,
            message: 'Invalid roomType. Must be one of: single, double, family'
        });
    }

    // Kiểm tra status hợp lệ
    const validStatuses = ['available', 'booked'];
    if (status && !validStatuses.includes(status)) {
        return res.status(400).json({
            success: false,
            message: 'Invalid status. Must be one of: available, booked'
        });
    }

    // Kiểm tra roomId và roomNumber đã tồn tại
    const existingRoom = await Room.findOne({ $or: [{ roomId }, { roomNumber }] });
    if (existingRoom) {
        return res.status(400).json({
            success: false,
            message: 'roomId or roomNumber already exists'
        });
    }

    const room = new Room({
        roomId,
        roomNumber,
        status: status || 'available',
        bedCount,
        roomType,
        price,
        description,
        image,
        guests,
        area
    });

    await room.save();

    res.status(201).json({
        success: true,
        message: 'Room created successfully',
        data: room
    });
});

const deleteRoom = asyncHandler(async (req, res) => {
    const room = await Room.findOne({ roomId: req.params.id });
    if (!room) {
        return res.status(404).json({
            success: false,
            message: 'Room not found'
        });
    }

    await room.deleteOne();

    res.status(200).json({
        success: true,
        message: 'Room deleted successfully',
        data: { roomId: req.params.id }
    });
});

const bookRoom = asyncHandler(async (req, res) => {
    const { roomId, userId } = req.body;

    if (!roomId || !userId) {
        return res.status(400).json({
            success: false,
            message: 'Please provide roomId and userId'
        });
    }

    const room = await Room.findOne({ roomId });
    if (!room) {
        return res.status(404).json({
            success: false,
            message: 'Room not found'
        });
    }

    if (room.status === 'booked') {
        return res.status(400).json({
            success: false,
            message: 'Room is already booked'
        });
    }

    room.status = 'booked';
    await room.save();

    res.status(200).json({
        success: true,
        message: 'Room booked successfully',
        data: {
            roomId,
            roomNumber: room.roomNumber
        }
    });
});
const addCheckFlagsToRooms = asyncHandler(async (req, res) => {
  try {
    const result = await Room.updateMany(
      {},
      {
        $set: { isCheckIn: false, isCheckOut: false }
      }
    );

    res.status(200).json({
      success: true,
      message: "All rooms updated with isCheckIn and isCheckOut = false",
      modifiedCount: result.modifiedCount
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error updating rooms",
      error: error.message
    });
  }
});
const updateRoomStatus = asyncHandler(async (req, res) => {
    const { status } = req.body;
    if (!status || !['available', 'booked'].includes(status)) {
        return res.status(400).json({
            success: false,
            message: 'Invalid status. Must be one of: available, booked'
        });
    }

    const room = await Room.findOneAndUpdate(
        { roomId: req.params.id },
        { status },
        { new: true, runValidators: true }
    );

    if (!room) {
        return res.status(404).json({
            success: false,
            message: 'Room not found'
        });
    }

    res.status(200).json({
        success: true,
        data: room
    });
});

const createMultipleRooms = asyncHandler(async (req, res) => {
    const roomsData = req.body.rooms;

    // Kiểm tra xem req.body có phải là mảng không
    if (!Array.isArray(roomsData) || roomsData.length === 0) {
        return res.status(400).json({
            success: false,
            message: 'Please provide an array of rooms'
        });
    }

    const validRoomTypes = ['single', 'double', 'family'];
    const validStatuses = ['available', 'booked'];
    const createdRooms = [];
    const errors = [];

    // Kiểm tra dữ liệu từng phòng
    for (let i = 0; i < roomsData.length; i++) {
        const {
            roomId,
            roomNumber,
            status,
            isCheckIn,
            isCheckOut,
            bedCount,
            roomType,
            price,
            description,
            image,
            guests,
            area
        } = roomsData[i];

        // Kiểm tra các trường bắt buộc
        if (!roomId || !roomNumber || !bedCount || !roomType || !price || !description || !image || !guests || !area) {
            errors.push(`Room at index ${i} is missing required fields`);
            continue;
        }

        // Kiểm tra roomType hợp lệ
        if (!validRoomTypes.includes(roomType)) {
            errors.push(`Room at index ${i} has invalid roomType. Must be one of: single, double, family`);
            continue;
        }

        // Kiểm tra status hợp lệ
        if (status && !validStatuses.includes(status)) {
            errors.push(`Room at index ${i} has invalid status. Must be one of: available, booked`);
            continue;
        }

        // Kiểm tra roomId và roomNumber đã tồn tại
        const existingRoom = await Room.findOne({ $or: [{ roomId }, { roomNumber }] });
        if (existingRoom) {
            errors.push(`Room at index ${i} has roomId or roomNumber already exists`);
            continue;
        }

        // Tạo phòng mới
        const room = new Room({
            roomId,
            roomNumber,
            status: status || 'available',
            isCheckIn: isCheckIn|| 'false',
            isCheckOut: isCheckOut|| 'false',
            bedCount,
            roomType,
            price,
            description,
            image,
            guests,
            area
        });

        try {
            await room.save();
            createdRooms.push(room);
        } catch (error) {
            errors.push(`Room at index ${i} failed to save: ${error.message}`);
        }
    }

    // Trả về kết quả
    if (errors.length > 0) {
        return res.status(207).json({
            success: true,
            message: 'Some rooms were created, but there were errors',
            data: createdRooms,
            errors
        });
    }

    res.status(201).json({
        success: true,
        message: 'All rooms created successfully',
        data: createdRooms
    });
});

module.exports = { getRooms,getRoomsByType, getRoomById, createRoom, deleteRoom, bookRoom, updateRoomStatus, createMultipleRooms, addCheckFlagsToRooms };