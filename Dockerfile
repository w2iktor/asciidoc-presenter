FROM alpine:3.10

LABEL MAINTAINERS="Wiktor Sztajerowski <wiktor.sztajerowski@gmail.com>"

ARG asciidoctor_revealjs_version=2.0.0
ARG asciidoctor_diagram_version=1.5.19
ARG revealjs_version=3.8.0
ARG revealjs_version_sha=f04ad6a1f727de19c9c1c0cc72deac120067de6e

ENV ASCIIDOCTOR_REVEALJS_VERSION=${asciidoctor_revealjs_version} \
    ASCIIDOCTOR_DIAGRAM_VERSION=${asciidoctor_diagram_version} \
    REVEALJS_VERSION=${revealjs_version} \
    REVEAL_JS_REPO=https://github.com/hakimel/reveal.js \
    REVEAL_JS_SHA=${revealjs_version_sha}

# Installing package required for the runtime of
# any of the asciidoctor-* functionnalities
RUN apk add --no-cache \
    curl \
    ca-certificates \
    findutils \
    font-bakoma-ttf \
    graphviz \
    make \
    openjdk8-jre \
    python3 \
    python2 \
    py3-pillow \
    py3-setuptools \
    ruby \
    ruby-mathematical \
    ruby-rake \
    ttf-liberation \
    ttf-dejavu \
    tzdata \
    unzip \
    bash

# Installing Ruby Gems needed in the image
# including asciidoctor itself
RUN apk add --no-cache --virtual .rubymakedepends \
    build-base \
    libxml2-dev \
    ruby-dev \
  && gem install --no-document \
    asciimath \
    "asciidoctor-revealjs:${ASCIIDOCTOR_REVEALJS_VERSION}" \
    "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}" \
    coderay \
    rouge \
    slim \
    pygments.rb \
    thread_safe \
    tilt \
  && apk del -r --no-cache .rubymakedepends

# Installing Python dependencies for additional
# functionnalities as diagrams or syntax highligthing
RUN apk add --no-cache --virtual .pythonmakedepends \
    build-base \
    python3-dev \
    py3-pip \
  && pip3 install --no-cache-dir \
    livereload \
    invoke \
    actdiag \
    'blockdiag[pdf]' \
    nwdiag \
    seqdiag \
  && apk del -r --no-cache .pythonmakedepends

# Installing RevealJS
RUN curl -o /tmp/reveal.js.tar.gz -sSL $REVEAL_JS_REPO/archive/$REVEALJS_VERSION.tar.gz \
  && echo "$REVEAL_JS_SHA  /tmp/reveal.js.tar.gz" | sha1sum -c - \
  && tar -xzf /tmp/reveal.js.tar.gz -C / \
  && rm -f /tmp/reveal.js.tar.gz \
  && mv /reveal.js-$REVEALJS_VERSION /revealjs

# Setting default target and slides paths
ENV TARGET_PATH=/target \
    SLIDES_PATH=/documents/slides

# Setting default resource path relative to slides path
ENV RESOURCES_PATH=${SLIDES_PATH}/resources

EXPOSE 80

RUN mkdir /livereload

COPY tasks.py /livereload

VOLUME /documents
WORKDIR /livereload

CMD ["invoke", "livereload"]
