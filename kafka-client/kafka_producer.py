from kafka import KafkaProducer
import json 
import random 
import time 

producer = KafkaProducer(bootstrap_servers='kafka:9092', value_serializer=lambda v: json.dumps(v).encode('utf-8'))

def get_rnd_user() : 
    user = {}
    user['userId'] = random.randint(1, 10000)
    user['movieId'] = random.randint(1, 100)
    user['rating'] = random.randint(1, 5) 
    return user

def rate() : 
    while True : 
        future = producer.send('messages', get_rnd_user())
        result = future.get(timeout=60)
        time.sleep(1)
rate()
