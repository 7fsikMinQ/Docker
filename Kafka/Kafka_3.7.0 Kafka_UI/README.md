192.168.27.106 서버에 있는 Kafka 컨테이너를 다른 VM에서 사용하려면 아래의 사항을 고려하여 필요한 포트를 열어야 합니다.

---

### **1. 192.168.27.106 서버에서 열어야 할 포트**
Kafka 클러스터와 통신을 위해 각 브로커의 EXTERNAL 포트를 열어야 합니다.

- **Kafka 브로커 포트 (EXTERNAL)**
  - 브로커 0: `10000`
  - 브로커 1: `10001`
  - 브로커 2: `10002`

- **Kafka-UI 포트**
  - Kafka UI: `8089` (웹 인터페이스 접속)

#### 명령어 예시 (`192.168.27.106`에서 실행)
```bash
sudo ufw allow 10000/tcp
sudo ufw allow 10001/tcp
sudo ufw allow 10002/tcp
sudo ufw allow 8089/tcp
sudo ufw reload
```

---

### **2. 다른 VM에서 열어야 할 포트**
Kafka의 EXTERNAL 포트를 통해 접근하므로 다른 VM에서 **192.168.27.106의 포트**로 나가는 통신이 가능하도록 설정합니다.

- 기본적으로 다른 VM에서 별도 포트를 열 필요는 없습니다. 하지만 방화벽이 아웃바운드 트래픽을 제한한다면, **192.168.27.106의 포트**로 나가는 통신을 허용해야 합니다.

#### 명령어 예시 (`다른 VM에서 실행`)
```bash
sudo ufw allow out to 192.168.27.106 port 10000 proto tcp
sudo ufw allow out to 192.168.27.106 port 10001 proto tcp
sudo ufw allow out to 192.168.27.106 port 10002 proto tcp
sudo ufw allow out to 192.168.27.106 port 8089 proto tcp
sudo ufw reload
```

---

### **3. 방화벽 외 추가 설정 확인**
1. **Docker 네트워크 설정**
   - Kafka 컨테이너가 Docker 브리지 네트워크를 사용하므로 외부에서 접근하려면 반드시 **`EXTERNAL` 리스너의 IP 및 포트를 정확히 설정**해야 합니다. 
   - 예를 들어, `192.168.27.106`을 EXTERNAL 리스너로 설정한 상태는 올바릅니다.

2. **VM 간의 네트워크 통신 확인**
   - `ping 192.168.27.106`으로 기본적인 네트워크 통신 확인.
   - `telnet 192.168.27.106 10000`으로 해당 포트가 열려 있는지 확인.

3. **Kafka 클러스터 설정**
   - Kafka 클러스터의 `KAFKA_CFG_ADVERTISED_LISTENERS` 환경변수에 설정된 IP와 포트가 올바른지 확인합니다.

---

### **4. 테스트 방법**
1. **Kafka Producer 및 Consumer 사용**
   - 다른 VM에서 Kafka Producer/Consumer를 실행하여 테스트합니다.
   ```bash
   kafka-console-producer.sh --broker-list 192.168.27.106:10000 --topic test-topic
   ```

   ```bash
   kafka-console-consumer.sh --bootstrap-server 192.168.27.106:10000 --topic test-topic --from-beginning
   ```

2. **Kafka UI 접속**
   - 브라우저에서 `http://192.168.27.106:8089`로 접속하여 Kafka UI가 정상적으로 작동하는지 확인합니다.

---

위 단계를 진행하면 다른 VM에서 Kafka 컨테이너를 문제없이 사용할 수 있을 것입니다.
