# Dockerfile for reproducible Flutter/Android builds
FROM ghcr.io/cirruslabs/flutter:stable

USER root

# 1. Definimos las variables de entorno PRIMERO.
# Esto nos permite usarlas en el siguiente bloque RUN gigante sin romper nada.
ENV ANDROID_SDK_ROOT=/opt/android-sdk \
    PATH="$PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/emulator"

# 2. BLOQUE DEL SISTEMA (System Setup)
# Aquí fusionamos: Git config + Apt install + Android SDK Setup
# Todo esto ocurrirá en UNA SOLA capa de Docker.
RUN git config --global --add safe.directory '*' && \
    apt-get update && \
    apt-get install -y openjdk-17-jdk wget unzip && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    cd $ANDROID_SDK_ROOT/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip && \
    unzip -q cmdline-tools.zip && \
    mv cmdline-tools latest && \
    rm cmdline-tools.zip && \
    yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

WORKDIR /app
COPY . .

# 3. BLOQUE DE CONSTRUCCIÓN (Build & Security)
ARG SENTRY_DSN_ARG

# Fusionamos: Creación de secretos + Build + Limpieza + Permisos
# Esto es CRÍTICO por seguridad: al hacerlo en un solo RUN, el archivo .env
# nunca se confirma en el historial de capas de la imagen (se crea y borra en el mismo paso).
RUN echo "SENTRY_DSN=$SENTRY_DSN_ARG" > .env && \
    echo "sentryDsn=$SENTRY_DSN_ARG" >> .env && \
    flutter pub get && \
    flutter pub run build_runner build --delete-conflicting-outputs && \
    rm .env && \
    chmod +x ./build_apk.sh

ENTRYPOINT ["bash", "./build_apk.sh"]
