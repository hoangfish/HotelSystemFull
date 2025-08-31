import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
//import QUANLYKHACHSAN 1.0

ApplicationWindow {
    visible: true
    width: 1280
    height: 800
    title: "Quản lý khách sạn"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "qrc:/Pkg/MVC/Views/MainIntro.qml"

        onCurrentItemChanged: {
            if (stackView.currentItem && stackView.currentItem.objectName === "MainIntro") {
                let intro = stackView.currentItem
                intro.openLogin.connect(() => {
                    stackView.push("qrc:/Pkg/MVC/Views/Login.qml")
                })
            }

            if (stackView.currentItem && stackView.currentItem.objectName === "Login") {
                let login = stackView.currentItem
                login.loginSuccess.connect(() => {
                    stackView.replace("qrc:/Pkg/MVC/Views/Booking.qml", {stackViewRef: stackView})
                })
                login.adminLoginSuccess.connect(() => {
                    stackView.replace("qrc:/Pkg/MVC/Views/CustomerList.qml", {stackViewRef: stackView})
                })
            }

            if (stackView.currentItem && stackView.currentItem.objectName === "Booking") {
                let booking = stackView.currentItem
                // Kết nối với UserController để xử lý đăng xuất
                Connections
                {
                    target: UserController
                    function onLogoutSuccess() {
                        stackView.replace("qrc:/Pkg/MVC/Views/Login.qml")
                    }
                }
            }

            if (stackView.currentItem && stackView.currentItem.objectName === "Dashboard") {
                let dash = stackView.currentItem
                dash.navigateToBooking.connect(() => stackView.push("qrc:/Pkg/MVC/Views/Booking.qml"))
                dash.navigateToPayment.connect(() => stackView.push("qrc:/Pkg/MVC/Views/Payment.qml"))
                dash.navigateToReservation.connect(() => stackView.push("qrc:/Pkg/MVC/Views/BookingHistory.qml"))
                dash.navigateToCustomer.connect(() => stackView.push("qrc:/Pkg/MVC/Views/CustomerList.qml"))
                dash.logout.connect(() => stackView.pop())
            }
        }
    }

    Component.onCompleted: {
        UserController = Qt.createQmlObject('import QUANLYKHACHSAN 1.0; UserController {}', this);
        UserModel = Qt.createQmlObject('import QUANLYKHACHSAN 1.0; UserModel {}', this);
        AdminController = Qt.createQmlObject('import QUANLYKHACHSAN 1.0; AdminController {}', this);
        AdminModel = Qt.createQmlObject('import QUANLYKHACHSAN 1.0; AdminModel {}', this);
    }
}