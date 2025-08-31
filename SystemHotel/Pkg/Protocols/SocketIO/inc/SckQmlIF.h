#ifndef SCKQMLIF_H
#define SCKQMLIF_H

#include <QObject>

class SckQmlIF : public QObject {
    Q_OBJECT
public:
    static SckQmlIF &getInstance();

private:
    SckQmlIF(QObject *parent = nullptr);
    SckQmlIF(const SckQmlIF &) = delete;            // Delete copy constructor
    SckQmlIF &operator=(const SckQmlIF &) = delete; // Delete copy assignment operator
};

#endif // SCKQMLIF_H
