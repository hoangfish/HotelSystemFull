import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Page {
    id: paymentPage
    objectName: "Payment"

    property StackView stackViewRef
    property var selectedRoom
    property string checkInDate
    property string checkOutDate
    property int nights
    property double totalPrice

    signal paymentSuccess()

    // ========== HEADER ==========
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "#d32f2f"
        z: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16
            Text {
                text: "Muong Thanh Luxury HCM"
                color: "white"
                font.pixelSize: 20
                font.bold: true
            }
            Item { Layout.fillWidth: true }
            Rectangle {
                id: avatar
                width: 40
                height: 40
                radius: 20
                color: "#ffebee"
                border.color: "#880e4f"
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: UserController.getFirstName() && UserController.getLastName() ? 
                          UserController.getFirstName()[0].toUpperCase() + UserController.getLastName()[0].toUpperCase() : "NA"
                    color: "#880e4f"
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: profileDialog.open()
                }
            }
        }
    }

    // ========== TITLE ==========
    Rectangle {
        id: titleBar
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "transparent"
        z: 1

        Text {
            anchors.centerIn: parent
            text: "Thanh toán"
            font.pixelSize: 28
            font.bold: true
            color: "#333"
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 6
            color: "#f5ecec"
        }
        Rectangle {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            height: 4
            width: parent.width * 0.35
            anchors.margins: 0
            color: "#b45b5b"
        }
    }

    // ========== Booking Summary ==========
    Rectangle {
        id: bookingSummary
        width: 320
        height: 320
        radius: 8
        color: "#fafafa"
        border.color: "#ddd"
        border.width: 1
        z: 3

        anchors.top: titleBar.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 24

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                height: 48
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "Đơn đặt phòng của tôi"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#333"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 48
                color: "#fff3f3"
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Text {
                        text: "Phòng:"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#333"
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Text {
                        text: selectedRoom ? selectedRoom.roomId : "Chưa chọn phòng"
                        font.pixelSize: 15
                        font.bold: true
                        color: "#7f2f2f"
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 36
                color: "#fff3f3"
                Text {
                    anchors.centerIn: parent
                    text: selectedRoom ? (selectedRoom.roomType ? selectedRoom.roomType.charAt(0).toUpperCase() + selectedRoom.roomType.slice(1) : "Chưa chọn loại phòng") : "Chưa chọn loại phòng"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#333"
                }
            }

            ColumnLayout {
                visible: nights > 0
                spacing: 2
                RowLayout {
                    spacing: 8
                    Text { text: Qt.formatDate(Date.fromLocaleString(Qt.locale(), checkInDate, "yyyy-MM-dd"), "dd"); font.pixelSize: 20; font.bold: true; color: "#333" }
                    Text { text: "tháng " + Qt.formatDate(Date.fromLocaleString(Qt.locale(), checkInDate, "yyyy-MM-dd"), "MM"); font.pixelSize: 14; color: "#333" }
                    Text { text: "—"; font.pixelSize: 20; color: "#333" }
                    Text { text: Qt.formatDate(Date.fromLocaleString(Qt.locale(), checkOutDate, "yyyy-MM-dd"), "dd"); font.pixelSize: 20; font.bold: true; color: "#333" }
                    Text { text: "tháng " + Qt.formatDate(Date.fromLocaleString(Qt.locale(), checkOutDate, "yyyy-MM-dd"), "MM"); font.pixelSize: 14; color: "#333" }
                }
                RowLayout {
                    spacing: 12
                    ColumnLayout {
                        spacing: 2
                        Text { text: Qt.formatDate(Date.fromLocaleString(Qt.locale(), checkInDate, "yyyy-MM-dd"), "dddd"); font.pixelSize: 12; color: "#555" }
                        Text { text: "từ lúc 14:00"; font.pixelSize: 12; color: "#555" }
                    }
                    ColumnLayout {
                        spacing: 2
                        Text { text: Qt.formatDate(Date.fromLocaleString(Qt.locale(), checkOutDate, "yyyy-MM-dd"), "dddd"); font.pixelSize: 12; color: "#555" }
                        Text { text: "đến 12:30"; font.pixelSize: 12; color: "#555" }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 36
                color: "#fff3f3"
                visible: nights > 0
                Text {
                    anchors.centerIn: parent
                    text: nights + " đêm"
                    font.pixelSize: 14
                    font.bold: true
                    color: "#333"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 60
                color: "transparent"
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 4

                    Text {
                        text: nights > 0 ? Number(totalPrice).toLocaleString(Qt.locale("vi_VN"), 'f', 0) + " đ" : (selectedRoom.price ? Number(selectedRoom.price).toLocaleString(Qt.locale("vi_VN"), 'f', 0) + " đ" : "0 đ")
                        font.pixelSize: 24
                        font.bold: true
                        color: "#7f2f2f"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }

    // ========== MAIN SCROLL ==========
    ScrollView {
        id: mainScroll
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 12
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        clip: true
        z: 0

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            anchors.right: parent.right
        }

        Column {
            id: mainContent
            width: mainScroll.width
            spacing: 24
            anchors.topMargin: 8

            Row {
                id: contentRow
                width: mainContent.width
                spacing: 0

                Column {
                    id: leftColumn
                    width: mainScroll.width - bookingSummary.width - 48
                    spacing: 20

                    // ======= Back Button =======
                    RowLayout {
                        width: leftColumn.width
                        spacing: 10

                        Button {
                            text: "\u2190 Quay lại chọn phòng"
                            onClicked: if (stackViewRef) stackViewRef.pop()
                        }

                        // Spacer to push Label to center
                        Item { Layout.fillWidth: true }

                        Label {
                            text: "Thông tin lưu trú của bạn"
                            font.pixelSize: 20
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }
                    }

                    // ======= Main Area =======
                    RowLayout {
                        width: leftColumn.width
                        spacing: 40

                        // ==== Left Column ====
                        ColumnLayout {
                            spacing: 20
                            Layout.fillWidth: true
                            Layout.preferredWidth: 800

                            // ---- Customer Information ----
                            GroupBox {
                                title: "Khách hàng"
                                Layout.fillWidth: true

                                Column {
                                    spacing: 10
                                    anchors.margins: 10

                                    Row {
                                        spacing: 10
                                        Button { text: "Cho tôi" }
                                    }

                                    RowLayout {
                                        spacing: 10
                                        Layout.preferredWidth: 720

                                        TextField { 
                                            text: UserController.getFirstName()
                                            placeholderText: "Họ"
                                            Layout.preferredWidth: 350
                                        }
                                        TextField { 
                                            text: UserController.getLastName()
                                            placeholderText: "Tên"
                                            Layout.preferredWidth: 350
                                        }
                                    }

                                    RowLayout {
                                        spacing: 10
                                        Layout.preferredWidth: 720

                                        TextField { 
                                            text: UserController.getPhone()
                                            placeholderText: "Số điện thoại"
                                            Layout.preferredWidth: 350
                                        }
                                        TextField { 
                                            text: UserController.getEmail()
                                            placeholderText: "Email"
                                            Layout.preferredWidth: 350
                                        }
                                    }

                                    CheckBox {
                                        text: "Tôi đồng ý nhận tin tức và thông tin về các ưu đãi đặc biệt"
                                    }
                                }
                            }

                            // ---- Additional Information ----
                            GroupBox {
                                title: "Thông tin bổ sung"
                                Layout.fillWidth: true

                                Column {
                                    spacing: 10
                                    anchors.margins: 10

                                    Label { text: "Yêu cầu cá nhân" }
                                    TextArea {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 80
                                        placeholderText: "Nếu bạn có bất kỳ nhu cầu đặc biệt nào..."
                                    }
                                }
                            }

                            // ---- Payment Method Selection ----
                            GroupBox {
                                title: "Chọn phương thức thanh toán"
                                Layout.fillWidth: true

                                Column {
                                    spacing: 10
                                    anchors.margins: 10

                                    Label {
                                        wrapMode: Text.Wrap
                                        text: "Bằng cách thực hiện đặt phòng, bạn đồng ý xử lý dữ liệu cá nhân..."
                                    }

                                    Button { text: "Chính sách huỷ bỏ" }

                                    RadioButton { text: "Thẻ ngân hàng" }

                                    Label { text: "Visa, MasterCard, American Express, JCB, UnionPay" }

                                    Label {
                                        font.bold: true
                                        text: "Tổng số tiền phải trả: " + (totalPrice ? Number(totalPrice).toLocaleString(Qt.locale("vi_VN"), 'f', 0) + " đ" : "0 đ")
                                    }

                                    Button {
                                        text: "Đặt phòng"
                                        background: Rectangle { color: "#c0392b"; radius: 5 }
                                        contentItem: Label {
                                            text: "Đặt phòng"
                                            color: "white"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        Layout.fillWidth: true
                                        height: 40

                                        onClicked: {
                                            RoomController.bookRoom(selectedRoom.roomId, checkInDate, checkOutDate);
                                            paymentSuccess();
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle { width: leftColumn.width; height: 16; color: "transparent" }
                }

                Item {
                    width: bookingSummary.width + 48
                }
            }

            Rectangle {
                id: footer
                width: mainContent.width
                height: 220
                color: "#001f3f"
                radius: 0
                border.width: 0
                anchors.horizontalCenter: mainContent.horizontalCenter

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 48

                    ColumnLayout {
                        spacing: 8
                        Label {
                            text: "fit@hcmus"
                            color: "#00cc99"
                            font.pixelSize: 20
                            font.bold: true
                        }
                        Label {
                            text: "Faculty of Information Technology,\nVNUHCM - University of Science"
                            color: "#ffffff"
                            wrapMode: Text.WordWrap
                        }
                    }

                    ColumnLayout {
                        spacing: 8
                        Label {
                            text: "Members"
                            color: "#00cc99"
                            font.pixelSize: 18
                            font.bold: true
                        }
                        Label { text: "• Phạm Hoàng Phúc"; color: "#ffffff" }
                        Label { text: "• Nguyễn Trực Phúc"; color: "#ffffff" }
                        Label { text: "• Nguyễn Khang Hy"; color: "#ffffff" }
                        Label { text: "• Lê Đinh Nguyên Phong"; color: "#ffffff" }
                    }

                    ColumnLayout {
                        spacing: 8
                        Label {
                            text: "Contact Us"
                            color: "#00cc99"
                            font.pixelSize: 18
                            font.bold: true
                        }
                        Label { text: "📞 0915 895 157"; color: "#ffffff" }
                        MouseArea {
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.openUrlExternally("mailto:nkhy2414@clc.fitus.edu.vn")

                            Label {
                                text: "✉ nkhy2414@clc.fitus.edu.vn"
                                color: "#00ccff"
                                font.underline: true
                            }
                        }
                    }
                }
            }
        }
    }

    // ========== PROFILE DIALOG ==========
    Dialog {
        id: profileDialog
        modal: true
        focus: true
        x: parent.width - width - 40
        y: 70
        width: 340
        contentItem: Rectangle {
            width: parent.width
            color: "#ffffff"
            radius: 8
            border.color: "#ccc"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    text: UserController.getFirstName() && UserController.getLastName() ? 
                          UserController.getFirstName() + " " + UserController.getLastName() : "Guest"
                    font.bold: true
                    font.pixelSize: 16
                }

                Text {
                    text: UserController.getPhone() ? UserController.getPhone() : "No phone"
                    color: "#666"
                    font.pixelSize: 14
                }

                Rectangle {
                    color: "#fce4ec"
                    radius: 4
                    Layout.fillWidth: true
                    height: 32
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 6
                        Text {
                            text: "\u2714"
                            font.pixelSize: 14
                            color: "#c2185b"
                        }
                        Text {
                            text: "Bạn đã nhận được khuyến mãi 10%"
                            font.pixelSize: 12
                            color: "#c2185b"
                        }
                    }
                }

                Button {
                    text: "Đăng xuất"
                    Layout.fillWidth: true
                    onClicked: {
                        UserController.logoutUser();
                    }
                }
            }
        }
    }

    Connections {
        target: UserController
        function onLogoutSuccess() {
            profileDialog.close();
            stackViewRef.replace("Login.qml");
        }
        function onLogoutFailed(errorMsg) {
            console.log("Logout failed: " + errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
    }

    Connections {
        target: RoomController
        function onRoomBooked() {
            console.log("Room booked successfully");
            stackViewRef.push("qrc:/Pkg/MVC/Views/BookingHistory.qml", {
                stackViewRef: stackViewRef
            });
            UserController.getBookingHistory();
            paymentSuccess();
        }
        function onRoomBookingFailed(errorMsg) {
            console.log("Room booking failed: " + errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
    }

    // ========== ERROR DIALOG ==========
    Dialog {
        id: errorDialog
        modal: true
        focus: true
        title: "Thông báo"
        width: 300
        property alias text: errorText.text

        x: (mainScroll.width - width) / 2 + mainScroll.x
        y: (mainScroll.height - height) / 2 + mainScroll.y

        contentItem: Rectangle {
            color: "#ffffff"
            radius: 8
            border.color: "#ccc"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    id: errorText
                    font.pixelSize: 14
                    color: "#333"
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Button {
                    text: "OK"
                    Layout.fillWidth: true
                    onClicked: errorDialog.close()
                }
            }
        }
    }
}