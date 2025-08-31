#ifndef SOCKET_MGR_NOTI_H
#define SOCKET_MGR_NOTI_H

#include <functional>
#include <iostream>
#include <map>
#include <mutex> // Added for thread-safety

#include "sio_client.h"

class SocketMgr {
private:
    std::map<std::string, sio::socket::event_listener> mapSignalCb;
    static std::mutex                                  mtx;      // Mutex for thread-safety
    static SocketMgr *                                 instance; // Static instance of SocketMgr

    // Private constructor to prevent instantiation
    SocketMgr();

public:
    // Delete copy constructor and assignment operator
    SocketMgr(const SocketMgr &) = delete;
    SocketMgr &operator=(const SocketMgr &) = delete;

    static SocketMgr &getInstance() {
        std::unique_lock<std::mutex> lock(mtx); // Acquire lock
        if (instance == nullptr) {
            instance = new SocketMgr; // Create instance if not already created
        }
        return *instance;
    }

    void                        addSignalCb(std::string sig, sio::socket::event_listener cb);
    void                        removeSignalCb(std::string sig);
    sio::socket::event_listener getSignalCb(std::string sig);

    // Destructor
    ~SocketMgr();
};

#endif // SOCKET_MGR_NOTI_H