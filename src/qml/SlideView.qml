/*  
 *  This file is part of Pointy.
 *
 *  Copyright (C) 2013 Michael O'Sullivan 
 *
 *  Pointy is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Pointy is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Pointy.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Written by: Michael O'Sullivan
 */


import QtQuick 2.0
import QtQuick.Window 2.0


Rectangle {
    id: mainView;
    width: 1024; height: 576;
    property bool notesVisible: false;
    property bool gridVisible: true;
    property bool horizontalLayout: true;

    signal toggleScreenMode();
    signal quitPointy();
    signal checkFileInfo();
    signal sendCommand(string command);

    Rectangle {
        id: fadeRectangle;
        width: mainView.width; height: mainView.height;
        color: dataView.currentItem.pointyStageColor;
        opacity: 1.0;
    }

    ListView {

        id: dataView;
        focus: true;
        property bool moveForward;
        opacity: 1.0; 

        onActiveFocusChanged: {
            checkFileInfo();
        }

        //interactive: false;
        snapMode: ListView.SnapToItem;
        keyNavigationWraps: true;
        highlightFollowsCurrentItem: true;
        highlightRangeMode: "StrictlyEnforceRange";
        highlightMoveDuration: 0;
        orientation: {
            (mainView.horizontalLayout) ? Qt.Horizontal : Qt.Vertical;
        }

        model: slideShow;

        delegate:
            PointySlide {
            slideWidth: mainView.width;
            slideHeight: mainView.height;

        }




        property int slideCount: count;

        currentIndex: 0;

        Timer {
            id: waitTime;
            interval: 500;
            repeat: false;
        }

        function moveSlide() {
            if (dataView.moveForward === true) {
                dataView.currentIndex +=1 ;
            }
            else if (dataView.moveForward === false) {
                dataView.currentIndex -= 1;
            }
        }

        function loadTransition(pointyTransition) {
            if (dataView.opacity != 0.0 && pointyTransition === "fade") {
                animateFade.start();
            }
            else {
                moveSlide();
            }
        }

        SequentialAnimation  {
            id: animateFade;
            NumberAnimation {
                target: dataView;
                // target: fadeRectangle;
                properties: "opacity";
                easing.type: "InOutQuad";
                from: 1.0; to: 0.0; duration: 400;
            }
            ScriptAction {
                script: {
                    dataView.moveSlide();
                }
            }
            NumberAnimation {
                target: dataView;
                properties: "opacity";
                easing.type: "InOutQuad";
                from: 0.0; to: 1.0; duration: 400;
            }
        }

        ParallelAnimation {
            id: blankScreen;
            NumberAnimation {
                target: dataView;
                properties: "opacity";
                easing.type: "InOutQuad";
                from: 1.0; to: 0.0; duration: 800;
            }
            NumberAnimation {
                target: fadeRectangle;
                properties: "opacity";
                from: 0.0; to: 1.0; duration: 400;
            }
        }

        ParallelAnimation {
            id: revealScreen;
            NumberAnimation {
                target: dataView;
                properties: "opacity";
                from: 0.0; to: 1.0; duration: 800;
            }
            NumberAnimation {
                target: fadeRectangle;
                properties: "opacity";
                from: 1.0; to: 0.0; duration: 800;
            }
        }

        function toggleScreenBlank() {
            if (dataView.opacity != 0.0) {
                blankScreen.start();
            }
            else {
                revealScreen.start();
            }
        }


        MouseArea {
            id: mouseArea;
            anchors.fill: parent;
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if (mouse.button === Qt.LeftButton) {
                    console.log("Left!")
                }
                else {
                    console.log("Right")
                }
            }
        }

        function toggleWindow(windowId) {
            if (windowId.visible === true) {
                windowId.visible = false;
            }
            else {
                windowId.show();
            }

        }



        Keys.onPressed: {
            if (event.key === Qt.Key_Space && (currentIndex < slideCount -1)) {
                dataView.moveForward = true;
                loadTransition(dataView.currentItem.pointyTransition);

                //currentIndex += 1;
            }

            else if (event.key === Qt.Key_Backspace && currentIndex > 0) {
                dataView.moveForward = false;
                loadTransition(dataView.currentItem.pointyTransition);
                //currentIndex -=1;
            }

            else if (event.key === Qt.Key_Return &&
                                dataView.currentItem.isMediaSlide === true ) {
                dataView.currentItem.mediaSignal();
            }

            else if (event.key === Qt.Key_Return &&
                                dataView.currentItem.isCommandSlide === true ) {
                console.log("sending ", currentItem.commandOut);
                dataView.currentItem.mediaSignal();
                mainView.sendCommand(currentItem.commandOut);
            }


            if (event.key === Qt.Key_Less &&
                    dataView.currentItem.isMediaSlide === true ) {
                dataView.currentItem.backMedia();
            }
            else if (event.key === Qt.Key_Greater &&
                     dataView.currentItem.isMediaSlide === true ) {
                dataView.currentItem.forwardMedia();

            }




            else if (event.key === Qt.Key_F ||
                     event.key === Qt.Key_F11 ) {
                toggleScreenMode();
            }
            else if (event.key === Qt.Key_Q ||
                     event.key === Qt.Key_Escape) {
                quitPointy();
            }
            else if (event.key === Qt.Key_B) {
                toggleScreenBlank();
            }
            else if (event.key === Qt.Key_N) {
                toggleWindow(notesTextWindow);
            }
            else if (event.key === Qt.Key_G) {
                toggleWindow(gridViewWindow);
            }
        }

    } // ListView

    Window {
        id: notesTextWindow;
        width: 400; height: 300;

        title: "Pointy Notes"
        visible: mainView.notesVisible;

        Text {
            focus: true;
            anchors.fill: parent
            anchors.margins: parent.height * 0.1;

            font.pixelSize: 50
            wrapMode: Text.WordWrap

            property string notes: dataView.currentItem.pointyNotes;
            text: notes == "" ? "This slide has no notes." : notes;
            font.italic: notes == "";

            Keys.onPressed: {
                if (event.key === Qt.Key_N) {
                    if (notesTextWindow.visible === true )
                    {
                        notesTextWindow.visible = false;
                    }
                }
            }
        }
    } // Window (notesTextWindow)

    Window {
        id: gridViewWindow;
        width: 400; height: 300;

        title: "Pointy Grid View"
        visible: mainView.gridVisible;

        GridView {
            id: gridView;
            model: slideShow;
            focus: true;
            width: parent.width; height: parent.height;
            currentIndex: dataView.currentIndex;
            snapMode: GridView.SnapToRow;

            cellWidth: {width/2;}
            cellHeight: {height/2;}

            delegate: PointySlide {
                width: {gridView.cellWidth - 5}
                height: {gridView.cellHeight - 5}
                slideWidth: width;
                slideHeight: height;
                scaleFactor: {
                    width/mainView.width;
                }
                MouseArea {
                    id: mouseGridArea;
                    anchors.fill: parent;
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if (mouse.button === Qt.LeftButton) {
                            // index role is available to delegate
                            dataView.currentIndex = index;
                        }
                        else {
                            console.log("Right")
                        }
                    }
                }
            }

            highlight: Rectangle {
                border.color: "#ffae00"
                color: "transparent";
                opacity: 1.0;
                border.width: 1;
                radius: 2;

                width: gridView.cellWidth;
                height: gridView.cellHeight;
                x: gridView.currentItem.x;
                y: gridView.currentItem.y;
                z: {gridView.currentItem.z + 1;}    // put highlight on top
                Rectangle {
                    width: parent.width;
                    height: parent.height;
                    opacity: 0.2;
                    color: "gold";
                    radius: parent.radius;
                }

            }


            Keys.onPressed: {
                if (event.key === Qt.Key_G) {
                    if (gridViewWindow.visible === true )
                    {
                        gridViewWindow.visible = false;
                    }
                }
                if (event.key === Qt.Key_Return) {
                    dataView.currentIndex = currentIndex;
                }
            }
            highlightFollowsCurrentItem: true;
            highlightMoveDuration: 0;

        }
    }


} // Rectangle


