#include "../inc/SckQmlIF.h"

SckQmlIF &SckQmlIF::getInstance() {
    static SckQmlIF instance; // Singleton instance
    return instance;
}

SckQmlIF::SckQmlIF(QObject *parent) : QObject(parent) {
    // Private constructor to prevent instantiation
    // Only accessible from within the class
}
