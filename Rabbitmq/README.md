<h1>Rabbitmq</h1>

rabbitmq1 </br>
rabbitmq2 </br>
rabbitmq3 </br> 
3개로 clustering
</br></br>
.env </br>
<administrator tag 가진 기본 호스트 아이디 비밀번호 설정></br>
아이디 : mk</br>
비밀먼호 : 1234</br>
</br></br>
cluster-entrypoint.sh </br>
권한 설정 및 rabbitmq-server 실행 </br>
join_cluster 설정</br>
docker compose up 에서 문제 발생시 해당 파일 직접 작성 필요
</br></br>
haproxy.cfg</br>
로드밸런싱 정보</br>
rabbitmq 설정 위해 5672, 15672 포트 3개의 서버로 </br>
1936은 haproxy 정보 ui port</br>
</br></br>
.erlang.cookie</br>
임의로 12345 값 삽입.</br>
</br></br>
haproxy.tar</br>
haproxy:1.7 도커 이미지</br>
</br></br>
rabbitmq_*.tar</br>
해당 버전의 rabbitmq 도커 이미지</br>
