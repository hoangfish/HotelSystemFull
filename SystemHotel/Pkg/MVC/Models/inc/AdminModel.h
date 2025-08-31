#ifndef ADMINMODEL_H
#define ADMINMODEL_H

#include <QObject>
#include <QString>

class AdminModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString adminId READ adminId WRITE setAdminId NOTIFY adminIdChanged)
    Q_PROPERTY(QString firstName READ firstName WRITE setFirstName NOTIFY firstNameChanged)
    Q_PROPERTY(QString lastName READ lastName WRITE setLastName NOTIFY lastNameChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString phone READ phone WRITE setPhone NOTIFY phoneChanged)

public:
    explicit AdminModel(QObject *parent = nullptr);

    QString adminId() const;
    void setAdminId(const QString &adminId);

    QString firstName() const;
    void setFirstName(const QString &firstName);

    QString lastName() const;
    void setLastName(const QString &lastName);

    QString email() const;
    void setEmail(const QString &email);

    QString phone() const;
    void setPhone(const QString &phone);

Q_SIGNALS:
    void adminIdChanged();
    void firstNameChanged();
    void lastNameChanged();
    void emailChanged();
    void phoneChanged();

private:
    QString m_adminId;
    QString m_firstName;
    QString m_lastName;
    QString m_email;
    QString m_phone;
};

#endif // ADMINMODEL_H