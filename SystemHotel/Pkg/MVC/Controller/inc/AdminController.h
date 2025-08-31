#ifndef ADMINCONTROLLER_H
#define ADMINCONTROLLER_H

#include <QObject>
#include <QVariantList>
#include "Http/inc/httpclientimpl.h"
#include "../../Models/inc/AdminModel.h"
#include "SocketIO/inc/socketioclient.h"

class AdminController : public QObject {
    Q_OBJECT
    static AdminController *instance;

public:
    static AdminController *getInstance() {
        if (instance == nullptr)
            instance = new AdminController();
        return instance;
    }

    explicit AdminController(QObject *parent = nullptr);
    AdminModel* getAdminModel() const { return m_adminModel; }

    Q_INVOKABLE void loginAdmin(const QString &emailOrPhone, const QString &password);
    Q_INVOKABLE void logoutAdmin();
    Q_INVOKABLE void getAllUsers(const QString &booker = "", const QString &roomId = "", const QString &checkInDate = "");
    Q_INVOKABLE QString getFullName() const { 
        return m_adminModel->firstName() + " " + m_adminModel->lastName(); 
    }
    Q_INVOKABLE QString getEmail() const { return m_adminModel->email(); }
    Q_INVOKABLE QString getPhone() const { return m_adminModel->phone(); }
    Q_INVOKABLE void cancelBooking(const QString &bookingCode, const QString &roomId, const QString &action);

Q_SIGNALS:
    void loginSuccess(const QString &fullName);
    void loginFailed(const QString &errorMsg);
    void logoutSuccess();
    void logoutFailed(const QString &errorMsg);
    void usersFetched(const QVariantList &users);
    void usersFetchFailed(const QString &errorMsg);
    void bookingCancelled(const QString& action, const QString &roomId);
    void cancelFailed(const QString &errorMsg);

private:
    AdminModel *m_adminModel;
    HttpClientImpl *m_httpClient;
};

#endif // ADMINCONTROLLER_H