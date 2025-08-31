import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: bookingHistoryPage
    objectName: "BookingHistory"

    property StackView stackViewRef

    Component.onCompleted: {
        UserController.getBookingHistory();
    }

    Connections {
        target: UserController
        function onBookingHistorySuccess(bookings) {
            bookingModel.clear();
            for (var i = 0; i < bookings.length; i++) {
                bookingModel.append(bookings[i]);
            }
        }
        function onBookingHistoryFailed(errorMsg) {
            console.log("Failed to fetch booking history:", errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
        function onBookingCancelled(action, roomId) {
            //console.log("Booking action completed successfully:", action, roomId);
            // Định dạng thông báo: "CheckIn phòng roomId thành công"
            var formattedAction = action.charAt(0).toUpperCase() + action.slice(1); // Viết hoa chữ cái đầu
            var message = formattedAction + " room " + roomId + " successful";
            errorDialog.text = message;
            errorDialog.open();
            UserController.getBookingHistory(); // Cập nhật lịch sử đặt phòng
        }
        function onCancelFailed(errorMsg) {
            console.log("Action failed:", errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"

        ScrollView {
            anchors.fill: parent
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            Column {
                width: parent.width
                spacing: 20
                anchors.margins: 24

                // ===== HEADER =====
                Rectangle {
                    id: header
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

                // ===== TIÊU ĐỀ =====
                Text {
                    text: "Lịch sử đặt phòng"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#2c3e50"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                // ===== HEADER BẢNG =====
                RowLayout {
                    width: parent.width
                    spacing: 5

                    Repeater {
                        model: ["Booking ID", "Check-in", "Check-out", "Booker", "Price", "Status"]
                        delegate: Text {
                            text: modelData
                            font.bold: true
                            font.pixelSize: 16
                            color: "#555"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.preferredWidth: {
                                switch(model.index) {
                                    case 0: return 150; // Booking ID
                                    case 1: return 120; // Check-in
                                    case 2: return 120; // Check-out
                                    case 3: return 150; // Booker
                                    case 4: return 120; // Price
                                    case 5: return 120; // Status
                                    default: return 100;
                                }
                            }
                        }
                    }
                }

                // ===== DỮ LIỆU BẢNG =====
                ListModel {
                    id: bookingModel
                }

                Repeater {
                    model: bookingModel

                    delegate: RowLayout {
                        width: parent.width
                        spacing: 5
                        height: 40

                        Text { 
                            text: bookingId 
                            font.pixelSize: 15 
                            color: "#333" 
                            horizontalAlignment: Text.AlignHCenter 
                            verticalAlignment: Text.AlignVCenter 
                            Layout.preferredWidth: 150 
                        }
                        Text { 
                            text: checkIn 
                            font.pixelSize: 15 
                            color: "#333" 
                            horizontalAlignment: Text.AlignHCenter 
                            verticalAlignment: Text.AlignVCenter 
                            Layout.preferredWidth: 140 
                        }
                        Text { 
                            text: checkOut 
                            font.pixelSize: 15 
                            color: "#333" 
                            horizontalAlignment: Text.AlignHCenter 
                            verticalAlignment: Text.AlignVCenter 
                            Layout.preferredWidth: 140 
                        }
                        Text { 
                            text: guest 
                            font.pixelSize: 15 
                            color: "#333" 
                            horizontalAlignment: Text.AlignHCenter 
                            verticalAlignment: Text.AlignVCenter 
                            Layout.preferredWidth: 150 
                        }
                        Text { 
                            text: price ? Number(price).toLocaleString(Qt.locale("vi_VN"), 'f', 0) + " đ" : "0 đ" 
                            font.pixelSize: 15 
                            font.bold: true 
                            color: "#c0392b" 
                            horizontalAlignment: Text.AlignHCenter 
                            verticalAlignment: Text.AlignVCenter 
                            Layout.preferredWidth: 120 
                        }
                        Button {
                            id: actionButton
                            width: 120
                            height: 36

                            property date now: new Date()
                            property date ci: new Date(checkInDate)
                            property date co: new Date(checkOutDate)
                            property date nowDate: new Date(now.getFullYear(), now.getMonth(), now.getDate())
                            property date ciDate: new Date(ci.getFullYear(), ci.getMonth(), ci.getDate())
                            property date coDate: new Date(co.getFullYear(), co.getMonth(), co.getDate())

                            text: {
                                if (nowDate < ciDate) {
                                    return "Huỷ"
                                } else if (nowDate >= ciDate && nowDate < coDate) {
                                    if (!isCheckIn) {
                                        return "Check In"
                                    } else if (isCheckIn && !isCheckOut) {
                                        return "Check Out"
                                    } else {
                                        return "Đã CheckOut"
                                    }
                                } else {
                                    return "Đã CheckOut"
                                }
                            }

                            enabled: {
                                if (nowDate < ciDate) {
                                    return true
                                } else if (nowDate >= ciDate && nowDate < coDate) {
                                    if (!isCheckIn || (isCheckIn && !isCheckOut)) {
                                        return true
                                    }
                                    return false
                                } else {
                                    return false
                                }
                            }

                            background: Rectangle {
                                color: actionButton.enabled ? "#7f2f2f" : "#cccccc"
                                radius: 4
                            }

                            contentItem: Text {
                                text: actionButton.text
                                color: actionButton.enabled ? "white" : "#666666"
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: {
                                if (text === "Huỷ") {
                                    UserController.cancelBooking(bookingCode, roomId, "cancel")
                                } else if (text === "Check In") {
                                    UserController.cancelBooking(bookingCode, roomId, "checkIn")
                                } else if (text === "Check Out") {
                                    UserController.cancelBooking(bookingCode, roomId, "checkOut")
                                }
                            }
                        }
                    }
                }

                // ===== FOOTER HÀNH ĐỘNG =====
                Rectangle {
                    width: parent.width / 2
                    height: 44
                    radius: 4
                    color: "#ffffff"
                    border.color: "#ddd"
                    anchors.horizontalCenter: parent.horizontalCenter

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Rectangle {
                            Layout.fillWidth: true
                            color: "transparent"

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 8
                                spacing: 2

                                Text {
                                    text: "Muong Thanh Hotel"
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: "#2c3e50"
                                }
                                Text {
                                    text: "Thank you for choosing our services!"
                                    font.pixelSize: 14
                                    color: "#555"
                                }
                            }
                        }

                        Button {
                            width: 120
                            height: parent.height
                            background: Rectangle {
                                color: "#d94a38"
                                radius: 4
                            }
                            contentItem: Text {
                                text: "Book now"
                                color: "white"
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: {
                                stackViewRef.push("qrc:/Pkg/MVC/Views/Booking.qml", {
                                    stackViewRef: stackViewRef
                                });
                            }
                        }
                    }
                }

                // ===== FOOTER THÔNG TIN =====
                Rectangle {
                    id: footer
                    width: parent.width
                    height: 220
                    color: "#001f3f"

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
    }

    // ========== ERROR DIALOG ==========
    Dialog {
        id: errorDialog
        modal: true
        focus: true
        title: "Thông báo"
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 300
        property alias text: errorText.text

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
}