Rabbitmq

rabbitmq1
rabbitmq2
rabbitmq3 
3개로 clustering

.env 
<administrator tag 가진 기본 호스트 아이디 비밀번호 설정>
아이디 : mk
비밀먼호 : 1234

cluster-entrypoint.sh 
권한 설정 및 rabbitmq-server 실행 
join_cluster 설정

haproxy.cfg
로드밸런싱 정보
rabbitmq 설정 위해 5672, 15672 포트 3개의 서버로 
1936은 haproxy 정보 ui port

.erlang.cookie
임의로 12345 값 삽입.

haproxy.tar
haproxy:1.7 도커 이미지

rabbitmq_*.tar
해당 버전의 rabbitmq 도커 이미지
