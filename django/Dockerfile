FROM python:3.10-alpine
ENV PYTHONBUFFERED = 1
RUN mkdir /app

WORKDIR /app
COPY requirements.txt ./

# run this before copying requirements for cache efficiency
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir -r /app/requirements.txt
COPY . /app/
CMD python manage.py runserver 0.0.0.0:8000
EXPOSE 8000
