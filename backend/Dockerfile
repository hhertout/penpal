FROM python:3.13-alpine3.21

RUN apk add --no-cache gcc musl-dev libffi-dev rust cargo

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

ENV OTEL_SERVICE_NAME=penpal

CMD ["fastapi", "dev",  "main.py", "--host=0.0.0.0"]