# Elixir + Erlang (slim) base image
FROM elixir:1.18-otp-27-slim

# Accept MIX_ENV at build time (defaults to dev)
ARG MIX_ENV=dev
ENV MIX_ENV=${MIX_ENV}
ENV LANG=C.UTF-8

# Packages needed for Hex/Rebar and compiling deps with NIFs
RUN apt-get update -y && apt-get install -y --no-install-recommends \
  build-essential git wget ca-certificates \
  && update-ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Hex/Rebar without prompts
RUN mix local.hex --force --if-missing && mix local.rebar --force --if-missing

# Use Docker layer caching for deps
COPY mix.exs mix.lock ./
COPY config ./config
RUN mix deps.get --only ${MIX_ENV} && mix deps.compile

# Copy the rest of the app
COPY . .

# Entrypoint to ensure DB is ready and migrations are applied
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Compile the project for the chosen environment
RUN mix compile

# Phoenix default port
EXPOSE 4000

# In all environments, run the entrypoint (runs ecto.setup) then the server
ENTRYPOINT ["./entrypoint.sh"]
CMD ["mix", "phx.server"]