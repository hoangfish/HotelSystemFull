#pragma once

#include <QObject>
#include <QVariantList>
#include "../../Models/inc/RoomModel.h"
#include "Http/inc/httpclientimpl.h"
#include "SocketIO/inc/socketioclient.h"

class RoomController : public QObject {
    Q_OBJECT
    static RoomController *instance;

public:
    static RoomController *getInstance() {
        if (instance == nullptr)
            instance = new RoomController();
        return instance;
    }
    explicit RoomController(QObject *parent = nullptr);

    QString downloadImage(const QString& urlString);
    void setRoomStatus(const QString& roomId, const QString& newStatus);

    Q_INVOKABLE void getRooms();
    Q_INVOKABLE void selectRoom(const QString &roomId);
    Q_INVOKABLE void bookRoom(const QString &roomId, const QString &checkInDate, const QString &checkOutDate);
    Q_INVOKABLE void createRoom(const QJsonObject &roomData);

    QVariantList getRoomList() const { return m_roomList; }
    void setRoomList(const QVariantList &roomList) {
        m_roomList = roomList;
        Q_EMIT roomsFetched(roomList);  // Emit roomsFetched để trigger QML update như bản cũ
        Q_EMIT roomListChanged();  // Giữ nguyên emit này nếu cần cho chức năng khác ở bản mới
    }

Q_SIGNALS:
    void roomsFetched(const QVariantList &rooms);
    void roomFetchFailed(const QString &errorMsg);
    void roomSelected(const QVariantMap &room);
    void roomBooked();
    void roomBookingFailed(const QString &errorMsg);
    void roomCreated();
    void roomCreateFailed(const QString &errorMsg);
    void roomListChanged();

private:
    HttpClientImpl *m_httpClient;
    RoomModel *m_selectedRoom;
    QVariantList m_roomList;
    bool isSubscribeSocket;
};

class RoomAdapter {
public:
    static QVariantMap fromJson(const QJsonObject& obj) {
        return QVariantMap{
            {"roomId", obj["roomId"].toString()},
            {"roomNumber", obj["roomNumber"].toString()},
            {"status", obj["status"].toString()},
            {"bedCount", obj["bedCount"].toInt()},
            {"roomType", obj["roomType"].toString()},
            {"price", obj["price"].toDouble()},
            {"description", obj["description"].toString()},
            {"image", obj["image"].toString()},
            {"guests", obj["guests"].toInt()},
            {"area", obj["area"].toString()}
        };
    }
};