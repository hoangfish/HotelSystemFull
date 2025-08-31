#include "../inc/AdminController.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include "constant.h"
#include "Logger/inc/logger.h"

AdminController *AdminController::instance = nullptr;

AdminController::AdminController(QObject *parent) : QObject(parent) {
    m_adminModel = new AdminModel(this);
    m_httpClient = HttpClientImpl::getInstance();
}

void AdminController::loginAdmin(const QString &emailOrPhone, const QString &password) {
    QJsonObject json;
    json["emailOrPhone"] = emailOrPhone;
    json["password"] = password;

    m_httpClient->sendPostRequest(QUrl(URL_ADMIN_LOGIN), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();

        if (obj["success"].toBool()) {
            QJsonObject data = obj["data"].toObject();
            m_adminModel->setAdminId(data["adminId"].toString());
            m_adminModel->setFirstName(data["firstName"].toString());
            m_adminModel->setLastName(data["lastName"].toString());
            m_adminModel->setEmail(data["email"].toString());
            m_adminModel->setPhone(data["phone"].toString());
            LOG(LogLevel::INFO, "Admin login successful: " + (data["firstName"].toString() + " " + data["lastName"].toString()).toStdString());
            Q_EMIT loginSuccess(data["firstName"].toString() + " " + data["lastName"].toString());
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Admin login failed: " + errorMsg.toStdString());
            Q_EMIT loginFailed(errorMsg);
        }
    });
}

void AdminController::logoutAdmin() {
    m_httpClient->sendPostRequest(QUrl(URL_ADMIN_LOGOUT), QJsonObject(), [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();

        if (obj["success"].toBool()) {
            LOG(LogLevel::INFO, "Admin logout successful");
            Q_EMIT logoutSuccess();
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Admin logout failed: " + errorMsg.toStdString());
            Q_EMIT logoutFailed(errorMsg);
        }
    });
}

void AdminController::getAllUsers(const QString &booker, const QString &roomId, const QString &checkInDate) {
    QString url = URL_ADMIN_USERS;
    if (!booker.isEmpty() || !roomId.isEmpty() || !checkInDate.isEmpty()) {
        url += "?";
        if (!booker.isEmpty()) url += "booker=" + booker + "&";
        if (!roomId.isEmpty()) url += "roomId=" + roomId + "&";
        if (!checkInDate.isEmpty()) url += "checkInDate=" + checkInDate;
    }

    m_httpClient->sendGetRequest(QUrl(url), [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();

        if (obj["success"].toBool()) {
            QJsonArray usersArray = obj["data"].toArray();
            QVariantList usersList;
            for (const QJsonValue &userValue : usersArray) {
                QJsonObject userObj = userValue.toObject();
                QVariantMap userMap;
                userMap["userId"] = userObj["userId"].toString();
                userMap["firstName"] = userObj["firstName"].toString();
                userMap["lastName"] = userObj["lastName"].toString();
                userMap["email"] = userObj["email"].toString();
                userMap["phone"] = userObj["phone"].toString();

                QJsonArray roomList = userObj["RoomList"].toArray();
                QVariantList roomListVariant;
                for (const QJsonValue &roomValue : roomList) {
                    QJsonObject roomObj = roomValue.toObject();
                    QVariantMap roomMap;
                    roomMap["roomId"] = roomObj["roomId"].toString();
                    roomMap["roomNumber"] = roomObj["roomNumber"].toString();
                    roomMap["price"] = roomObj["price"].toDouble();
                    roomMap["bookingCode"] = roomObj["bookingCode"].toString();
                    roomMap["checkInDate"] = QDateTime::fromString(roomObj["checkInDate"].toString(), Qt::ISODate).toString("yyyy-MM-dd");
                    roomMap["isCheckIn"] = roomObj["isCheckIn"].toBool();
                    roomMap["isCheckOut"] = roomObj["isCheckOut"].toBool();
                    roomMap["checkOutDate"] = QDateTime::fromString(roomObj["checkOutDate"].toString(), Qt::ISODate).toString("yyyy-MM-dd");
                    roomMap["status"] = roomObj["status"].toString();
                    roomListVariant.append(roomMap);
                }
                userMap["RoomList"] = roomListVariant;
                usersList.append(userMap);
            }
            LOG(LogLevel::INFO, "Users fetched successfully");
            Q_EMIT usersFetched(usersList);
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Users fetch failed: " + errorMsg.toStdString());
            Q_EMIT usersFetchFailed(errorMsg);
        }
    });
}

void AdminController::cancelBooking(const QString &bookingCode, const QString &roomId, const QString &action) {
    QJsonObject json;
    json["bookingCode"] = bookingCode;
    json["roomId"] = roomId;
    json["action"] = action;

    m_httpClient->sendPostRequest(QUrl(URL_ADMIN_CANCEL), json, [=](QByteArray responseData) {
        QJsonDocument doc = QJsonDocument::fromJson(responseData);
        QJsonObject obj = doc.object();
        if (obj["success"].toBool()) {
            std::string tmp = action.toStdString();
            LOG(LogLevel::INFO, tmp + " successfully");
            Q_EMIT bookingCancelled(action, roomId);
        } else {
            QString errorMsg = obj["message"].toString();
            LOG(LogLevel::ERROR, "Cancel failed: " + errorMsg.toStdString());
            Q_EMIT cancelFailed(errorMsg);
        }
    });
}