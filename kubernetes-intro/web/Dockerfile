FROM python:3.6.10-alpine3.11
COPY homework.html /app/
RUN addgroup -S appgroup && adduser -S appuser --uid 1001 -G appgroup
USER appuser
EXPOSE 8000
WORKDIR /app
CMD python -m http.server 8000
