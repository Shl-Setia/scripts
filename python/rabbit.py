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
            memberId = row[0];
            #orderNumber = row[0]
            #if tpid != '4':
            #        print 'Wrong TPID!! Ignoring %s' % {tpid}
            #        continue;

            channel.basic_publish(
                exchange='com.expedia.e3.partnerlty.sterling.svs',
                routing_key="",
                properties = pika.BasicProperties(
                    content_type="application/json"
                    ,content_encoding="utf-8"
                    ,headers={ "__KeyTypeId__":  "java.lang.Object" , "__TypeId__": "java.util.HashMap" , "__ContentTypeId__":  "java.lang.Object" }
                ),
                body='{"jobName": "enrollment", "retryCount": "1", "sterlingMembershipId": "%s"}' % (memberId)
            )
            print 'Enroll SVS sent: for  memberId(%s)  }' % (memberId)
            if count < 0:
                    print 'Have More!!!!'
                    break;

print 'Done!'
