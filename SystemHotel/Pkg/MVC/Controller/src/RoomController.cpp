#include "../inc/RoomController.h"
#include "../inc/UserController.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>
#include <QDir>
#include "matrix.h"
#include "constant.h"
#include "Logger/inc/logger.h"
#include <QUuid>

QString generateBookingCode() {
    return QUuid::createUuid().toString(QUuid::WithoutBraces).mid(0, 8).toUpper();
}
RoomController* RoomController::instance = nullptr;

RoomController::RoomController(QObject *parent) : QObject(parent), isSubscribeSocket(false) {
    m_httpClient = HttpClientImpl::getInstance();
    m_selectedRoom = new RoomModel(this);
}

QString RoomController::downloadImage(const QString& urlString) {
    QUrl url(urlString);
    QString fileName = url.fileName();
    QString localDir = "C:/Users/Admin/Downloads/quanlykhachsan/Temp";
    QString fullPath = localDir + fileName;

    QDir dir;
    if (!dir.exists(localDir)) {
        dir.mkpath(localDir);
    }

    QNetworkRequest request(url);
    QNetworkAccessManager* manager = new QNetworkAccessManager();

    QEventLoop loop;
    QNetworkReply* reply = manager->get(request);
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();

    if (reply->error() == QNetworkReply::NoError) {
        QFile file(fullPath);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(reply->readAll());
            file.close();
            reply->deleteLater();
            return "file:///" + fullPath.replace("\\", "/");
        }
    }

    reply->deleteLater();
    return "";
}

void RoomController::setRoomStatus(const QString& roomId, const QString& newStatus) {
    QVariantList arr = this->getRoomList();
    for (int i = 0; i < arr.size(); i++) {
        QVariantMap obj = arr[i].toMap();
        if (obj["roomId"].toString() == roomId) {
            obj["status"] = newStatus;
            arr[i] = obj;
            break;
        }
    }
    this->setRoomList(arr);
}

void RoomController::getRooms() {
    m_httpClient->sendGetRequest(QUrl(URL_ROOMS), [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            QJsonArray roomsArray = obj["data"].toArray();
            QVariantList rooms;
            for (const QJsonValue &value : roomsArray) {
                QJsonObject roomObj = value.toObject();
                QString imageUrl = roomObj["image"].toString();
                QString localImagePath = downloadImage(imageUrl);
                rooms.append(RoomAdapter::fromJson(roomObj));
            }
            this->setRoomList(rooms);
            LOG(LogLevel::INFO, "Rooms fetched successfully");
            Q_EMIT roomsFetched(rooms);
            if (!isSubscribeSocket) {
                SocketIoClient::getInstance().listenForEvent(
                    SIG_NOTI_UPDATESTATUS, [&](sio::event &event) {  // Sửa match emit, format string như bản cũ
                        std::string roomId = event.get_message()->get_string();
                        LOG(LogLevel::INFO, "Received event: " + event.get_name() +
                                ", roomId: " + roomId);
                        QString tmpId = QString::fromStdString(roomId);
                        setRoomStatus(tmpId, "booked");  // Luôn "booked" như bản cũ
                    });
                isSubscribeSocket = true;
            }
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Rooms fetch failed: " + errorMsg.toStdString());
            Q_EMIT roomFetchFailed(errorMsg);
        }
    });
}

