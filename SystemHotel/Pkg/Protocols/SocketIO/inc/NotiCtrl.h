#include "sio_client.h"
#include <QObject>
#include <QString>
#include <iostream>
#include <mutex>

class NotiCtrl : public QObject {
    Q_OBJECT
private:
    NotiCtrl(QObject *parent = nullptr);
    NotiCtrl(const NotiCtrl &) = delete;            // Delete copy constructor
    NotiCtrl &operator=(const NotiCtrl &) = delete; // Delete assignment operator

Q_SIGNALS:
    void notiChanged(QString content);

public:
    static NotiCtrl &getInstance() {
        static std::mutex            mtx;       // Mutex for thread-safety
        std::unique_lock<std::mutex> lock(mtx); // Acquire lock
        static NotiCtrl              instance;  // Static instance of NotiCtrl
        return instance;
    }

    void emitNoti(QString content) {
        std::cout << "emitNoti: " << content.toStdString() << std::endl;
        Q_EMIT notiChanged(content);
    }

    ~NotiCtrl();
};