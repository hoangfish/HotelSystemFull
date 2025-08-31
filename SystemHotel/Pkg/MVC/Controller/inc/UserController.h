#ifndef USERCONTROLLER_H
#define USERCONTROLLER_H

#include <QObject>
#include <QVariantList>
#include "Http/inc/httpclientimpl.h"
#include "../../Models/inc/UserModel.h"
#include "SocketIO/inc/socketioclient.h"

class UserController : public QObject {
    Q_OBJECT
    static UserController *instance;
public:
    static UserController *getInstance() {
        if (instance == nullptr)
            instance = new UserController();
        return instance;
    }
    explicit UserController(QObject *parent = nullptr);
    UserModel* getUserModel() const { return m_userModel; }
    QString getUserId();
    Q_INVOKABLE QString getFirstName();
    Q_INVOKABLE QString getLastName();
    Q_INVOKABLE QString getEmail();
    Q_INVOKABLE QString getPhone();

    Q_INVOKABLE void registerUser(const QString &firstName, const QString &lastName,
                                  const QString &email, const QString &phone,
                                  const QString &password);
    Q_INVOKABLE void loginUser(const QString &emailOrPhone, const QString &password);
    Q_INVOKABLE void logoutUser();
    Q_INVOKABLE void getBookingHistory();
    Q_INVOKABLE void cancelBooking(const QString &bookingCode,const QString&roomId,const QString &action);

Q_SIGNALS:
    void registerSuccess();
    void registerFailed(const QString &errorMsg);
    void loginSuccess(const QString &firstName, const QString &lastName);
    void loginFailed(const QString &errorMsg);
    void logoutSuccess();
    void logoutFailed(const QString &errorMsg);
    void bookingHistorySuccess(const QVariantList &bookings);
    void bookingHistoryFailed(const QString &errorMsg);
    void bookingCancelled(const QString& action, const QString &roomId);
    void cancelFailed(const QString &errorMsg);

private:
    HttpClientImpl *m_httpClient;
    UserModel *m_userModel;
};

#endif // USERCONTROLLER_H