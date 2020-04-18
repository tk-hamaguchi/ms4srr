#language:ja

機能: HTTPリクエストをRedisへ記録する

シナリオ: プレーンなGETリクエストがRedisのby-timestampキーに記録され、200OKが返る
  前提 docker-compose up されている
  かつ RedisのDBがクリアされている

  もし 下記のコマンドを実行した:
    """
    curl localhost:8080/hoge -H 'User-Agent: test' -i
    """
  ならば "標準出力"に下記が出力されている:
    """
    HTTP/1.1 200 OK\r\n
    Content-Type: text/plain; charset=utf-8\r\n
    Connection: close\r\n
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
    \r\n
    """

シナリオ: クエリを伴うGETリクエストがRedisのby-timestampキーに記録され、200OKが返る
  前提 docker-compose up されている
  かつ RedisのDBがクリアされている

  もし 下記のコマンドを実行した:
    """
    curl localhost:8080/hoge?fuga=moke -H 'User-Agent: test' -i
    """
  ならば "標準出力"に下記が出力されている:
    """
    HTTP/1.1 200 OK\r\n
    Content-Type: text/plain; charset=utf-8\r\n
    Connection: close\r\n
    Content-Length: 2\r\n
    \r\n
    OK
    """
  かつ Redisの"by-timestamp"キーに下記のデータが記憶されている:
    """
    GET /hoge?fuga=moke HTTP/1.1\r\n
    Host: localhost:8080\r\n
    Accept: */*\r\n
    User-Agent: test\r\n
    \r\n
    """

シナリオ: カスタムヘッダを含むGETリクエストがRedisのby-timestampキーに記録され、200OKが返る
  前提 docker-compose up されている
  かつ RedisのDBがクリアされている

  もし 下記のコマンドを実行した:
    """
    curl localhost:8080/hoge -H 'User-Agent: test' -H 'Authorization: Bearer: fuga' -i
    """
  ならば "標準出力"に下記が出力されている:
    """
    HTTP/1.1 200 OK\r\n
    Content-Type: text/plain; charset=utf-8\r\n
    Connection: close\r\n
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
    Authorization: Bearer: fuga\r\n
    \r\n
    """


シナリオ: プレーンなPOSTリクエストがRedisのby-timestampキーに記録され、200OKが返る
  前提 docker-compose up されている
  かつ RedisのDBがクリアされている

  もし 下記のコマンドを実行した:
    """
    curl localhost:8080/hoge -H 'User-Agent: test' -X POST -d 'aaa=bbb' -i
    """
  ならば "標準出力"に下記が出力されている:
    """
    HTTP/1.1 200 OK\r\n
    Content-Type: text/plain; charset=utf-8\r\n
    Connection: close\r\n
    Content-Length: 2\r\n
    \r\n
    OK
    """
  かつ Redisの"by-timestamp"キーに下記のデータが記憶されている:
    """
    POST /hoge HTTP/1.1\r\n
    Host: localhost:8080\r\n
    Accept: */*\r\n
    User-Agent: test\r\n
    Content-Length: 7\r\n
    Content-Type: application/x-www-form-urlencoded\r\n
    \r\n
    aaa=bbb
    """


シナリオ: JSONのリクエストボディを含むPOSTリクエストがRedisのby-timestampキーに記録され、200OKが返る
  前提 docker-compose up されている
  かつ RedisのDBがクリアされている

  もし 下記のコマンドを実行した:
    """
    curl localhost:8080/hoge -H 'User-Agent: test' -H 'Content-Type: application/json' -X POST -d '{"aaa":"bbb"}' -i
    """
  ならば "標準出力"に下記が出力されている:
    """
    HTTP/1.1 200 OK\r\n
    Content-Type: text/plain; charset=utf-8\r\n
    Connection: close\r\n
    Content-Length: 2\r\n
    \r\n
    OK
    """
  かつ Redisの"by-timestamp"キーに下記のデータが記憶されている:
    """
    POST /hoge HTTP/1.1\r\n
    Host: localhost:8080\r\n
    Accept: */*\r\n
    User-Agent: test\r\n
    Content-Type: application/json\r\n
    Content-Length: 13\r\n
    \r\n
    {"aaa":"bbb"}
    """

