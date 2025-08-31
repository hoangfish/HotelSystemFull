#include "../inc/AdminModel.h"

AdminModel::AdminModel(QObject *parent) : QObject(parent) {}

QString AdminModel::adminId() const {
    return m_adminId;
}

void AdminModel::setAdminId(const QString &adminId) {
    if (m_adminId != adminId) {
        m_adminId = adminId;
        Q_EMIT adminIdChanged();
    }
}

QString AdminModel::firstName() const {
    return m_firstName;
}

void AdminModel::setFirstName(const QString &firstName) {
    if (m_firstName != firstName) {
        m_firstName = firstName;
        Q_EMIT firstNameChanged();
    }
}

QString AdminModel::lastName() const {
    return m_lastName;
}

void AdminModel::setLastName(const QString &lastName) {
    if (m_lastName != lastName) {
        m_lastName = lastName;
        Q_EMIT lastNameChanged();
    }
}

QString AdminModel::email() const {
    return m_email;
}

void AdminModel::setEmail(const QString &email) {
    if (m_email != email) {
        m_email = email;
        Q_EMIT emailChanged();
    }
}

QString AdminModel::phone() const {
    return m_phone;
}

void AdminModel::setPhone(const QString &phone) {
    if (m_phone != phone) {
        m_phone = phone;
        Q_EMIT phoneChanged();
    }
}