#include "../inc/UserModel.h"

UserModel::UserModel(QObject *parent) : QObject(parent) {}

QString UserModel::firstName() const {
    return m_firstName;
}

void UserModel::setFirstName(const QString &firstName) {
    if (m_firstName != firstName) {
        m_firstName = firstName;
        Q_EMIT firstNameChanged();
    }
}

QString UserModel::lastName() const {
    return m_lastName;
}

void UserModel::setLastName(const QString &lastName) {
    if (m_lastName != lastName) {
        m_lastName = lastName;
        Q_EMIT lastNameChanged();
    }
}

QString UserModel::Id() const {
    return m_id;
}

void UserModel::setId(const QString &id) {
    if (m_id != id) {
        m_id = id;
        Q_EMIT idChanged();
    }
}

QString UserModel::email() const {
    return m_email;
}

void UserModel::setEmail(const QString &email) {
    if (m_email != email) {
        m_email = email;
        Q_EMIT emailChanged();
    }
}

QString UserModel::phone() const {
    return m_phone;
}

void UserModel::setPhone(const QString &phone) {
    if (m_phone != phone) {
        m_phone = phone;
        Q_EMIT phoneChanged();
    }
}