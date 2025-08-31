#include "../inc/socketioclient.h"

std::unique_ptr<SocketIoClient> SocketIoClient::instance = nullptr;
std::mutex                      SocketIoClient::mutex;

SocketIoClient &SocketIoClient::getInstance() {
    std::lock_guard<std::mutex> lock(mutex);
    if (!instance) {
        instance = std::unique_ptr<SocketIoClient>(new SocketIoClient());
    }
    return *instance;
}

SocketIoClient::SocketIoClient() {
    // Initialize member variables as needed
}

// SocketIoClient::~SocketIoClient()
// {
//     // Clean up member variables as needed
// }

bool SocketIoClient::connectToServer(const std::string &                 url,
                                     std::map<std::string, std::string> &query) {
    bool ret = true;
    try {
        instance->pClient.connect(url, query);
    } catch (const std::exception &e) {
        ret = false;
        // auto what = e.what();
    }
    return ret;
}

bool SocketIoClient::connectToServer(const std::string &url) {
    bool ret = true;
    try {
        instance->pClient.connect(url);
    } catch (const std::exception &e) {
        ret = false;
        // auto what = e.what();
    }
    return ret;
}

bool SocketIoClient::listenForEvent(const std::string &                eventName,
                                    const sio::socket::event_listener &callback) {
    bool ret = true;
    try {
        instance->pClient.socket()->on(eventName, callback);
    } catch (const std::exception &e) {
        ret = false;
    }
    return ret;
}

bool SocketIoClient::listenForEvent(const std::string &                    eventName,
                                    const sio::socket::event_listener_aux &callback) {
    bool ret = true;
    try {
        instance->pClient.socket()->on(eventName, callback);
    } catch (const std::exception &e) {
        ret = false;
    }
    return ret;
}

bool SocketIoClient::emitEvent(std::string const &name, sio::message::list const &msglist) {
    bool ret = true;
    try {
        instance->pClient.socket()->emit(name, msglist);
    } catch (const std::exception &e) {
        ret = false;
    }
    return ret;
}

bool SocketIoClient::removeEvent(const std::string &eventName) {
    bool ret = true;
    try {
        instance->pClient.socket()->off(eventName);
    } catch (const std::exception &e) {
        ret = false;
    }
    return ret;
}

void SocketIoClient::poll() {
    // instance->pClient.socket()
}

void SocketIoClient::dSyncClose() {
    instance->pClient.sync_close();
}