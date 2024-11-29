위 설정을 기반으로 Kafka 컨테이너를 사용하려면 **192.168.27.106** 서버에서 필요한 포트들을 열어야 합니다. 이 포트들은 외부 클라이언트와 통신하기 위해 반드시 열려 있어야 합니다.

---

### **열어야 할 포트**

#### **1. Zookeeper 포트**
- Zookeeper는 Kafka 브로커 간의 메타데이터 관리를 담당합니다.
  - **2181**: Zookeeper 클라이언트 포트 (Kafka 브로커 및 Kafka UI가 Zookeeper와 통신하기 위해 사용)

---

#### **2. Kafka 브로커 포트**
- Kafka 클러스터를 구성하는 브로커 각각에 대한 **EXTERNAL 리스너** 포트를 열어야 합니다.
  - **9092**: Kafka 브로커 1의 EXTERNAL 리스너
  - **9093**: Kafka 브로커 2의 EXTERNAL 리스너
  - **9094**: Kafka 브로커 3의 EXTERNAL 리스너

---

#### **3. Kafka UI 포트**
- Kafka UI는 Kafka 클러스터 관리 및 모니터링을 위한 웹 인터페이스입니다.
  - **8888**: Kafka UI의 웹 포트

---

### **포트 목록 요약**
| 서비스         | 포트  | 설명                                              |
|----------------|-------|---------------------------------------------------|
| Zookeeper      | 2181  | Kafka와 Zookeeper 간의 통신                       |
| Kafka Broker 1 | 9092  | Kafka 브로커 1의 EXTERNAL 리스너                  |
| Kafka Broker 2 | 9093  | Kafka 브로커 2의 EXTERNAL 리스너                  |
| Kafka Broker 3 | 9094  | Kafka 브로커 3의 EXTERNAL 리스너                  |
| Kafka UI       | 8888  | Kafka UI 웹 인터페이스 포트                       |

---

### **포트 열기 명령어**
`ufw`를 사용하는 경우, 다음 명령어를 실행하여 필요한 포트를 열어줍니다.

```bash
sudo ufw allow 2181/tcp  # Zookeeper
sudo ufw allow 9092/tcp  # Kafka Broker 1
sudo ufw allow 9093/tcp  # Kafka Broker 2
sudo ufw allow 9094/tcp  # Kafka Broker 3
sudo ufw allow 8888/tcp  # Kafka UI
sudo ufw reload
```

---

### **테스트**
1. **Zookeeper 통신 확인**
   ```bash
   telnet 192.168.27.106 2181
   ```

2. **Kafka 브로커 통신 확인**
   ```bash
   kafka-console-producer.sh --broker-list 192.168.27.106:9092 --topic test-topic
   ```

3. **Kafka UI 접속 확인**
   - 브라우저에서 `http://192.168.27.106:8888` 접속.

---

위 포트가 올바르게 열려 있다면, 다른 서버에서 Kafka 클러스터 및 Kafka UI에 정상적으로 접근할 수 있습니다.
