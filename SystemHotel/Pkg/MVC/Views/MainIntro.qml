import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: mainIntro
    objectName: "MainIntro"
    signal openLogin

    width: 1280
    height: 800

    // ===== TASKBAR =====
    Rectangle {
        id: topBar
        width: parent.width
        height: 60
        color: "#ffffffcc"
        border.color: "#cccccc"
        anchors.top: parent.top
        z: 2

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            Repeater {
                model: [
                    { label: "Tổng quan", target: overviewSection },
                    { label: "Vị trí", target: locationSection },
                    { label: "Phòng nghỉ", target: roomSection },
                    { label: "Ẩm thực", target: foodSection },
                    { label: "Dịch vụ", target: serviceSection }
                ]
                delegate: MouseArea {
                    Layout.fillWidth: true
                    height: parent.height
                    property color defaultColor: "#333333"
                    property color hoverColor: "#ff9900"
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: flickableContent.contentY = modelData.target.y
                    onEntered: navText.color = hoverColor
                    onExited: navText.color = defaultColor

                    Text {
                        id: navText
                        text: modelData.label
                        font.bold: true
                        font.pixelSize: 16
                        color: defaultColor
                        anchors.centerIn: parent
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Đăng nhập"
                font.bold: true
                font.pixelSize: 14
                background: Rectangle { color: "#FF5722"; radius: 6 }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font: parent.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: openLogin()
            }
        }
    }

    // ===== SCROLLABLE CONTENT =====
    Flickable {
        id: flickableContent
        clip: true
        contentWidth: columnContent.width
        contentHeight: columnContent.height
        anchors {
            top: topBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        ColumnLayout {
            id: columnContent
            width: mainIntro.width
            spacing: 32
            anchors.margins: 32

            // ẢNH BANNER
            Rectangle {
                width: parent.width
                height: 380
                Image {
                    anchors.fill: parent
                    source: "qrc:/Pkg/MVC/Views/images/banner_background.png"
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.4
                }
            }

            // NGĂN CÁCH GIỮA ẢNH VÀ NỘI DUNG
            Rectangle {
                width: parent.width
                height: 160
                color: "#f5f5f5"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 8
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    Label {
                        text: "Mường Thanh Luxury TP.HCM"
                        font.family: "Helvetica"
                        font.pixelSize: 22
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label {
                        text: "Thiết kế hiện đại kết hợp truyền thống, mang đến trải nghiệm độc đáo."
                        font.family: "Helvetica"
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        maximumLineCount: 2
                    }
                }
            }

            // LOBBY + THÔNG TIN
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 40
                Layout.leftMargin: 48
                Layout.rightMargin: 48

                Rectangle {
                    width: 460
                    height: 240
                    color: "transparent"
                    Layout.leftMargin: 24
                    Image {
                        anchors.fill: parent
                        source: "qrc:/Pkg/MVC/Views/images/lobby.png"
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                ColumnLayout {
                    spacing: 12
                    Layout.fillWidth: true
                    Layout.preferredWidth: 460
                    Layout.rightMargin: 24

                    Label { 
                        text: "Mường Thanh Luxury Sài Gòn"; 
                        font.pixelSize: 24; 
                        font.bold: true; 
                        font.family: "Segoe UI"
                    }
                    Label { 
                        text: "Địa chỉ: 123 Nguyễn Văn Linh, Quận 7"; 
                        font.pixelSize: 14;
                        font.family: "Segoe UI";
                        wrapMode: Text.WordWrap
                    }
                    Label { 
                        text: "Giá từ: 1.200.000đ/đêm"; 
                        font.pixelSize: 16;
                        font.family: "Segoe UI"
                    }
                    Label { 
                        text: "Dịch vụ: Hồ bơi, Nhà hàng, Wifi"; 
                        font.pixelSize: 14;
                        font.family: "Segoe UI"
                    }

                    Button {
                        text: "Đặt phòng ngay"
                        font.pixelSize: 14
                        width: 160
                        background: Rectangle { color: "#FF5722"; radius: 6 }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font: parent.font
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: openLogin()
                    }
                }
            }

            // 1. TỔNG QUAN
            RowLayout {
                id: overviewSection
                Layout.fillWidth: true
                spacing: 48
                Layout.leftMargin: 48
                Layout.rightMargin: 48

                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true
                    Layout.preferredWidth: 460
                    Layout.leftMargin: 48
                    Layout.rightMargin: 24

                    Label {
                        text: "1. TỔNG QUAN"
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "- Không gian sang trọng, đậm chất văn hóa Việt."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "- Lý tưởng cho du lịch, công tác và nghỉ dưỡng."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }

                Rectangle {
                    width: 460
                    height: 240
                    color: "transparent"
                    Layout.leftMargin: 48
                    Image {
                        anchors.fill: parent
                        source: "qrc:/Pkg/MVC/Views/images/outside_look.png"
                        fillMode: Image.PreserveAspectCrop
                    }
                }
            }

            // 2. VỊ TRÍ
            RowLayout {
                id: locationSection
                Layout.fillWidth: true
                spacing: 64
                Layout.leftMargin: 48
                Layout.rightMargin: 48

                Rectangle {
                    width: 460
                    height: 240
                    color: "transparent"
                    Layout.leftMargin: 48
                    Image {
                        anchors.fill: parent
                        source: "qrc:/Pkg/MVC/Views/images/pool.png"
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true
                    Layout.preferredWidth: 460
                    Layout.leftMargin: 48
                    Layout.rightMargin: 48

                    Label {
                        text: "2. VỊ TRÍ"
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "- Trung tâm Quận 7, gần khu thương mại sầm uất."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "- Gần sân bay, thuận tiện di chuyển nhanh chóng."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }
            }

            // 3. PHÒNG NGHỈ
            RowLayout {
                id: roomSection
                Layout.fillWidth: true
                spacing: 48
                Layout.leftMargin: 48
                Layout.rightMargin: 48

                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true
                    Layout.preferredWidth: 460
                    Layout.leftMargin: 48
                    Layout.rightMargin: 24

                    Label {
                        text: "3. PHÒNG NGHỈ"
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "- Đa dạng từ tiêu chuẩn đến cao cấp sang trọng, tiện nghi."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "- Tiện nghi hiện đại, tầm nhìn đẹp, không gian thoáng đãng."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }

                ColumnLayout {
                    spacing: 12
                    Layout.leftMargin: 48
                    Rectangle {
                        width: 460
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/room4.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 460
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/room9.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
            }

            // 4. ẨM THỰC
            RowLayout {
                id: foodSection
                Layout.fillWidth: true
                spacing: 64
                Layout.leftMargin: 48
                Layout.rightMargin: 48

                ColumnLayout {
                    spacing: 12
                    Layout.leftMargin: 48
                    Rectangle {
                        width: 460
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/buffet.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 460
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/freshseafood.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }

                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true
                    Layout.preferredWidth: 460
                    Layout.leftMargin: 48
                    Layout.rightMargin: 48

                    Label {
                        text: "4. ẨM THỰC"
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "- Buffet Á-Âu, nguyên liệu tươi ngon, đa dạng món ăn."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "- Hải sản tươi sống, không gian sang trọng, ấm cúng, chuyên nghiệp."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }
            }

            // 5. HOẠT ĐỘNG
            RowLayout {
                id: activitySection
                Layout.fillWidth: true
                spacing: 48
                Layout.leftMargin: 48
                Layout.rightMargin: 48

                ColumnLayout {
                    spacing: 8
                    Layout.fillWidth: true
                    Layout.preferredWidth: 460
                    Layout.leftMargin: 48
                    Layout.rightMargin: 24

                    Label {
                        text: "5. HOẠT ĐỘNG"
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Segoe UI"
                        color: "#333333"
                    }

                    Label {
                        text: "- Phòng gym hiện đại, thiết bị tiên tiến hàng đầu, đầy đủ."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }

                    Label {
                        text: "- Bar ngoài trời, cocktail độc đáo, không gian thư giãn thoải mái."
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        font.family: "Segoe UI"
                        color: "#444444"
                    }
                }

                ColumnLayout {
                    spacing: 12
                    Layout.leftMargin: 48
                    Rectangle {
                        width: 460
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/gym.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 460
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/outdoorbar.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
            }

            // 6. DỊCH VỤ
            ColumnLayout {
                id: serviceSection
                spacing: 12
                Layout.fillWidth: true

                Label {
                    text: "6. DỊCH VỤ TIỆN ÍCH"
                    font.pixelSize: 22
                    font.bold: true
                    font.family: "Segoe UI"
                    color: "#333333"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: "- Hồ bơi, nhà hàng, wifi, spa cao cấp cho trải nghiệm tuyệt vời."
                    wrapMode: Text.WordWrap
                    font.pixelSize: 14
                    font.family: "Segoe UI"
                    color: "#444444"
                    width: 600
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }

                // Ảnh hàng trên
                RowLayout {
                    spacing: 32
                    Layout.alignment: Qt.AlignHCenter
                    width: parent.width

                    Item { Layout.fillWidth: true }

                    Rectangle {
                        width: 280
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/pool.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 280
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/wifi.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    Item { Layout.fillWidth: true }
                }

                // Ảnh hàng dưới
                RowLayout {
                    spacing: 32
                    Layout.alignment: Qt.AlignHCenter
                    width: parent.width

                    Item { Layout.fillWidth: true }

                    Rectangle {
                        width: 280
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/restaurant.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                    Rectangle {
                        width: 280
                        height: 160
                        color: "transparent"
                        Image {
                            anchors.fill: parent
                            source: "qrc:/Pkg/MVC/Views/images/spa.png"
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    Item { Layout.fillWidth: true }
                }
            }

            // FOOTER
            Rectangle {
                width: parent.width
                height: 180
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
                            font.pixelSize: 18
                            font.bold: true
                        }
                        Label {
                            text: "Faculty of IT, VNUHCM - US"
                            color: "#ffffff"
                            font.pixelSize: 14
                            wrapMode: Text.WordWrap
                        }
                    }

                    ColumnLayout {
                        spacing: 8
                        Label {
                            text: "Members"
                            color: "#00cc99"
                            font.pixelSize: 16
                            font.bold: true
                        }
                        Label { text: "• Phạm Hoàng Phúc"; color: "#ffffff"; font.pixelSize: 14 }
                        Label { text: "• Nguyễn Trực Phúc"; color: "#ffffff"; font.pixelSize: 14 }
                        Label { text: "• Nguyễn Khang Hy"; color: "#ffffff"; font.pixelSize: 14 }
                        Label { text: "• Lê Đinh Nguyên Phong"; color: "#ffffff"; font.pixelSize: 14 }
                    }

                    ColumnLayout {
                        spacing: 8
                        Label {
                            text: "Contact Us"
                            color: "#00cc99"
                            font.pixelSize: 16
                            font.bold: true
                        }
                        Label { text: "📞 0915 895 157"; color: "#ffffff"; font.pixelSize: 14 }
                        MouseArea {
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.openUrlExternally("mailto:nkhy2414@clc.fitus.edu.vn")

                            Label {
                                text: "✉ nkhy2414@clc.fitus.edu.vn"
                                color: "#00ccff"
                                font.pixelSize: 14
                                font.underline: true
                            }
                        }
                    }
                }
            }
        }
    }
}