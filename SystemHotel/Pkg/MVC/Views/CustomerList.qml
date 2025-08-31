import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml 2.15

Page {
    id: customerPage
    width: 1280
    height: 800
    objectName: "CustomerList"

    property StackView stackViewRef

    // Timer để debounce các sự kiện tìm kiếm
    Timer {
        id: searchDebounceTimer
        interval: 500 // 500ms debounce
        repeat: false
        onTriggered: {
            // Chuyển đổi định dạng ngày từ DD/MM/YYYY sang YYYY-MM-DD
            var checkInQuery = checkInSearch.text;
            if (checkInQuery) {
                var parts = checkInQuery.split("/");
                if (parts.length === 3) {
                    checkInQuery = parts[2] + "-" + parts[1] + "-" + parts[0];
                } else {
                    checkInQuery = "";
                }
            }
            AdminController.getAllUsers(bookerSearch.text, roomIdSearch.text, checkInQuery);
        }
    }

    Component.onCompleted: {
        AdminController.getAllUsers();
    }

    Connections {
        target: AdminController
        function onUsersFetched(users) {
            customerModel.clear();
            for (var i = 0; i < users.length; i++) {
                var user = users[i];
                // Chỉ thêm user có RoomList không rỗng
                if (user.RoomList.length > 0) {
                    for (var j = 0; j < user.RoomList.length; j++) {
                        var room = user.RoomList[j];
                        customerModel.append({
                            booker: user.firstName + " " + user.lastName,
                            roomId: room.roomId,
                            checkIn: Qt.formatDate(new Date(room.checkInDate), "dd/MM/yyyy"),
                            checkOut: Qt.formatDate(new Date(room.checkOutDate), "dd/MM/yyyy"),
                            price: room.price,
                            status: room.status,
                            bookingCode: room.bookingCode,
                            isCheckIn: room.isCheckIn,
                            isCheckOut: room.isCheckOut,
                            checkInDate: room.checkInDate,
                            checkOutDate: room.checkOutDate
                        });
                    }
                }
            }
        }
        function onUsersFetchFailed(errorMsg) {
            console.log("Failed to fetch users:", errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
        function onBookingCancelled(action, roomId) {
            var formattedAction = action.charAt(0).toUpperCase() + action.slice(1);
            var message = formattedAction + " room " + roomId + " successful";
            errorDialog.text = message;
            errorDialog.open();
            AdminController.getAllUsers(bookerSearch.text, roomIdSearch.text, checkInSearch.text);
        }
        function onCancelFailed(errorMsg) {
            console.log("Action failed:", errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
        function onLogoutSuccess() {
            profileDialog.close();
            stackViewRef.push("qrc:/Pkg/MVC/Views/Login.qml");
        }
        function onLogoutFailed(errorMsg) {
            console.log("Logout failed:", errorMsg);
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"

        Column {
            anchors.fill: parent
            spacing: 16

            // ===== HEADER =====
            Rectangle {
                id: header
                width: parent.width
                height: parent.height * 0.075 // 7.5% of parent height
                color: "#d32f2f"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: parent.width * 0.0375 // 3.75% of parent width
                    anchors.rightMargin: parent.width * 0.025 // 2.5% of parent width
                    spacing: parent.width * 0.05 // 5% of parent width

                    Text {
                        text: "CUSTOMER"
                        color: "white"
                        font.pixelSize: parent.height * 0.3 // 30% of header height
                        font.bold: true
                    }

                    Text {
                        text: "ROOM"
                        color: "white"
                        font.pixelSize: parent.height * 0.3
                        font.bold: true
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                stackViewRef.push("qrc:/Pkg/MVC/Views/CreateRoom.qml", {
                                    stackViewRef: stackViewRef
                                });
                            }
                        }
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
                            text: AdminController.getFullName() ? AdminController.getFullName()[0].toUpperCase() : "A"
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

            // ===== TITLE =====
            Text {
                text: "Danh sách khách hàng"
                font.pixelSize: 28
                font.bold: true
                color: "#2c3e50"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // ===== SEARCH BAR =====
            RowLayout {
                width: parent.width
                anchors.leftMargin: 64
                anchors.rightMargin: 64
                spacing: 16

                TextField {
                    id: bookerSearch
                    placeholderText: "Tìm kiếm theo tên khách hàng"
                    Layout.preferredWidth: parent.width / 5
                    Layout.leftMargin: 24
                    onTextChanged: {
                        searchDebounceTimer.restart();
                    }
                }

                Item { Layout.fillWidth: true }

                TextField {
                    id: roomIdSearch
                    placeholderText: "Tìm kiếm theo ID phòng"
                    Layout.preferredWidth: parent.width / 5
                    Layout.alignment: Qt.AlignHCenter
                    onTextChanged: {
                        searchDebounceTimer.restart();
                    }
                }

                Item { Layout.fillWidth: true }

                TextField {
                    id: checkInSearch
                    placeholderText: "Ngày check-in (DD/MM/YYYY)"
                    Layout.preferredWidth: parent.width / 5
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 24
                    onTextChanged: {
                        searchDebounceTimer.restart();
                    }
                }
            }

            // ===== TABLE HEADER =====
            Row {
                width: parent.width
                height: 40
                spacing: 0

                Repeater {
                    model: ["Khách hàng", "ID Phòng", "Check-in", "Check-out", "Giá", "Trạng thái"]
                    delegate: Rectangle {
                        width: parent.width / 6
                        height: parent.height
                        color: "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.bold: true
                            font.pixelSize: 16
                            color: "#555"
                        }
                    }
                }
            }

            Rectangle { height: 1; width: parent.width; color: "#ccc" }

            // ===== TABLE DATA =====
            ListModel {
                id: customerModel
            }

            ScrollView {
                width: parent.width
                height: parent.height - header.height - 200
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                Column {
                    width: parent.width
                    spacing: 0

                    Repeater {
                        model: customerModel

                        delegate: Column {
                            width: parent.width

                            Row {
                                width: parent.width
                                height: 40
                                spacing: 0

                                Text {
                                    text: booker
                                    width: parent.width/6
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 15
                                    color: "#333"
                                }
                                Text {
                                    text: roomId
                                    width: parent.width/6
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 15
                                    color: "#333"
                                }
                                Text {
                                    text: checkIn
                                    width: parent.width/6
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 15
                                    color: "#333"
                                }
                                Text {
                                    text: checkOut
                                    width: parent.width/6
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 15
                                    color: "#333"
                                }
                                Text {
                                    text: price ? Number(price).toLocaleString(Qt.locale("vi_VN"), 'f', 0) + " đ" : "0 đ"
                                    width: parent.width/6
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 15
                                    color: "#c0392b"
                                }
                                Button {
                                    id: actionButton
                                    width: parent.width/6
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
                                            AdminController.cancelBooking(bookingCode, roomId, "cancel")
                                        } else if (text === "Check In") {
                                            AdminController.cancelBooking(bookingCode, roomId, "checkIn")
                                        } else if (text === "Check Out") {
                                            AdminController.cancelBooking(bookingCode, roomId, "checkOut")
                                        }
                                    }
                                }
                            }

                            Rectangle { height: 1; width: parent.width; color: "#ddd" }
                        }
                    }
                }
            }

            // ===== FOOTER =====
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

    // ===== PROFILE DIALOG =====
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
                    text: AdminController.getFullName() ? AdminController.getFullName() : "Admin"
                    font.bold: true
                    font.pixelSize: 16
                }

                Text {
                    text: AdminController.getPhone() ? AdminController.getPhone() : "No phone"
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
                        AdminController.logoutAdmin();
                    }
                }
            }
        }
    }

    // ===== ERROR DIALOG =====
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
}