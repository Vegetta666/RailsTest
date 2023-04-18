# see more things here: https://anonoz.github.io/tech/2018/05/01/rails-dockerfile.html

FROM ruby:2.7-slim-buster AS ruby

ARG USER
ARG UID
ARG GID

ENV APP_USER=$USER \
    APP_DIR=/var/app \
    LANG=en_US.utf8 \
    LC_ALL=C.UTF-8 \
    PORT=3030 \
    TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# Create default user and home directory, set owner
RUN addgroup --gid ${GID} --system ${APP_USER} \
    && adduser --system ${APP_USER} --uid ${UID} --gid ${GID} \
    && mkdir -p ${APP_DIR} \
    && chown -R ${APP_USER}:${APP_USER} ${APP_DIR}

RUN set -ex \
    && apt update && apt -y install \
        ca-certificates \
        curl \
        file \
        git \
        imagemagick \
        libmariadb-dev \
        mariadb-client \
        nodejs \
        pkg-config \
        rsync \
        sqlite3 \
        tzdata \
        shared-mime-info

WORKDIR ${APP_DIR}

ENTRYPOINT [ "docker/entrypoint.sh" ]

EXPOSE 3030
CMD []

#################
# BUILDER IMAGE #
#################

FROM ruby AS base

RUN set -ex \
    && apt update && apt -y install \
        build-essential \
        libc6 \
        libffi-dev \
        libmagickwand-dev \
        musl-dev \
        libsqlite3-dev


#####################
# DEVELOPMENT IMAGE #
#####################

FROM base AS development

ARG UID
ARG GID
ARG USER

ENV RACK_ENV=development \
    RAILS_ENV=development

RUN gem install bundler -v "~> 2.1.4" \
    && chown -R ${UID}:${GID} /usr/local/bundle/

USER ${USER}

################
# ASSETS IMAGE #
################

FROM base AS builder

ARG USER

ENV NODE_ENV=production \
    RACK_ENV=production \
    RAILS_ENV=production \
    # Asset precompilation
    AWS_ACCESS_KEY_ID=dontneed \
    AWS_SECRET_ACCESS_KEY=dontneed \
    DATABASE_URL=mysql2:does_not_exist \
    SECRET_KEY_BASE=nein

USER ${USER}

COPY --chown=${USER}:${USER} Gemfile* ./
COPY --chown=${USER}:${USER} components ./components

# RUN gem update --no-document --system \ need sudo
RUN gem install bundler -v "~> 2.1.4" \
    && bundle config --global frozen 1 \
    && bundle install -j 4 --retry 3 --without development test \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf /usr/local/bundle/cache/*.gem \
    && rm -rf /usr/local/bundle/bundler/gems/*/.git \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# COPY --chown=${USER}:${USER} . .

# RUN PRECOMPILING_ON_DOCKER=1 bundle exec rails assets:precompile

####################
# PRODUCTION IMAGE #
####################

FROM ruby AS production

ARG USER

ENV RACK_ENV=production \
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

USER ${USER}

COPY --from=builder --chown=${USER}:${USER} /usr/local/bundle /usr/local/bundle

COPY --chown=${USER}:${USER} . .

# COPY --from=builder --chown=${USER}:${USER} ${APP_DIR}/public ${APP_DIR}/public
