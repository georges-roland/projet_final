FROM python:3.6-alpine
WORKDIR /opt
RUN pip install --no-cache-dir Flask==2.0.3
COPY . /opt/
EXPOSE 8080
ENV ODOO_URL=""
ENV PGADMIN_URL=""
# Au build : extraction des valeurs de releases.txt avec awk
RUN awk '/^ODOO_URL/ {print $2}' releases.txt > /opt/.odoo_url && \
    awk '/^PGADMIN_URL/ {print $2}' releases.txt > /opt/.pgadmin_url
# Au démarrage : export (une variable passée avec -e garde la priorité)
ENTRYPOINT ["/bin/sh", "-c", "export ODOO_URL=${ODOO_URL:-$(cat /opt/.odoo_url)} PGADMIN_URL=${PGADMIN_URL:-$(cat /opt/.pgadmin_url)}; exec python app.py"]
