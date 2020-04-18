Mock Server for Save Request to Redis
==========

受け取ったHTTPリクエストをRedisに保存して200 OKを返すだけのシンプルなHTTPサーバー


Getting Started
----------

1. リポジトリをクローンする
    ```
    git clone https://github.com/tk-hamaguchi/ms4srr.git
    ```

2. docker-composeで立ち上げる
    ```
    docker-compose up --build -d
    docker-compose ps
    ```

3. redisをモニタリングする
    ```
    redis-cli monitor &
    ```

4. リクエストを投げる
    ```
    curl localhost:8080/hoge -H 'X-Request-Id: 123' -i
    ```

5. redisから値を参照する -> ここで4のリクエストが格納されていることが見れる
    ```
    redis-cli -n 1 hget by-id 123
    ```

* 環境のクリーンアップ
    ```
    docker-compose down
    ```
    
