import QtQuick 2.5
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.sessions 2.0
import "../components"

Rectangle {
    id: lockScreenRoot

    //colorGroup: PlasmaCore.Theme.ComplementaryColorGroup
    color: "transparent"

    Image {
        anchors.fill: parent
        source: "../components/artwork/background.png"
    }
    Connections {
        target: authenticator
        onFailed: {
            root.notification = i18nd("plasma_lookandfeel_org.kde.lookandfeel",
                                      "Unlocking failed")
        }
        onGraceLockedChanged: {
            if (!authenticator.graceLocked) {
                root.notification = ""
                root.clearPassword()
            }
        }
        onMessage: {
            root.notification = msg
        }
        onError: {
            root.notification = err
        }
    }

    SessionsModel {
        id: sessionsModel
        showNewSessionEntry: true
    }

    PlasmaCore.DataSource {
        id: keystateSource
        engine: "keystate"
        connectedSources: "Caps Lock"
    }



    ColumnLayout {
        id: mainBlock
        spacing: 18
        width: 200
        anchors.centerIn: parent

        property bool locked: true

        AnalogClock {
            id: clock
            Layout.alignment: Qt.AlignHCenter
        }

        CustomPasswordField {
            id: passwordBox
            height: 32
            width: 260
            property alias password: passwordBox.text

            Layout.alignment: Qt.AlignHCenter
            focus: true
            enabled: !authenticator.graceLocked

            onAccepted: authenticator.tryUnlock(passwordBox.text)

            Connections {
                target: root
                onClearPassword: {
                    passwordBox.forceActiveFocus()
                    //                    passwordBox.selectAll()
                }
            }

            Keys.onPressed: {
                if (event.key == Qt.Key_Escape) {
                    root.clearPassword()
                }
            }

            Image {
                source: "../components/artwork/pass.png"
                anchors.right: parent.left
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Image {
            Layout.topMargin: 64
            Layout.alignment: Qt.AlignHCenter
            source: "../components/artwork/login_icon.png"
        }

        PlasmaComponents.Button {
            id: loginButton
            focus: true
            Layout.alignment: Qt.AlignHCenter
            text: !authenticator.graceLocked ? i18nd(
                                                   "plasma_lookandfeel_org.kde.lookandfeel",
                                                   "Unlock") : i18nd(
                                                   "plasma_lookandfeel_org.kde.lookandfeel",
                                                   "Authenticating...")
            enabled: !authenticator.graceLocked
            onClicked: authenticator.tryUnlock(passwordBox.password)

            Keys.onPressed: {
                if (mainBlock.locked) {
                    mainBlock.locked = false
                    root.clearPassword()
                }
            }

            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#888"
                    radius: 0
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                        GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        // version support checks
        if (root.interfaceVersion < 1) {
            // ksmserver of 5.4, with greeter of 5.5
            root.viewVisible = true
        }
    }
}
