const express = require('express');
const router = express.Router();
const { registerAdmin, loginAdmin, logoutAdmin, getAllUsers, cancelBooking } = require('../controllers/AdminController');

router.route('/register').post(registerAdmin);
router.route('/login').post(loginAdmin);
router.route('/logout').post(logoutAdmin);
router.route('/users').get(getAllUsers);
router.route('/cancelBooking').post(cancelBooking);

module.exports = router;