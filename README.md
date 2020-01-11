Provides Reveal.js backend for asciidoc presentations.
======================================================

Configuration
=============

-   `SLIDES_PATH` - path to directory inside container with .adoc
    sources. Default value: */documents/slides*

-   `RESOURCES_PATH` - path to directory inside container contains css,
    images and all other resources. Default value:
    *${SLIDES\_PATH}/resources*

-   `TARGET_PATH` - path to directory inside container with compiled
    slides. Default value: */target*

> **Important**
>
> Default configuration assumes directory hierarchy:
>
> -   `<PATH_TO_MAIN_DIR>/slides` - folder with asciidoc sources
>
> -   `<PATH_TO_MAIN_DIR>/slides/resources` - folder with addtional
>     resources such as custom css, images, etc
>
Run it
======

**Run with default config.**

    docker run -it -p 80:80 -v <PATH_TO_MAIN_DIR>:/documents/ wiktorsztajerowski/asciidoc-presenter:latest

Now go to `http://localhost` and enjoy your presentation :)

> **Note**
>
> HTML files are names same as source files, so if you have
> `slides.adoc` you find your slides on `http://localhost/slides.html`

> **Tip**
>
> check container output - it lists the serving files.

Customize run
=============

**Provide custom slides source.**

    docker run -it -p 80:80 -v <PATH_TO_MAIN_DIR>:/documents/ -e SLIDES_PATH=/documents/custom/path/slides wiktorsztajerowski/asciidoc-presenter:latest

**Provide custom resource path.**

    docker run -it -p 80:80 -v <PATH_TO_MAIN_DIR>:/documents/ -e RESOURCES_PATH=/documents/custom/path/to/resources wiktorsztajerowski/asciidoc-presenter:latest

**Getting generates slides.**

    docker run -it -p 80:80 -v <PATH_TO_MAIN_DIR>:/documents/  -v <PATH_TO_TARGET_DIR>:/target wiktorsztajerowski/asciidoc-presenter:latest

**Provide custom target path.**

    docker run -it -p 80:80 -v <PATH_TO_MAIN_DIR>:/documents/  -v <PATH_TO_TARGET_DIR>:/custom/target -e TARGET_PATH=/custom/target wiktorsztajerowski/asciidoc-presenter:latest

Acknowledgments
---------------

Many thanks to the AsciiDoctor team for providing [AsciiDoctor Docker
Image](https://github.com/asciidoctor/docker-asciidoctor), which I used
as a base for this image.
