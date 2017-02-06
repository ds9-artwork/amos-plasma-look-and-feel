/***************************************************************************
* Copyright (c) 2015 Mikkel Oscar Lyderik <mikkeloscar@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/
import QtQuick 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "Components"

Rectangle {
    id: container

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    //    property int sessionIndex: session.index
    TextConstants {
        id: textConstants
    }

    Connections {
        target: sddm

        onLoginSucceeded: {

        }

        onLoginFailed: {
            errorMessage.text = textConstants.loginFailed
            password.text = ""
        }
    }

    Background {
        id: background
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    DirectionalBlur {
        anchors.fill: background
        source: background
        angle: 90
        length: 32
        samples: 24
    }

    ColorOverlay {
        anchors.fill: background
        source: background
        color: "#f5f5f5"
        opacity: 0.1
    }

    PlasmaCore.FrameSvgItem {
        height: 400
        width: 400

        imagePath: "asdasdComponents/bg_win"
    }

    Rectangle {
        id: loginArea
        anchors.fill: parent
        color: "transparent"
        visible: primaryScreen

        Image {
            source: "Components/bg_win.svg"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -100

            ColumnLayout {
                id: mainColumn
                anchors.fill: parent

                spacing: 0

                Image {
                    id: logo
                    Layout.topMargin: 78
                    Layout.alignment: Qt.AlignHCenter
                    width: 262
                    height: 128
                    fillMode: Image.PreserveAspectFit
                    source: config.logo
                }

                CustomTextField {
                    id: name
                    KeyNavigation.backtab: loginButton
                    KeyNavigation.tab: password
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 36
                    height: 32
                    text: userModel.lastUser
                    width: 256
                    placeholderText: textConstants.userName

                    Image {
                        source: "Components/user.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: -45
                    }
                }

                CustomPasswordField {
                    id: password
                    KeyNavigation.backtab: name
                    KeyNavigation.tab: loginButton
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 24
                    focus: true
                    height: 32
                    width: 256

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return
                                || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, 0)
                            event.accepted = true
                        }
                    }

                    Image {
                        source: "Components/pass.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: -45
                    }
                }

                Text {
                    id: errorMessage
                    Layout.topMargin: 14
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 256
                    Layout.alignment: Qt.AlignHCenter
                    wrapMode: Text.WordWrap
                    text: ""
                    font.pixelSize: 12
                }

                Image {
                    Layout.topMargin: 14
                    Layout.alignment: Qt.AlignHCenter
                    source: "Components/login_icon.png"
                }

                LoginButton {
                    id: loginButton
                    KeyNavigation.backtab: loginButton
                    KeyNavigation.tab: name
                    Layout.topMargin: 14
                    height: 32
                    text: textConstants.login
                    width: 150
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }
}
