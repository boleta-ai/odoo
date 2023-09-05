FROM python:3.10.1

RUN apt update && \
    apt install libpq-dev \
    gcc \
    wait-for-it \
    python3-pip \
    libldap2-dev \
    libsasl2-dev -y \
    && pip install --upgrade pip

RUN useradd --create-home odoo
USER odoo
WORKDIR /home/odoo/odoo

# Copy
COPY ./requirements.txt /home/odoo/odoo/requirements.txt
RUN pip install -r /home/odoo/odoo/requirements.txt
COPY . /home/odoo/odoo/

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["wait-for-it -h odoo_db -p 5432 --strict --timeout=300 -- \
      /home/odoo/odoo/odoo-bin --config /home/odoo/odoo/odoo.conf"]
