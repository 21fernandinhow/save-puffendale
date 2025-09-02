# syntax = docker/dockerfile:1

# Use a Ruby slim image oficial
ARG RUBY_VERSION=3.2.9
FROM ruby:$RUBY_VERSION-slim AS base

# Diretório do Rails
WORKDIR /rails

# Instala pacotes essenciais para runtime
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        curl \
        libjemalloc2 \
        libvips \
        postgresql-client \
        nodejs \
        yarn \
        && rm -rf /var/lib/apt/lists/*

# Variáveis de ambiente para produção
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# ----------------------------------------
# Stage de build (para gems e assets)
# ----------------------------------------
FROM base AS build

# Instala pacotes necessários para compilar gems nativas
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential \
        git \
        libpq-dev \
        pkg-config \
        libyaml-dev \
        zlib1g-dev \
        libssl-dev \
        libreadline-dev \
        && rm -rf /var/lib/apt/lists/*

# Copia Gemfile e Gemfile.lock e instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copia o código da aplicação
COPY . .

# Pré-compila bootsnap para acelerar boot
RUN bundle exec bootsnap precompile app/ lib/

# Pré-compila assets
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ----------------------------------------
# Stage final de produção
# ----------------------------------------
FROM base

# Copia gems e aplicação do stage de build
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Cria usuário não-root para rodar a aplicação
RUN groupadd --system --gid 1000 rails && \
    useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash rails && \
    chown -R rails:rails db log storage tmp

USER rails:rails

# Entrypoint prepara o banco
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Porta padrão
EXPOSE 3000

# Comando default
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]