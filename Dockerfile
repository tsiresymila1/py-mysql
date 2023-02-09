FROM mysql:5.7.41-debian 
LABEL key="value"
RUN apt-get -y update && apt-get install -y build-essential libreadline-gplv2-dev libncursesw5-dev \
     libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev  wget nodejs  npm
RUN apt-get -y install curl 

WORKDIR  /root

RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
RUN tar -xvf Python-3.10.0.tgz

WORKDIR  /root/Python-3.10.0 
RUN ./configure --enable-optimizations

RUN make -j 2

RUN make install

RUN python3.10 -V

RUN curl -sSL https://install.python-poetry.org | python3.10 -

RUN cp /root/.local/bin/poetry /usr/bin/poetry 


WORKDIR /app

COPY . .

RUN poetry config virtualenvs.create false 

WORKDIR /app/py_mysql

RUN poetry install  --no-dev 

EXPOSE 80


ENTRYPOINT ["uvicorn", "app:app", "--host=0.0.0.0","--port=80","--reload"]




