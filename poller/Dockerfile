FROM python:3.9-slim

# Upgrade pip and set timeout/retry options
RUN pip install --upgrade pip

# Install packages separately with increased timeout and retries
RUN pip install --timeout=1000 --retries=5 ibm_db==3.2.3
RUN pip install --timeout=1000 --retries=5 psycopg2-binary==2.9.9
WORKDIR /app
COPY bot_poller.py .
CMD ["python", "bot_poller.py"]