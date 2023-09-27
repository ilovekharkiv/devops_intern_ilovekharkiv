FROM python:3.11

WORKDIR /app

COPY . .

RUN pip3 install -r requirements.txt

RUN chmod +x ./start.sh

EXPOSE $PORT_BACKEND

CMD ["./start.sh"]
