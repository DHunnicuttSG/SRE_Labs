FROM python:3.12-slim

WORKDIR /app

RUN pip install requests

COPY evaluator.py .

CMD ["python","evaluator.py"]