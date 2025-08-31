require('dotenv').config();
const express = require('express');
const http = require('http');
const cors = require('cors');
const compression = require('compression');
const helmet = require('helmet');

const DBConnection = require('./Apps/config/db');
DBConnection();

require('colors');

require('./Apps/models/UserModel');
require('./Apps/models/RoomModel');
require('./Apps/models/AdminModel');
const userRoutes = require('./Apps/routes/UserRoute');
const roomRoutes = require('./Apps/routes/RoomRoute');
const adminRoutes = require('./Apps/routes/AdminRoute');

const app = express();

app.use(compression());
app.use(helmet());
app.use(cors());
app.use(express.json());

const versionOne = (routeName) => `/api/v1/${routeName}`;

app.use(versionOne('users'), userRoutes);
app.use(versionOne('rooms'), roomRoutes);
app.use(versionOne('admin'), adminRoutes);

app.use((err, req, res, next) => {
    console.error('Server error:'.red, err);
    res.status(500).json({ success: false, message: 'Server error' });
});

const PORT = process.env.PORT || 3000;

const server = http.createServer(app);

server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`.cyan);
});