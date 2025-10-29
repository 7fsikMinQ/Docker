#!/bin/sh
set -eu

# 권한: 컨테이너 내부에서 600이 가장 호환 좋음
chmod 600 /var/lib/rabbitmq/.erlang.cookie || true

HOSTNAME="$(hostname)"
echo "[entrypoint] starting for host: ${HOSTNAME}"

wait_until_up() {
  # 노드가 기동 완료할 때까지 대기 (최대 60초, 1초 간격)
  for i in $(seq 1 60); do
    if rabbitmq-diagnostics -q ping >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  return 1
}

join_with_retry() {
  # 클러스터 조인 재시도 (최대 10회)
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
  # 시드 노드: 포그라운드 실행
  echo "[entrypoint] seed node - foreground"
  exec docker-entrypoint.sh rabbitmq-server
else
  # 조인 노드: 백그라운드로 먼저 기동
  echo "[entrypoint] join node - target: ${JOIN_CLUSTER_HOST}"
  docker-entrypoint.sh rabbitmq-server -detached

  # 로컬 노드 완전 기동 대기
  if ! wait_until_up; then
    echo "[entrypoint] ERROR: local node did not start in time" >&2
    exit 1
  fi

  # 앱 내리고 조인
  rabbitmqctl stop_app || true
  if ! join_with_retry; then
    echo "[entrypoint] ERROR: failed to join cluster" >&2
    exit 2
  fi
  rabbitmqctl start_app

  rabbitmqctl await_startup
  echo "[entrypoint] node joined. following logs..."
  # 컨테이너 유지: 로그 tail
  exec tail -F /var/log/rabbitmq/*.log
fi
