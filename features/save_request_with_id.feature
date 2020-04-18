#language:ja

機能: HTTPリクエストをRedisへ記録する

シナリオ: X-Request-Idヘッダを含むGETリクエストがRedisのby-idキーに記録され、200OKが返る
  前提 docker-compose up されている
  かつ RedisのDBがクリアされている

  もし 下記のコマンドを実行した:
    """
    curl localhost:8080/hoge -H 'User-Agent: test' -H 'X-Request-Id: 123' -i
    """
  ならば "標準出力"に下記が出力されている:
    """
    HTTP/1.1 200 OK\r\n
    Content-Type: text/plain; charset=utf-8\r\n
    Connection: close\r\n
    X-Request-Id: 123\r\n
    Content-Length: 2\r\n
    \r\n
    OK
    """
  かつ Redisの"by-timestamp"キーに下記のデータが記憶されている:
    """
    GET /hoge HTTP/1.1\r\n
    Host: localhost:8080\r\n
    Accept: */*\r\n
    User-Agent: test\r\n
    X-Request-Id: 123\r\n
    \r\n
    """
  かつ Redisの"by-id"キーの"123"に下記のデータが記憶されている:
    """
    GET /hoge HTTP/1.1\r\n
    Host: localhost:8080\r\n
    Accept: */*\r\n
    User-Agent: test\r\n
    X-Request-Id: 123\r\n
    \r\n
    """
