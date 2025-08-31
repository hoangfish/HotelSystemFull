import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: loginPage
    objectName: "Login"
    width: 1280
    height: 720

    signal loginSuccess()
    signal adminLoginSuccess()

    property bool isEmailMode: true
    property bool isAdminMode: false

    Component.onCompleted: {
        Qt.callLater(() => loginPage.width += 1)
        Qt.callLater(() => loginPage.width -= 1)
    }

    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"
    }

    Image {
        anchors.fill: parent
        source: "qrc:/Pkg/MVC/Views/images/outside_look.png"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.2
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 20

        // === REGISTER FORM ===
        Rectangle {
            id: registerForm
            visible: false
            width: 460
            height: 520
            radius: 16
            color: "white"
            border.color: "#cccccc"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Đăng ký"
                        font.pixelSize: 22
                        font.bold: true
                        Layout.alignment: Qt.AlignLeft
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "✕"
                        color: "#b71c1c"
                        font.pixelSize: 24
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                registerForm.visible = false
                                loginForm.visible = true
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    TextField {
                        id: firstNameInput
                        placeholderText: "Tên"
                        Layout.fillWidth: true
                        font.pixelSize: 16
                    }

                    TextField {
                        id: lastNameInput
                        placeholderText: "Họ"
                        Layout.fillWidth: true
                        font.pixelSize: 16
                    }
                }

                TextField {
                    id: phoneInput
                    placeholderText: "Số điện thoại"
                    Layout.fillWidth: true
                    font.pixelSize: 16
                }

                TextField {
                    id: emailInput
                    placeholderText: "Email"
                    Layout.fillWidth: true
                    font.pixelSize: 16
                }

                TextField {
                    id: registerPasswordInput
                    placeholderText: "Mật khẩu"
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                    font.pixelSize: 16
                }

                Button {
                    text: "Đăng ký"
                    Layout.fillWidth: true
                    height: 40
                    background: Rectangle {
                        color: "#b71c1c"
                        radius: 8
                    }
                    contentItem: Text {
                        text: parent.text
                        anchors.centerIn: parent
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                    }
                    onClicked: {
                        if (firstNameInput.text === "" || lastNameInput.text === "" ||
                            phoneInput.text === "" || emailInput.text === "" || registerPasswordInput.text === "") {
                            errorDialog.text = "Vui lòng nhập đầy đủ thông tin";
                            errorDialog.open();
                        } else {
                            UserController.registerUser(
                                firstNameInput.text,
                                lastNameInput.text,
                                emailInput.text,
                                phoneInput.text,
                                registerPasswordInput.text
                            )
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#cccccc"
                }

                Text {
                    text: "© Hotel Management Team - OOP 2025"
                    font.pixelSize: 12
                    opacity: 0.6
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // === LOGIN FORM ===
        Rectangle {
            id: loginForm
            visible: true
            width: 420
            height: 520
            radius: 16
            color: "white"
            border.color: "#cccccc"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 20

                Text {
                    text: isAdminMode ? "Đăng nhập Admin" : "Đăng nhập tài khoản cá nhân"
                    font.pixelSize: 22
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        color: isEmailMode ? "#fce8e6" : "white"
                        border.color: "#b71c1c"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Email"
                            color: "#b71c1c"
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: isEmailMode = true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        color: !isEmailMode ? "#fce8e6" : "white"
                        border.color: "#b71c1c"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Số điện thoại"
                            color: "#b71c1c"
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: isEmailMode = false
                        }
                    }
                }

                TextField {
                    id: usernameInput
                    placeholderText: isEmailMode ? "Email" : "Số điện thoại"
                    Layout.fillWidth: true
                    font.pixelSize: 16
                }

                TextField {
                    id: passwordInput
                    placeholderText: "Mật khẩu"
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                    font.pixelSize: 16
                }

                CheckBox {
                    id: adminCheckBox
                    text: "Đăng nhập với tư cách Admin"
                    checked: isAdminMode
                    onCheckedChanged: isAdminMode = checked
                }

                Button {
                    text: "Đăng nhập"
                    Layout.fillWidth: true
                    height: 40
                    font.pixelSize: 16
                    background: Rectangle {
                        color: "#b71c1c"
                        radius: 8
                    }
                    contentItem: Text {
                        text: parent.text
                        anchors.centerIn: parent
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                    }
                    onClicked: {
                        if (usernameInput.text === "" || passwordInput.text === "") {
                            errorDialog.text = "Vui lòng nhập đầy đủ thông tin";
                            errorDialog.open();
                        } else {
                            if (isAdminMode) {
                                AdminController.loginAdmin(usernameInput.text, passwordInput.text);
                            } else {
                                UserController.loginUser(usernameInput.text, passwordInput.text);
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    visible: !isAdminMode

                    Text {
                        text: "Đăng ký"
                        color: "#b71c1c"
                        font.pixelSize: 14
                        font.bold: true
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                loginForm.visible = false
                                registerForm.visible = true
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#cccccc"
                }

                Text {
                    text: "© Hotel Management Team - OOP 2025"
                    font.pixelSize: 12
                    opacity: 0.6
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    // === ERROR DIALOG ===
    Dialog {
        id: errorDialog
        modal: true
        focus: true
        title: "Lỗi"
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
        target: UserController
        function onLoginSuccess(firstName, lastName) {
            console.log("Login successful for:", firstName, lastName);
            loginSuccess();
        }
        function onLoginFailed(errorMsg) {
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
        function onRegisterSuccess() {
            console.log("Register successful");
            registerForm.visible = false;
            loginForm.visible = true;
            errorDialog.text = "Đăng ký thành công, vui lòng đăng nhập";
            errorDialog.open();
        }
        function onRegisterFailed(errorMsg) {
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
    }

    Connections {
        target: AdminController
        function onLoginSuccess(fullName) {
            console.log("Admin login successful for:", fullName);
            adminLoginSuccess();
        }
        function onLoginFailed(errorMsg) {
            errorDialog.text = errorMsg;
            errorDialog.open();
        }
    }
}