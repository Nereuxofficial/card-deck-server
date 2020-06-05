FROM python:3.8.3-slim

# Install needed packages
RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get autoclean
RUN apt-get install -y python3 python3-pip pipenv nginx vim mysql-client libmysqlclient-dev
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy everything to the container
RUN mkdir -p /app/static
COPY . /app/
COPY default.conf /etc/nginx/sites-available/default
WORKDIR /app/

# Install python requirements
RUN pipenv lock --requirements > requirements.txt
RUN pip install -r requirements.txt

RUN chown -R www-data:www-data /app/
VOLUME ["/app/static"]

# Start the server
EXPOSE 8000
STOPSIGNAL SIGTERM
CMD ["/app/entrypoint.sh"]