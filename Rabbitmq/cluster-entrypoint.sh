#!/bin/sh
set -eu

# CRLF 방지: dos2unix cluster-entrypoint.sh (윈도우에서 가져왔다면 한 번 변환 추천)
chmod 600 /var/lib/rabbitmq/.erlang.cookie || true

HOSTNAME="$(hostname)"
echo "[entrypoint] starting for host: ${HOSTNAME}"

# ---- 핵심: STOMP / Web-STOMP / Prometheus 플러그인 오프라인 활성화 ----
# management 이미지는 mgmt가 이미 켜짐. 중복 enable해도 안전.
rabbitmq-plugins enable --offline rabbitmq_management rabbitmq_prometheus rabbitmq_stomp rabbitmq_web_stomp

wait_until_up() {
  for i in $(seq 1 60); do
    if rabbitmq-diagnostics -q ping >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  return 1
}

join_with_retry() {
  local target="rabbit@$JOIN_CLUSTER_HOST"
  for i in $(seq 1 10); do
    echo "[entrypoint] joining cluster -> ${target} (try: $i/10)"
    if rabbitmqctl join_cluster "${target}"; then
      return 0
    fi
    sleep 3
  done
  return 1
}

if [ -z "${JOIN_CLUSTER_HOST:-}" ]; then
  echo "[entrypoint] seed node - foreground"
  exec docker-entrypoint.sh rabbitmq-server
else
  echo "[entrypoint] join node - target: ${JOIN_CLUSTER_HOST}"
  docker-entrypoint.sh rabbitmq-server -detached

  if ! wait_until_up; then
    echo "[entrypoint] ERROR: local node did not start in time" >&2
    exit 1
  fi

  rabbitmqctl stop_app || true
  if ! join_with_retry; then
    echo "[entrypoint] ERROR: failed to join cluster" >&2
    exit 2
  fi
  rabbitmqctl start_app
  rabbitmqctl await_startup

  echo "[entrypoint] node joined. following logs..."
  exec tail -F /var/log/rabbitmq/*.log
fi
