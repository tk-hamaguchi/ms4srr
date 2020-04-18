# frozen_string_literal: true

Given 'docker-compose up されている' do
end

Given 'RedisのDBがクリアされている' do
  Redis.new.flushall
end

When '下記のコマンドを実行した:' do |cmd|
  run_command_and_stop(sanitize_text(cmd), fail_on_error: true)
end

Then '{string}に下記が出力されている:' do |channel, text|
  expect_text = text.gsub("\n", '').gsub("\\r\\n", "\r\n").gsub("\\r", "\r").gsub("\\n", "\n")

  channel = case channel
            when '標準出力' then 'stdout'
            when '標準エラー出力' then 'stderr'
            else
              raise "Undefined channel => #{channel}"
            end
  combined_output = send("all_#{channel}")

  expect(combined_output).to send(:an_output_string_being_eq, expect_text)
end

Then 'Redisの{string}キーに下記のデータが記憶されている:' do |key, value|
  current_timestamp = Time.now
  expect_value = value.gsub("\n", '').gsub("\\r\\n", "\r\n").gsub("\\r", "\r").gsub("\\n", "\n")
  r = Redis.new 
  expect(r.exists(key)).to eq true
  expect(r.hlen(key)).to eq 1
  case key
  when 'by-timestamp'
    ts,v = r.hgetall(key).first
    expect(Time.parse("#{ts}Z")).to be_between(current_timestamp - 1, current_timestamp + 1)
  else
    raise "Undefined key #{key}"
  end
  expect(v).to eq expect_value
end

Then 'Redisの{string}キーの{string}に下記のデータが記憶されている:' do |key, field, value|
  expect_value = value.gsub("\n", '').gsub("\\r\\n", "\r\n").gsub("\\r", "\r").gsub("\\n", "\n")
  r = Redis.new 
  expect(r.exists(key)).to eq true
  expect(r.hlen(key)).to eq 1
  expect(r.hexists(key, field)).to eq true
  v = r.hget(key, field)
  expect(v).to eq expect_value
end