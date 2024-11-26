#Docker 
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