void RoomController::selectRoom(const QString &roomId) {
    m_httpClient->sendGetRequest(QUrl(URL_ROOMS), [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            QJsonArray roomsArray = obj["data"].toArray();
            for (const QJsonValue &value : roomsArray) {
                QJsonObject roomObj = value.toObject();
                if (roomObj["roomId"].toString() == roomId) {
                    QString imageUrl = roomObj["image"].toString();
                    QString localImagePath = downloadImage(imageUrl);
                    QVariantMap room = {
                        {"roomId", roomObj["roomId"].toString()},
                        {"roomNumber", roomObj["roomNumber"].toString()},
                        {"status", roomObj["status"].toString()},
                        {"bedCount", roomObj["bedCount"].toInt()},
                        {"roomType", roomObj["roomType"].toString()},
                        {"price", roomObj["price"].toDouble()},
                        {"description", roomObj["description"].toString()},
                        {"image", localImagePath},
                        {"guests", roomObj["guests"].toInt()},
                        {"area", roomObj["area"].toString()}
                    };
                    m_selectedRoom->setRoomId(room["roomId"].toString());
                    m_selectedRoom->setRoomNumber(room["roomNumber"].toString());
                    m_selectedRoom->setStatus(room["status"].toString());
                    m_selectedRoom->setBedCount(room["bedCount"].toInt());
                    m_selectedRoom->setRoomType(room["roomType"].toString());
                    m_selectedRoom->setPrice(room["price"].toDouble());
                    m_selectedRoom->setDescription(room["description"].toString());
                    m_selectedRoom->setImage(room["image"].toString());
                    m_selectedRoom->setGuests(room["guests"].toInt());
                    m_selectedRoom->setArea(room["area"].toString());
                    LOG(LogLevel::INFO, "Room selected: " + roomId.toStdString());
                    Q_EMIT roomSelected(room);
                    return;
                }
            }
            QString errorMsg = "Room not found";
            LOG(LogLevel::ERROR, "Room selection failed: " + errorMsg.toStdString());
            Q_EMIT roomFetchFailed(errorMsg);
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Room selection failed: " + errorMsg.toStdString());
            Q_EMIT roomFetchFailed(errorMsg);
        }
    });
}

void RoomController::bookRoom(const QString &roomId, const QString &checkInDate, const QString &checkOutDate) {
    QString userId = UserController::getInstance()->getUserId();
    QJsonObject json;
    json["bookingCode"] = generateBookingCode();
    json["roomId"] = roomId;
    json["userId"] = userId;
    json["checkInDate"] = checkInDate;
    json["checkOutDate"] = checkOutDate;

    m_httpClient->sendPostRequest(QUrl(URL_USERUPDATE), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            QJsonObject updateJson;
            updateJson["status"] = "booked";
            m_httpClient->sendPostRequest(QUrl(QString(URL_ROOMSUPDATE) + "/" + roomId), updateJson, [=](QByteArray updateResponse) {
                QJsonDocument updateDoc = QJsonDocument::fromJson(updateResponse);
                QJsonObject updateObj = updateDoc.object();
                if (updateObj["success"].toBool()) {
                    LOG(LogLevel::INFO, "Room booked and status updated successfully: " + roomId.toStdString());
                    Q_EMIT roomBooked();
                    sio::message::list msgSended;
                    msgSended.push(sio::string_message::create(roomId.toStdString()));  // Emit string như bản cũ
                    SocketIoClient::getInstance().emitEvent(SIG_NOTI_UPDATESTATUS, msgSended);
                } else {
                    QString errorMsg = updateObj["message"].toString();
                    LOG(LogLevel::ERROR, "Room status update failed: " + errorMsg.toStdString());
                    Q_EMIT roomBookingFailed(errorMsg);
                }
            });
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Room booking failed: " + errorMsg.toStdString());
            Q_EMIT roomBookingFailed(errorMsg);
        }
    });
}

void RoomController::createRoom(const QJsonObject &roomData) {
    QJsonArray roomsArray;
    roomsArray.append(roomData);
    QJsonObject json;
    json["rooms"] = roomsArray;  // Gửi dưới dạng array để sử dụng bulk-create

    m_httpClient->sendPostRequest(QUrl(URL_ROOMS_BULK_CREATE), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            LOG(LogLevel::INFO, "Room created successfully");
            Q_EMIT roomCreated();
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Room creation failed: " + errorMsg.toStdString());
            Q_EMIT roomCreateFailed(errorMsg);
        }
    });
}