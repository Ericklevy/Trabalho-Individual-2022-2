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


RUN pip install "poetry==$POETRY_VERSION"

WORKDIR /app
COPY poetry.lock pyproject.toml /app/


RUN poetry config virtualenvs.create false \
  && poetry install --no-dev --no-interaction --no-ansi
  
RUN apt update -y
RUN apt-get install python3-sphinx -y
RUN apt-get install doxygen sphinx-common -y

RUN doxygen doxygen.conf -y
RUN sphinx-build -b html docs/source docs/build


COPY . .
CMD ["python", "src/main.py"]