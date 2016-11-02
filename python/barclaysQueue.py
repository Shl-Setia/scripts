import pika
import csv
import logging

#logging.basicConfig()
print 'Connecting to rabbitmq'
#connection = pika.BlockingConnection(pika.ConnectionParameters(host='che-jvasec01', virtual_host="/sterling"))
connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost', virtual_host="/sterling"))
channel = connection.channel()

print 'Parsing and issuing messages'
with open("svsEnroll.csv") as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    count = 50000;
    for row in reader:
            count = count - 1;
            if count > 50000:
                  #print 'Skipping transaction'
                  continue;
            transactionId = row[0];
            transactionEventId = row[1];

            channel.basic_publish(
                exchange='',
                routing_key='com.expedia.e3.partnerlty.sterling.barclays.delay',
                properties = pika.BasicProperties(
                    content_type="application/json"
                    ,content_encoding="utf-8"
                    ,headers={ "__KeyTypeId__":  "java.lang.Object" , "__TypeId__": "java.util.HashMap" , "__ContentTypeId__":  "java.lang.Object" }
                ),
                body='{"jobName":"publishEvents","retryCount":1,"transactionEventId": 3000000001334660,"transactionId":3000000000475388}'
            )
            print 'Barclays event published';
            if count < 0:
                    print 'Have More!!!!'
                    break;

print 'Done!'
