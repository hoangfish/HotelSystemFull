import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: roomPage

    property StackView stackViewRef

    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"

        Column {
            anchors.fill: parent
            spacing: parent.height * 0.02 // Reduced to 2% of parent height for compactness

            // ===== HEADER =====
            Rectangle {
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
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                stackViewRef.push("qrc:/Pkg/MVC/Views/CustomerList.qml", {
                                    stackViewRef: stackViewRef
                                });
                            }
                        }
                    }

                    Text {
                        text: "ROOM"
                        color: "white"
                        font.pixelSize: parent.height * 0.3
                        font.bold: true
                    }

                    Item { Layout.fillWidth: true }

                    // Avatar
                    Rectangle {
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
                text: "Create Room"
                font.pixelSize: parent.width * 0.025 // 2.5% of parent width
                font.bold: true
                color: "#2c3e50"
                anchors.horizontalCenter: parent.horizontalCenter
                padding: parent.width * 0.0125 // 1.25% of parent width
            }

            // ===== FORM AND BUTTON =====
            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: parent.width * 0.02 // 2% of parent width

                // Form
                GridLayout {
                    id: formLayout
                    columns: 2
                    columnSpacing: parent.parent.width * 0.01875 // 1.875% of parent width
                    rowSpacing: parent.parent.height * 0.015 // Reduced to 1.5% of parent height for compactness
                    Layout.preferredWidth: parent.parent.width * 0.65 // Reduced to 65% to fit all fields

                    // Room ID
                    Text {
                        text: "Room ID"
                        font.pixelSize: 14 // Reduced for compactness
                        Layout.alignment: Qt.AlignVCenter
                    }
                    TextField {
                        id: roomIdInput
                        placeholderText: qsTr("Room ID")
                        Layout.fillWidth: true
                        font.pixelSize: 14 // Reduced for compactness
                    }

                    // Room Number
                    Text {
                        text: "Room Number"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }
                    TextField {
                        id: roomNumberInput
                        placeholderText: qsTr("Room Number")
                        Layout.fillWidth: true
                        font.pixelSize: 14
                    }

                    // Bed Count
                    Text {
                        text: "Bed Count"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }
                    TextField {
                        id: bedCountInput
                        placeholderText: qsTr("Bed Count")
                        Layout.fillWidth: true
                        font.pixelSize: 14
                    }

                    // Room Type
                    Text {
                        text: "Room Type"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }
                    ComboBox {
                        id: roomTypeInput
                        model: ["single", "double", "family"]
                        Layout.fillWidth: true
                        font.pixelSize: 14
                    }

                    // Price
                    Text {
                        text: "Price"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }
                    TextField {
                        id: priceInput
                        placeholderText: qsTr("Price")
                        Layout.fillWidth: true
                        font.pixelSize: 14
                    }

                    // Description
                    Text {
                        text: "Description"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }
                    TextField {
                        id: descriptionInput
                        placeholderText: qsTr("Description")
                        Layout.fillWidth: true
                        font.pixelSize: 14
                    }

                    // Image
                    Text {
                        text: "Image"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }
                    TextField {
                        id: imageInput
                        placeholderText: qsTr("Image URL")
                        Layout.fillWidth: true
                        font.pixelSize: 14
                    }

                    // Guests
                    Text {
                        text: "Guests"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }
                    TextField {
                        id: guestsInput
                        placeholderText: qsTr("Guests")
                        Layout.fillWidth: true
                        font.pixelSize: 14
                    }

                    // Area
                    Text {
                        text: "Area"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }
                    TextField {
                        id: areaInput
                        placeholderText: qsTr("Area (m²)")
                        Layout.fillWidth: true
                        font.pixelSize: 14
                    }
                }

                // Update Button
                Button {
                    text: "Update"
                    Layout.preferredWidth: parent.parent.width * 0.1 // 10% of parent width
                    Layout.preferredHeight: parent.parent.height * 0.06 // 6% of parent height
                    font.pixelSize: 16 // Slightly reduced for consistency
                    font.bold: true
                    background: Rectangle {
                        color: "#d32f2f"
                        radius: 4
                    }
                    onClicked: {
                        if (roomIdInput.text && roomNumberInput.text && bedCountInput.text && roomTypeInput.currentText && priceInput.text && descriptionInput.text && imageInput.text && guestsInput.text && areaInput.text) {
                            var roomData = {
                                "roomId": roomIdInput.text,
                                "roomNumber": roomNumberInput.text,
                                "bedCount": parseInt(bedCountInput.text),
                                "roomType": roomTypeInput.currentText,
                                "price": parseFloat(priceInput.text),
                                "description": descriptionInput.text,
                                "image": imageInput.text,
                                "guests": parseInt(guestsInput.text),
                                "area": areaInput.text
                            };
                            RoomController.createRoom(roomData);
                        } else {
                            errorDialog.text = "Vui lòng điền đầy đủ thông tin";
                            errorDialog.open();
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true } // Fill remaining space for better layout
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

    Connections {
        target: RoomController
        function onRoomCreated() {
            errorDialog.text = "Tạo phòng thành công";
            errorDialog.open();
        }
        function onRoomCreateFailed(errorMsg) {
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
    }

    Connections {
        target: AdminController
        function onLogoutSuccess() {
            profileDialog.close();
            stackViewRef.push("qrc:/Pkg/MVC/Views/Login.qml");
        }
        function onLogoutFailed(errorMsg) {
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
    }
}