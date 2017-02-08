import QtQuick 2.0

Item {
    id: clock
    width: childrenRect.width
    height: childrenRect.height

    property int hours
    property int minutes
    property int seconds
    property real shift
    property bool night: false
    property bool internationalTime: true //Unset for local time

    function timeChanged() {
        var date = new Date
        hours = internationalTime ? date.getUTCHours() + Math.floor(
                                        clock.shift) : date.getHours()
        night = (hours < 7 || hours > 19)
        minutes = internationalTime ? date.getUTCMinutes(
                                          ) + ((clock.shift % 1) * 60) : date.getMinutes()
        seconds = date.getUTCSeconds()
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: clock.timeChanged()
    }

    Item {
        width: background.width
        height: background.height

        Image {
            id: background
            source: "artwork/clock_back.svgz"
        }

        Image {
            anchors.horizontalCenter: background.horizontalCenter
            anchors.top: background.verticalCenter
            anchors.topMargin: -5
            source: "artwork/clock_sec.svgz"
            transform: Rotation {
                id: secondRotation
                origin.x: 6
                origin.y: 5
                angle: clock.seconds * 6 + 180
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        modulus: 360
                    }
                }
            }
        }

        Image {
            anchors.horizontalCenter: background.horizontalCenter
            anchors.top: background.verticalCenter
            anchors.topMargin: -5
            source: "artwork/clock_min.svgz"
            transform: Rotation {
                id: minuteRotation
                origin.x: 6
                origin.y: 5
                angle: clock.minutes * 6 + 180
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        modulus: 360
                    }
                }
            }
        }

        Image {
            anchors.horizontalCenter: background.horizontalCenter
            anchors.top: background.verticalCenter
            anchors.topMargin: -5
            source: "artwork/clock_hour.svgz"
            transform: Rotation {
                id: hourRotation
                origin.x: 6
                origin.y: 5
                angle: (clock.hours * 30) + (clock.minutes * 0.5) + 180
                Behavior on angle {
                    SpringAnimation {
                        spring: 2
                        damping: 0.2
                        modulus: 360
                    }
                }
            }
        }
    }
}
