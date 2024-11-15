FROM python:3.11.0b1-buster

# set work directory
WORKDIR /app


# dependencies for psycopg2
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libbind9-161=1:9.11.5.P4+dfsg-5.1+deb10u11 \
    libdns1104=1:9.11.5.P4+dfsg-5.1+deb10u11 \
    libisc1100=1:9.11.5.P4+dfsg-5.1+deb10u11 \
    libisccfg163=1:9.11.5.P4+dfsg-5.1+deb10u11 \
    liblwres161=1:9.11.5.P4+dfsg-5.1+deb10u11 \
 && apt-get install -y dnsutils=1:9.11.5.P4+dfsg-5.1+deb10u11 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


# Install dependencies
RUN python -m pip install --no-cache-dir pip==22.0.4
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


# copy project
COPY . /app/


# install pygoat
EXPOSE 8000


RUN python3 /app/manage.py migrate
WORKDIR /app/pygoat/
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers","6", "pygoat.wsgi"]
