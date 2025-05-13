import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls

Window
{
    visible: true
    width: 900
    height: 700
    title: qsTr("Hello World")

    MainForm {
       anchors.fill: parent
    }
}
