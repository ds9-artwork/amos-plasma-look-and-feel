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

    AnalogClock {
        id: clock
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: units.gridUnit * -1
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ColumnLayout {
        id: mainBlock
        spacing: 18
        width: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: clock.bottom
        anchors.topMargin: 18

        property bool locked: true

        CustomPasswordField {
            id: passwordBox
            height: 32
            width: 260
            property alias password: passwordBox.text

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
