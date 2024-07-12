# Base image
FROM python:3.10-slim

# Environment variables
ENV ODOO_VERSION=17.0 \
    ODOO_USER=odoo \
    ODOO_HOME=/home/odoo \
    ODOO_CONF=/home/odoo/odoo.conf \
    ODOO_LOG=/var/log/odoo \
    PG_VERSION=13

# Install dependencies
RUN apt-get update && apt install -y build-essential wget git nodejs npm python3 python3-pip python3-dev python3-venv python3-wheel libfreetype6-dev libxml2-dev libzip-dev libsasl2-dev python3-setuptools libjpeg-dev zlib1g-dev libpq-dev libxslt1-dev libldap2-dev libtiff5-dev libopenjp2-7-dev
RUN npm install -g less less-plugin-clean-css

# Clone Odoo repository
# RUN git clone --depth 1 --branch $ODOO_VERSION --single-branch https://github.com/odoo/odoo.git $ODOO_HOME

#Copy Odoo source code to the image
COPY . $ODOO_HOME

# Set up Python virtual environment
RUN python3 -m venv $ODOO_HOME/venv
RUN $ODOO_HOME/venv/bin/pip install -r $ODOO_HOME/requirements.txt

# Create Odoo configuration file
RUN mkdir -p $ODOO_LOG && touch $ODOO_CONF

RUN echo "[options]\n" \
    "addons_path = /home/odoo/addons,/home/odoo/custom_addons\n" \
    "admin_passwd = admin\n" \
    "db_host = srv-captain--odoo-db\n" \
    "db_port = 5432\n" \
    "db_user = odoo\n" \
    "db_password = Kathmandu123\n" \
    "logfile = /var/log/odoo/odoo.log\n" \
    "dev_mode = True\n" \
    > $ODOO_CONF


# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose Odoo port
EXPOSE 8069

# Run Odoo
# CMD ["sh", "-c", "$ODOO_HOME/venv/bin/python $ODOO_HOME/odoo-bin -c $ODOO_CONF"]
ENTRYPOINT ["/entrypoint.sh"]
