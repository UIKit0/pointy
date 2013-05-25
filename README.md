pointy
======

Pointy is a Qt/QML implementation of Pinpoint(1). It reads in a simple plain text file, which contains a mark-up-type syntax, and generates a presentation. A notes screen, which displays comments from the text file, and an overview grid window is also generated.

The program is capable of displaying video, images and animated gif files. Commands may also be embedded in a slide, so that a terminal or another program may be launched without leaving the presentation. 

Pointy was developed as a didactic exercise. The graphical interface is implemented in QML on top of Qt/C++, using test driven development (TDD) with QtTest. 

### File Syntax ###

Pointy uses Pinpoint syntax:

        # this is a comment
        # general settings are specified in a header, as follows:
        [fill]             # image fills the slide
        [lightsteelblue]   # fill slides with this colour

        -- # A new slide
        Slide text.

        -- [background_image.png]
        This slide will have an image in the background, provided the 
        named image file is in the executable's path.

        -- [video_file.ogv]
        A video placeholder will appear in the slide, and the video will
        play once Return is pressed.

        -- [command=gvim pin_file.pin]
        See pin_file.pin for more examples

### Known Issues ###

In non-fullscreen mode, flickering was observed during slide fade transitions on KDE using nVidia and Nouveau graphics drivers. This distortion did not occur if desktop effects were switched off (the default shortcut to do this on KDE is Alt-Shift-F12). Pointy exhibited flicker on Gnome-Shell (Fedora 18) with the Nouveau driver, but not with the nVidia driver. No such distortion has been observed, so far, with Intel graphics chips.

### Notes ###

1 Pinpoint, the program that inspired Pointy, is available from  
 
https://live.gnome.org/Pinpoint  

and was developed by the following authors:

Øyvind Kolås, Damien Lespiau, Emmanuele Bassi, Neil Roberts,
Nick Richards, daniel g. siegel, Jussi Kukkonen, Chris Lord,
Will Thompson, Andoni Morales Alastruey, Vladimír Kincl,
Antonio Terceiro, Gary Ching-Pang Lin, Lionel Landwerlin, 
and Christoph Fischer 

