#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QQmlContext>
#include <QtQuickControls2/QQuickStyle>
#include "Common/constant.h"
#include "Logger/inc/logger.h"
#include "MVC/Controller/inc/UserController.h"
#include "MVC/Controller/inc/RoomController.h"
#include "MVC/Controller/inc/AdminController.h"
#include "SocketIO/inc/NotiCtrl.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Material");

    LOG(LogLevel::INFO, "Start app");

    engine.rootContext()->setContextProperty("UserController", UserController::getInstance());
    engine.rootContext()->setContextProperty("RoomController", RoomController::getInstance());
    engine.rootContext()->setContextProperty("AdminController", AdminController::getInstance());

    engine.load(QUrl(QStringLiteral("qrc:/Pkg/MVC/Views/main.qml")));

    return app.exec();
}