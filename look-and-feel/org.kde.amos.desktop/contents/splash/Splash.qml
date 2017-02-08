import QtQuick 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Image {
    id: root
    source: "images/background.png"

    property int stage

    Rectangle {
        anchors.fill: items

        border.color: "#628DCF"
        border.width: 3
    }

    ListModel {
        id: images

        Component.onCompleted: {
            append({"icon": "images/fm_icon.png", text: i18n("File Manager")});
            append({"icon": "images/sys_set_icon.png", text: i18n("System settings")});
            append({"icon": "images/vt_icon.png", text: i18n("Virtual Terminal")});
            append({"icon": "images/net_icon.png", text: i18n("Networking")});
            append({"icon": "images/work_icon.png", text: i18n("Workbench")});

            completed = true;
        }
    }
    RowLayout {
        id: items
        anchors.centerIn: parent
        spacing: 0

        Repeater {
            model: images
            delegate: ColumnLayout {
                id: delegateRoot
                Layout.margins: 18

                opacity: 0
                Image {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    source: icon
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text: model.text
                }

                states: [
                    State {
                        name: "visible"
                        when: root.stage > index
                        PropertyChanges {
                            target: delegateRoot
                            opacity: 1
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: ""
                        to: "visible"
                        NumberAnimation {
                            properties: "opacity"
                            duration: 2000
                            easing.type: Easing.OutBounce
                        }
                    }
                ]
            }
        }
    }
}
