from livereload import Server
from invoke import task
import os

TARGET_SLIDES = os.getenv('TARGET_PATH')
RESOURCES_SRC = os.getenv('RESOURCES_PATH')
SLIDES_SRC = os.getenv('SLIDES_PATH')


@task
def init(c):
    if not os.path.isdir(f"{TARGET_SLIDES}"):
        os.makedirs(f"{TARGET_SLIDES}")
    c.run(f"cp -r /revealjs/ {TARGET_SLIDES}")


@task
def clean(c):
    c.run(f"rm -rf {TARGET_SLIDES}/*")


@task(init)
def copy_resources(c):
    if os.path.isdir(f"{RESOURCES_SRC}"):
        c.run(f"cp -r --remove-destination {RESOURCES_SRC}/* {TARGET_SLIDES}")


@task(copy_resources)
def render_slides(c):
    c.run(f"asciidoctor-revealjs -a revealjsdir=revealjs -r asciidoctor-diagram -D {TARGET_SLIDES} {SLIDES_SRC}/*.adoc  --trace")
    files = os.listdir(f"{TARGET_SLIDES}")
    for file in files:
        if file.endswith(".html"):
            print("Serving file: http://localhost/" + file)

@task(render_slides)
def livereload(c):
    server = Server()
    server.watch(f"{SLIDES_SRC}/*.adoc", lambda: render_slides(c))
    server.watch(f"{RESOURCES_SRC}/**/*", lambda: copy_resources(c))
    server.watch(f"{RESOURCES_SRC}/*", lambda: copy_resources(c))
    server.serve(root=f"{TARGET_SLIDES}", open_url_delay=1, host='0.0.0.0', port=80)
