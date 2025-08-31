#include "../inc/RoomModel.h"

RoomModel::RoomModel(QObject *parent) : QObject(parent), m_bedCount(0), m_price(0.0), m_guests(0) {}

void RoomModel::setRoomId(const QString &roomId) {
    if (m_roomId != roomId) {
        m_roomId = roomId;
        Q_EMIT roomIdChanged();
    }
}

void RoomModel::setRoomNumber(const QString &roomNumber) {
    if (m_roomNumber != roomNumber) {
        m_roomNumber = roomNumber;
        Q_EMIT roomNumberChanged();
    }
}

void RoomModel::setStatus(const QString &status) {
    if (m_status != status) {
        m_status = status;
        Q_EMIT statusChanged();
    }
}

void RoomModel::setBedCount(int bedCount) {
    if (m_bedCount != bedCount) {
        m_bedCount = bedCount;
        Q_EMIT bedCountChanged();
    }
}

void RoomModel::setRoomType(const QString &roomType) {
    if (m_roomType != roomType) {
        m_roomType = roomType;
        Q_EMIT roomTypeChanged();
    }
}

void RoomModel::setPrice(double price) {
    if (m_price != price) {
        m_price = price;
        Q_EMIT priceChanged();
    }
}

void RoomModel::setDescription(const QString &description) {
    if (m_description != description) {
        m_description = description;
        Q_EMIT descriptionChanged();
    }
}

void RoomModel::setImage(const QString &image) {
    if (m_image != image) {
        m_image = image;
        Q_EMIT imageChanged();
    }
}

void RoomModel::setGuests(int guests) {
    if (m_guests != guests) {
        m_guests = guests;
        Q_EMIT guestsChanged();
    }
}

void RoomModel::setArea(const QString &area) {
    if (m_area != area) {
        m_area = area;
        Q_EMIT areaChanged();
    }
}