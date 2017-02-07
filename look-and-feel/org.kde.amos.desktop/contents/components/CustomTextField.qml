import QtQuick 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

FocusScope {
    id: container
    width: 80
    height: 30

    property color borderColor: "#ababab"
    property color focusColor: "#266294"
    property color hoverColor: "#5692c4"
    property alias radius: main.radius
    property alias font: txtMain.font
    property alias textColor: txtMain.color
    property alias echoMode: txtMain.echoMode
    property alias text: txtMain.text
    property alias placeholderText: userNotice.text

    font.pixelSize: 12
    signal accepted()

    Rectangle {
        id: main

        anchors.fill: parent

        gradient: Gradient {
            GradientStop {
                position: 0
                color: activeFocus ? "#ccc" : "#eee"
            }
            GradientStop {
                position: 1
                color: activeFocus ? "#aaa" : "#ccc"
            }
        }

        border.color: container.borderColor
        border.width: 1

        Behavior on border.color {
            ColorAnimation {
                duration: 100
            }
        }

        states: [
            State {
                name: "hover"
                when: mouseArea.containsMouse
                PropertyChanges {
                    target: main
                    border.width: 1
                    border.color: container.hoverColor
                }
            },
            State {
                name: "focus"
                when: container.activeFocus && !mouseArea.containsMouse
                PropertyChanges {
                    target: main
                    border.width: 1
                    border.color: container.focusColor
                }
            }
        ]
    }

    MouseArea {
        id: mouseArea
        anchors.fill: container

        cursorShape: Qt.IBeamCursor

        hoverEnabled: true

        onEntered: if (main.state == "")
                       main.state = "hover"
        onExited: if (main.state == "hover")
                      main.state = ""
        onClicked: container.focus = true
    }

    TextInput {
        id: txtMain
        width: parent.width - 16
        anchors.centerIn: parent

        color: "black"

        clip: true
        focus: true

        passwordCharacter: "\u25cf"
        onAccepted: container.accepted()
    }

    Text {
        id: userNotice
        text: "Place Holder Text"
        //                        color: "#90A4AE"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        visible: container.text == ""
        font.pointSize: 9
    }
}
