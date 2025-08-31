#ifndef SOCKET_CLI_IMPL_H
#define SOCKET_CLI_IMPL_H

#include "sio_client.h"
#include <QObject>
#include <functional>
#include <memory>
#include <mutex>
#include <string>

class SocketIoClient {
public:
    static SocketIoClient &getInstance();

    virtual bool listenForEvent(const std::string &                eventName,
                                const sio::socket::event_listener &callback);
    virtual bool listenForEvent(const std::string &                    eventName,
                                const sio::socket::event_listener_aux &callback);
    virtual bool removeEvent(const std::string &eventName);
    virtual bool emitEvent(std::string const &name, sio::message::list const &msglist = nullptr);
    virtual bool connectToServer(const std::string &url, std::map<std::string, std::string> &query);
    virtual bool connectToServer(const std::string &url);
    virtual void poll();
    virtual void dSyncClose();

    SocketIoClient(const SocketIoClient &) = delete;
    SocketIoClient &operator=(const SocketIoClient &) = delete;

private:
    SocketIoClient();
    // ~SocketIoClient();
    static std::unique_ptr<SocketIoClient> instance;
    sio::client                            pClient;
    static std::mutex                      mutex;
};

#endif // SOCKET_CLI_IMPL_H
