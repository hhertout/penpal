FROM python:3.13-alpine3.21

RUN apk add --no-cache gcc musl-dev libffi-dev rust cargo

RUN pip install --no-cache-dir poetry

WORKDIR /app

ENV POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_HOME="/root/.poetry" \
    PATH="/root/.poetry/bin:$PATH" \
    OTEL_SERVICE_NAME=penpal

COPY pyproject.toml .
COPY poetry.lock .

RUN poetry install

ENV PATH="/app/.venv/bin:$PATH"

COPY ./src /app/src

EXPOSE 8000

CMD ["poetry", "run", "fastapi", "dev",  "src/main.py", "--host=0.0.0.0"]