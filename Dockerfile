FROM python:3.8-slim-buster
ARG YOUR_ENV

ENV YOUR_ENV=${YOUR_ENV} \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.3.2

WORKDIR /app
COPY ./requirements.txt /requirements.txt
COPY poetry.lock pyproject.toml /app/

RUN pip install "poetry==$POETRY_VERSION"
RUN poetry config virtualenvs.create false \
  && poetry install --no-dev --no-interaction --no-ansi

COPY . .
CMD ["python", "src/main.py"]