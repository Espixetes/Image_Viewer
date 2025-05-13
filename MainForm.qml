import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.folderlistmodel
import QtCore

Rectangle {
    width: 500
    height: 400
    color: "white"

    Column {
        width: parent.width - 20
        height: parent.height - 20
        x: 10
        y: 10
        spacing: 10

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Select a folder with images"
                onClicked: folderDialog.open()
            }

            ComboBox {
                id: viewSelector
                model: ["List", "Table", "PathView"]
                currentIndex: 0
                onCurrentIndexChanged: {
                    listView.visible = (currentIndex === 0)
                    gridView.visible = (currentIndex === 1)
                    pathView.visible = (currentIndex === 2)
                }
            }
        }

        Text {
            id: folderPathText
            text: "Folder not selected"
            wrapMode: Text.Wrap
            width: parent.width
        }

        FolderListModel {
            id: folderModel
            folder: "file:///home/"
            nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp"]
            showDirs: false
        }

        ListView {
            id: listView
            width: parent.width
            height: parent.height - folderPathText.height - 50
            visible: true
            model: folderModel
            spacing: 10
            clip: true

            delegate: Row {
                spacing: 10
                Image {
                    source: fileUrl
                    width: 100
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            parent.scale = (parent.scale === 1) ? 2 : 1
                        }
                    }
                    Behavior on scale {
                        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                    }
                }
                Text {
                    text: fileName
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        GridView {
            id: gridView
            width: parent.width
            height: parent.height - folderPathText.height - 50
            visible: false
            model: folderModel
            cellWidth: 120
            cellHeight: 120
            clip: true

            delegate: Column {
                Image {
                    source: fileUrl
                    width: 100
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            parent.scale = (parent.scale === 1) ? 2 : 1
                        }
                    }
                    Behavior on scale {
                        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                    }
                }
                Text {
                    text: fileName
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                }
            }
        }

        PathView {
            id: pathView
            width: parent.width
            height: parent.height - folderPathText.height - 50
            visible: false
            model: folderModel
            clip: true

            path: Path {
                startX: 0; startY: pathView.height / 2
                PathArc {
                    x: pathView.width; y: pathView.height / 2
                    radiusX: pathView.width / 2; radiusY: pathView.height / 2
                    useLargeArc: true
                }
                PathArc {
                    x: 0; y: pathView.height / 2
                    radiusX: pathView.width / 2; radiusY: pathView.height / 2
                    useLargeArc: true
                }
            }

            delegate: Image {
                source: fileUrl
                width: 100
                height: 100
                fillMode: Image.PreserveAspectFit
                smooth: true
                scale: PathView.isCurrentItem ? (enlarged ? 2.4 : 1.2) : (enlarged ? 1.6 : 0.8)
                z: PathView.isCurrentItem ? 1 : 0
                property bool enlarged: false
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        parent.enlarged = !parent.enlarged
                    }
                }
                Behavior on scale {
                    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                }
            }
        }

        FolderDialog {
            id: folderDialog
            title: "Select a folder with images"
            currentFolder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
            onAccepted: {
                if (selectedFolder) {
                    folderPathText.text = "Selected folder: " + selectedFolder
                    folderModel.folder = selectedFolder
                }
            }
            onRejected: {
                console.log("Folder selection canceled")
            }
        }
    }
}
