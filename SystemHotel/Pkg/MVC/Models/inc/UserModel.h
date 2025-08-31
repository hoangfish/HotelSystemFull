#ifndef USERMODEL_H
#define USERMODEL_H

#include <QObject>
#include <QString>

class UserModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString firstName READ firstName WRITE setFirstName NOTIFY firstNameChanged)
    Q_PROPERTY(QString lastName READ lastName WRITE setLastName NOTIFY lastNameChanged)
    Q_PROPERTY(QString Id READ Id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString phone READ phone WRITE setPhone NOTIFY phoneChanged)

public:
    explicit UserModel(QObject *parent = nullptr);

    QString firstName() const;
    void setFirstName(const QString &firstName);

    QString lastName() const;
    void setLastName(const QString &lastName);

    QString Id() const;
    void setId(const QString &id);

    QString email() const;
    void setEmail(const QString &email);

    QString phone() const;
    void setPhone(const QString &phone);

Q_SIGNALS:
    void firstNameChanged();
    void lastNameChanged();
    void idChanged();
    void emailChanged();
    void phoneChanged();

private:
    QString m_firstName;
    QString m_lastName;
    QString m_id;
    QString m_email;
    QString m_phone;
};

#endif // USERMODEL_H