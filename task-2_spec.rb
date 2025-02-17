# frozen_string_literal: true

require 'rspec-benchmark'
require 'json'
require_relative 'task-2'

describe 'parser' do
  include RSpec::Benchmark::Matchers

  let(:expected_json) do
    <<~JSON
      {"totalUsers":3,"uniqueBrowsersCount":14,"totalSessions":15,"allBrowsers":"CHROME 13,CHROME 20,CHROME 35,CHROME 6,FIREFOX 12,FIREFOX 32,FIREFOX 47,INTERNET EXPLORER 10,INTERNET EXPLORER 28,INTERNET EXPLORER 35,SAFARI 17,SAFARI 29,SAFARI 39,SAFARI 49","usersStats":{"Leida Cira":{"sessionsCount":6,"totalTime":"455 min.","longestSession":"118 min.","browsers":"FIREFOX 12, INTERNET EXPLORER 28, INTERNET EXPLORER 28, INTERNET EXPLORER 35, SAFARI 29, SAFARI 39","usedIE":true,"alwaysUsedChrome":false,"dates":["2017-09-27","2017-03-28","2017-02-27","2016-10-23","2016-09-15","2016-09-01"]},"Palmer Katrina":{"sessionsCount":5,"totalTime":"218 min.","longestSession":"116 min.","browsers":"CHROME 13, CHROME 6, FIREFOX 32, INTERNET EXPLORER 10, SAFARI 17","usedIE":true,"alwaysUsedChrome":false,"dates":["2017-04-29","2016-12-28","2016-12-20","2016-11-11","2016-10-21"]},"Gregory Santos":{"sessionsCount":4,"totalTime":"192 min.","longestSession":"85 min.","browsers":"CHROME 20, CHROME 35, FIREFOX 47, SAFARI 49","usedIE":false,"alwaysUsedChrome":false,"dates":["2018-09-21","2018-02-02","2017-05-22","2016-11-25"]}}}
    JSON
  end

  let(:megabytes) do
    work('input/data_large.txt')
    `ps -o rss= -p #{Process.pid}`.to_i / 1024
  end

  it 'works' do
    work
    expect(JSON.parse(File.read('result.json'))).to eq(JSON.parse(expected_json))
  end

  it 'work faster than 30sec for large file' do
    expect { work('input/data_large.txt') }.to perform_under(30).sec.sample(5).times
  end

  it 'allocate under 70 MB of RAM for large file' do
    expect(megabytes).to be < 70
  end

  it 'progress linear' do
    expect { |n| work("input/data_#{n}k.txt") }.to perform_linear.in_range(1, 256).ratio(2)
  end
end
