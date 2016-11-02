import pika
import csv

print 'Connecting to rabbitmq'
connection = pika.BlockingConnection(pika.ConnectionParameters(host='che-jvasec01', virtual_host="/sterlingRewards"))
channel = connection.channel()

print 'Parsing and issuing messages'
with open("svs-missing-members.csv") as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for row in reader:
            memberId = row[0];

            channel.basic_publish(
                exchange='com.expedia.e3.partnerlty.sterling.svs',
                routing_key="",
                properties = pika.BasicProperties(
                    content_type="application/json"
                    ,content_encoding="utf-8"
                    ,headers={ "__KeyTypeId__":  "java.lang.Object" , "__TypeId__": "java.util.HashMap" , "__ContentTypeId__":  "java.lang.Object" }
                ),
                body='{"sterlingMembershipId": %s, "retryCount": "1", "jobName": "enrollment" }' % (memberId)
            )
            print 'Rescore sent: for sterlingMembershipId(%s)' % (memberId)
print 'Done!'
