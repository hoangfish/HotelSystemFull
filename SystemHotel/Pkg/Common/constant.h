#ifndef CONSTANTS_H
#define CONSTANTS_H

#define URL_SERVER_BACKEND "http://127.0.0.1:3000"
#define URL_SERVER_SOCKET "http://127.0.0.1:3001"

#define URL_USER_REGISTER \
    URL_SERVER_BACKEND    \
    "/api/v1/users/register"

#define URL_USER_LOGIN \
    URL_SERVER_BACKEND \
    "/api/v1/users/login"

#define URL_USER_LOGOUT \
    URL_SERVER_BACKEND \
    "/api/v1/users/logout"

#define URL_BOOKING_HISTORY \
    URL_SERVER_BACKEND      \
    "/api/v1/users/"

#define URL_ROOMS \
    URL_SERVER_BACKEND \
    "/api/v1/rooms"

#define URL_USERUPDATE \
    URL_SERVER_BACKEND \
    "/api/v1/users/update"

#define URL_ROOMSUPDATE \
    URL_SERVER_BACKEND \
    "/api/v1/rooms/update"

#define URL_USER_CANCEL \
    URL_SERVER_BACKEND \
    "/api/v1/users/cancel"

#define URL_ROOMSTYPE \
    URL_SERVER_BACKEND \
    "/api/v1/rooms/type"

#define URL_ADMIN_LOGIN \
    URL_SERVER_BACKEND \
    "/api/v1/admin/login"

#define URL_ADMIN_LOGOUT \
    URL_SERVER_BACKEND \
    "/api/v1/admin/logout"

#define URL_ADMIN_REGISTER \
    URL_SERVER_BACKEND \
    "/api/v1/admin/register"

#define URL_ADMIN_USERS \
    URL_SERVER_BACKEND \
    "/api/v1/admin/users"

#define URL_ADMIN_CANCEL \
    URL_SERVER_BACKEND \
    "/api/v1/admin/cancelBooking"

#define URL_ROOMS_BULK_CREATE \
    URL_SERVER_BACKEND \
    "/api/v1/rooms/bulk-create"

#endif // CONSTANTS_H