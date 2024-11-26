Docker 
 : Docker는 컨테이너 기반의 가상화 소프트웨어로, 애플리케이션을 컨테이너라는 가상 환경 안에서 실행합니다. 이를 통해 애플리케이션의 독립성, 이식성, 확장성을 높일 수 있습니다.
 - VM과 차이 : VM, 즉 가상 머신과 Docker의 차이점을 설명하자면 다음과 같습니다. 가상 머신은 하드웨어 수준에서의 가상화를 통해 각각의 VM이 독립적인 운영 체제와 하드웨어 리소스를 사용하는 반면, Docker는 운영 체제 수준에서의 가상화를 통해 애플리케이션을 컨테이너 안에서 실행합니다. 이는 Docker가 더 적은 시스템 리소스를 사용하고, 더 빠르게 시작할 수 있는 이유입니다. Docker는 가볍고 효율적이며, 여러 컨테이너를 하나의 호스트 운영 체제에서 실행할 수 있습니다.
 - 장점 : 첫째, 빠른 배포가 가능하여 개발에서 테스트, 프로덕션까지 일관된 환경을 유지할 수 있습니다.
		둘째, 리소스 효율성이 높아 VM보다 더 적은 리소스를 사용합니다.
		셋째, 확장성이 뛰어나 필요에 따라 쉽게 확장할 수 있습니다
 - 단점 : 초기 설정이 복잡합니다.


<해당예시는 Rabbitmq 도커 설치 예시이며 ubuntu-22.04.5-live-server-amd64 default설치(Install OpenSSH server) 환경에서 작성되었습니다.> 

1. VM에 Docker 설치 방법

	1-1. 인터넷 환경에서 Docker 설치 파일을 준비한다

		Docker
		https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/
		or https://github.com/7fsikMinQ/Docker_

		위 링크에서 아래 deb 파일 다운받는다 
		containerd.io_1.7.23-1_amd64
		docker-buildx-plugin_0.17.1-1~ubuntu.22.04~jammy_amd64
		docker-ce_27.3.1-1~ubuntu.22.04~jammy_amd64
		docker-ce-cli_27.3.1-1~ubuntu.22.04~jammy_amd64
		docker-compose-plugin_2.29.7-1~ubuntu.22.04~jammy_amd64
		docker-scan-plugin_0.23.0~ubuntu-jammy_amd64


	1-2. 도커를 사용할 폐쇄망 서버로 다운받은 파일을 이동한다.

		아래 명령어를 사용해 deb 파일 설치
		sudo dpkg -i [파일명].deb

		순서설치 순서
		containerd.io
		docker-ce
		docker-ce-cli
		docker-compose-plugin 


	1-3 설치가 완료되면 아래 명령어를 통해 도커 버전을 확인한다.

		docker --version
		Docker version 27.3.1, build ce12230

		docker compose version
		Docker Compose version v2.29.7

		권한설정
		chmod 666 /var/run/docker.sock

		사용자를 도커 그룹 추가
		usermod -aG docker 사용자이름

	
2. VM에서 Docker 사용 방법

 

	2-1. 도커 명령을 통해 사용할 image를 준비한다
	
		개발 과정에서 조건에 맞는 특정 custom 도커 images를 만들고 해당 image를 .tar로 저장한다
		
		docker save -o [파일명].tar [이미지이름]:[이미지태그]
		ex : docker save -o rabbitmq.tar rabbitmq:3-management
			docker save -o haproxy.tar haproxy:1.7
		
		-rw------- 1 root root  32569856 11월 25 13:52 haproxy.tar
		-rw------- 1 root root 115080192 11월 25 13:52 rabbitmq.tar

	2-2. 해당 tar 파일을 사용할 VM서버로 이동시킨 후 이미지를 도커에 로드한다.
		docker load -i haproxy.tar
		docker load -i rabbitmq.tar 

		docker images
		REPOSITORY   TAG            IMAGE ID       CREATED        SIZE
		rabbitmq     3-management   dab4742eee4e   2 months ago   251MB
		haproxy      1.7            41ed9a434c27   2 years ago    83MB

	2-4. 필요한 설정을 추가한다
		sudo vi .env
		sudo vi .erlang.cookie
		sudo vi cluster-entrypoint.sh
		sudo vi haproxy.cfg
		sudo vi docker-compose.yml
		
		drwxr-xr-x 2 root root      4096 11월 25 15:19 .
		drwxr-xr-x 3 root root      4096 11월 25 13:52 ..
		-rw-r--r-- 1 root root        79 11월 25 13:55 .env
		-r-------- 1  999 root         6 11월 25 14:01 .erlang.cookie
		-rwxr-xr-x 1 root root      1161 11월 25 13:52 cluster-entrypoint.sh
		-rw-r--r-- 1 root root      2129 11월 25 15:17 docker-compose.yml
		-rw-r--r-- 1 root root      1242 11월 25 15:19 haproxy.cfg
		-rw------- 1 root root  32569856 11월 25 13:52 haproxy.tar
		-rw------- 1 root root 115080192 11월 25 13:52 rabbitmq.tar

	2-5. 도커 명령어로 컨테이너를 실행시킨다
		docker compose up -d
		docker ps


