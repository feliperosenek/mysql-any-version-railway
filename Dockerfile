ARG MYSQL_VERSION=8.0.35
FROM mysql:${MYSQL_VERSION}

ENV MYSQL_DATABASE=railway

EXPOSE 3306

RUN echo '[mysqld]' > /etc/mysql/conf.d/custom.cnf && \
    echo 'character-set-server=utf8mb4' >> /etc/mysql/conf.d/custom.cnf && \
    echo 'collation-server=utf8mb4_unicode_ci' >> /etc/mysql/conf.d/custom.cnf && \
    echo 'sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' >> /etc/mysql/conf.d/custom.cnf

COPY docker-entrypoint-custom.sh /usr/local/bin/
RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint-custom.sh && \
    chmod +x /usr/local/bin/docker-entrypoint-custom.sh

ENTRYPOINT ["docker-entrypoint-custom.sh"]
CMD ["mysqld"]
