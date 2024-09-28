"""
Django settings for project.
"""

import environ
from corsheaders.defaults import default_headers

from .env import *

BASE_DIR = Path(__file__).resolve().parent.parent

# Initialise environment variables
env = environ.Env()
environ.Env.read_env()

# SECURITY Settings
SECRET_KEY = env.str("SECRET_KEY")
DEBUG = env.bool("DEBUG", default=False)
ALLOWED_HOSTS = env.list("ALLOWED_HOSTS", default=["*"])
CSRF_TRUSTED_ORIGINS = env.list("CSRF_TRUSTED_ORIGINS", default=[])

SITE_ID = 1

# Database Settings
DATABASES = {"default": env.db("DATABASE_URL")}
DEFAULT_AUTO_FIELD = "django.db.models.AutoField"

# CORS Settings
CORS_ALLOW_ALL_ORIGINS = env("CORS_ALLOW_ALL_ORIGINS", default=True)
CORS_ALLOWED_ORIGINS = env.list("CORS_ALLOWED_ORIGINS", default=[])
CORS_ALLOW_HEADERS = list(default_headers) + [
    "ngrok-skip-browser-warning",
]

# Environment
ENVIRONMENT_NAME = env.str("ENVIRONMENT_NAME")
ENVIRONMENT_COLOR = env.str("ENVIRONMENT_COLOR")

# Apps
INSTALLED_APPS = [
    # Django
    "django_admin_env_notice",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    # Packages
    "corsheaders",
    "django_celery_beat",
    "django_filters",
    "drf_yasg",
    "import_export",
    "import_export_celery",
    "rest_framework",
    "rest_framework_simplejwt",
    # Project
    "apps.exports",
    "apps.users",
]

AUTH_USER_MODEL = "users.User"

# Middleware
MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

# URLS
ROOT_URLCONF = "app.urls"

# Templates
TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
                "django_admin_env_notice.context_processors.from_settings",
            ],
        },
    },
]

WSGI_APPLICATION = "app.wsgi.application"

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]

# Internationalization Settings
LANGUAGE_CODE = env.str("LANGUAGE_CODE", default="es-mx")
TIME_ZONE = env.str("TIME_ZONE", default="America/Mexico_City")
USE_I18N = env.bool("USE_I18N", default=True)
USE_L10N = env.bool("USE_L10N", default=True)
USE_TZ = env.bool("USE_TZ", default=True)

# Rest Framework Settings
REST_FRAMEWORK = {
    "DEFAULT_FILTER_BACKENDS": [
        "django_filters.rest_framework.DjangoFilterBackend",
        "rest_framework.filters.SearchFilter",
    ],
    "DEFAULT_SCHEMA_CLASS": "rest_framework.schemas.coreapi.AutoSchema",
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework.authentication.SessionAuthentication",
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
    "DEFAULT_PERMISSION_CLASSES": ("rest_framework.permissions.IsAuthenticated",),
    "DEFAULT_PAGINATION_CLASS": "base.pagination.AppPagination",
    "PAGE_SIZE": 100,
    # Date Time Formats
    "DATE_FORMAT": "%d/%m/%Y",
    "DATE_INPUT_FORMATS": ["iso-8601", "%d/%m/%Y", "%d-%m-%Y"],
    "USER_ID_FIELD": "uuid",
}

# Banner data
ENVIRONMENT_FLOAT = True

# Sentry Config
USE_SENTRY = env.bool("USE_SENTRY", default=False)
if USE_SENTRY:
    try:
        import sentry_sdk
        from sentry_sdk.integrations.django import DjangoIntegration

        sentry_sdk.init(
            environment=env.str("ENVIRONMENT_NAME", default=""),
            dsn=env.str("SENTRY_DSN", default=""),
            integrations=[
                DjangoIntegration(),
            ],
            traces_sample_rate=0.1,
            send_default_pii=True,
        )
    except Exception as e:
        print("====================")
        print("Couldn't initialize sentry")
        print(e)
        print("====================")

# Project
PROJECT_NAME = env.str("PROJECT_NAME", default="Project Name")

# Frontend Domain
FRONTEND_DOMAIN = env.str("FRONTEND_DOMAIN", default="https://example.com")
FRONTEND_RESET_PASSWORD_PATH = env.str("FRONTEND_RESET_PASSWORD_PATH", default="/auth/reset-password")

# Twilio
TWILIO_ACCOUNT_SID = env.str("TWILIO_ACCOUNT_SID", default="")
TWILIO_AUTH_TOKEN = env.str("TWILIO_AUTH_TOKEN", default="")

# Pusher
PUSHER_APP_ID = env.str("PUSHER_APP_ID", default="")
PUSHER_KEY = env.str("PUSHER_KEY", default="")
PUSHER_SECRET = env.str("PUSHER_SECRET", default="")

# Celery
CELERY_RESULT_BACKEND = env.str("REDIS_HOST", default="redis://127.0.0.1:6379")
CELERY_BROKER_URL = env.str("REDIS_HOST", default="redis://127.0.0.1:6379")
CELERY_ACCEPT_CONTENT = ["application/json"]
CELERY_RESULT_SERIALIZER = "json"
CELERY_TASK_SERIALIZER = "json"

# Celery Beat
CELERY_BEAT_SCHEDULE = {}

# Import Export Celery
IMPORT_EXPORT_CELERY_INIT_MODULE = "app.celery"
IMPORT_EXPORT_CELERY_STORAGE = ""
IMPORT_EXPORT_CELERY_MODELS = {}
IMPORT_DRY_RUN_FIRST_TIME = False
