# flutter_base_app

A Flutter base template with clean architecture, BLoC, GetIt, Sentry and more

## 📋 Project Information

- **Created by**: Terraform
- **Created on**: 2025-12-14T12:33:55Z
- **Managed by**: Terraform Infrastructure as Code


## 🏗️ Architecture & Dependencies

This Flutter project follows **Clean Architecture** principles with the following structure:

```
lib/
├── app/                    # App configuration, constants, extensions
│   ├── config/             # Theme, DI setup, environment
│   ├── const/              # App constants, colors, sizes
│   ├── enums/              # Application enums
│   ├── extensions/         # Dart extensions
│   ├── l10n/               # Localization files
│   ├── localization/       # Language management
│   ├── router/             # Navigation/routing
│   └── types/              # Custom types (Result, Failures)
├── data/                   # Data layer
│   ├── data_sources/       # Remote and local data sources
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── features/               # Feature modules
│   ├── app/                # App-wide bloc/providers
│   ├── authentication/     # Auth bloc
│   ├── biometric/          # Biometric authentication
│   ├── login/              # Login feature
│   ├── onboarding/         # Onboarding flow
│   └── splash/             # Splash screen
└── shared/                 # Shared utilities and widgets
assets/
├── images/                 # Image assets
└── icons/                  # Icon assets
```

### Main dependencies by category (see `pubspec.yaml`):

- **State Management:**
	- `flutter_bloc`, `provider`, `rxdart`
- **Routes:**
	- `go_router`
- **Utilities & DI:**
	- `get_it`, `freezed_annotation`
- **Error Monitoring:**
	- `sentry_flutter`
- **Environment Variables:**
	- `envied`
- **JSON Serialization:**
	- `json_annotation`, `json_serializable`
- **Localization:**
	- `flutter_localizations`
- **Testing:**
	- `flutter_test`, `bloc_test`, `mocktail`, `test`
- **Code Generation:**
	- `build_runner`, `freezed`, `envied_generator`

Para más detalles revisa el archivo `pubspec.yaml` generado.

#### Flutter config

El proyecto está configurado para usar material design y soporta assets personalizados. Puedes agregar assets en la sección correspondiente del `pubspec.yaml`.


## 🚀 Getting Started

1. Clone the repository
2. Run `flutter create .` to generate Flutter project files (si es necesario)
3. Run `flutter pub get` to install dependencies
4. (Opcional) Instala lefthook y activa los hooks para asegurar calidad de código y evitar secretos en commits:
	```bash
	# Windows (con Chocolatey)
	choco install lefthook
	# o con npm
	npm install -g lefthook
	# luego
	lefthook install
	```
5. Start coding!

### Git Hooks con Lefthook

Este proyecto utiliza [Lefthook](https://github.com/evilmartians/lefthook) para automatizar tareas de calidad antes de cada commit:

- `analyze`: Ejecuta `flutter analyze` sobre los archivos .dart modificados
- `check-format`: Verifica el formato de los archivos .dart staged
- `secrets-check`: Previene el commit de secretos buscando palabras como `password`, `secret` o `api_key` en archivos sensibles


La configuración se encuentra en el archivo `lefthook.yml` en la raíz del proyecto.

## Reproducible Docker Build & CI/CD

The project uses a reproducible Docker build for Flutter/Android, ensuring consistent APK generation across all environments and seamless integration with CI/CD and Docker Hub.

### Docker Image Features

* Includes Flutter SDK, Android SDK, Java (OpenJDK 17)
* Builds your APK automatically on container run
* Ensures reproducibility and eliminates local environment issues
* Ready for CI/CD and Docker Hub publishing

### Usage (Local)

1. **Build the Docker image locally:**
	```bash
	docker build -t base_flutter_app-builder .
	```
2. **Run the container to generate the APK:**
	```bash
	docker run --rm -v "$PWD":/app base_flutter_app-builder
	```
	The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

### CI/CD Integration & Docker Hub

- The workflow `.github/workflows/docker_publish.yml` builds and pushes the image to Docker Hub on every push to `develop`.
- The workflow `.github/workflows/flutter_ci.yml` (CI/CD): Descarga y ejecuta la imagen Docker publicada en Docker Hub (tag `develop`) para generar el APK, asegurando builds 100% reproducibles.

**Required GitHub Secrets:**

| Secret              | Description                  |
|---------------------|------------------------------|
| `DOCKERHUB_USERNAME`| Docker Hub username          |
| `DOCKERHUB_TOKEN`   | Docker Hub access token/pass |

**Image will be published as:**
`docker pull <DOCKERHUB_USERNAME>/qribar_cocina:latest`

**CI/CD APK build:**
El workflow de CI descarga la imagen Docker y ejecuta el build del APK dentro del contenedor, subiendo el APK como artefacto.

---

## Error Monitoring with Sentry

The application uses [Sentry](https://sentry.io) for error tracking and performance monitoring.

### Configuration

Environment variables are managed via `.env` file using `envied` for type-safe access:

```env
# .env file
SENTRY_DSN=https://your-key@your-org.ingest.sentry.io/your-project-id
SENTRY_ENVIRONMENT=development  # development | staging | production
```

### Environment Types

| Environment | Description |
|-------------|-------------|
| `development` | Local development |
| `staging` | Testing/QA environment |
| `production` | Live production environment |

### Features

* **Automatic error capture:** Flutter errors, BLoC errors, and unhandled exceptions
* **Performance monitoring:** Transaction traces and profiling
* **Environment-based configuration:** Different sample rates for production vs development
* **BLoC context:** Errors include bloc type and state information
* **Obfuscated DSN:** Sensitive credentials are obfuscated in compiled code

### After modifying `.env`

Run the code generator to update environment configuration:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 📄 License

This project is licensed under the MIT License.