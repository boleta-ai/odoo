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
WORKDIR /home/odoo/odoo

# Copy
COPY ./custom_requirements.txt /home/odoo/odoo/custom_requirements.txt
RUN pip install -r /home/odoo/odoo/custom_requirements.txt
COPY . /home/odoo/odoo/
RUN chown -R 1000:1000 /home/odoo/odoo/data_dir
USER odoo

# Create custom data dir
RUN mkdir -p /tmp/path_zip/original_files
RUN mkdir -p /tmp/path_xml/original_files
RUN mkdir -p /tmp/path_txt/original_files
RUN mkdir -p /tmp/path_xml/summary_files

# Clean old data
RUN rm -rf /tmp/path_zip/original_files/*
RUN rm -rf /tmp/path_xml/summary_files/*
RUN rm -rf /tmp/path_txt/original_files/*

# Up application
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["wait-for-it -h odoo_db -p 5432 --strict --timeout=300 -- \
      /home/odoo/odoo/odoo-bin --config /home/odoo/odoo/odoo.conf -u boleta_ai"]
