# frozen_string_literal: true

require 'json'
require 'erb'
require 'pg'
require 'yaml'

class Memo
  include ERB::Util
  attr_reader :id, :title, :content

  PATH = 'data/memos.json'

  def self.connect_db(conf_path)
    dbconf = YAML.safe_load(ERB.new(File.read(conf_path)).result)['db']
    @conn = PG.connect(dbconf)
  end

  def self.all
    @conn.exec('SELECT * FROM memos')
  end

  def self.find_by_id(id)
    memos = Memo.all
    memo = memos.find { |m| m[:id] == id }
    Memo.new(**memo)
  end

  def initialize(title:, content:, id: nil)
    @id = id.nil? ? create_id : id
    @title = h(title)
    @content = h(content)
  end

  def save
    memos = Memo.all
    memos << { id: @id, title: @title, content: @content }
    File.open(PATH, 'w') { |f| JSON.dump(memos, f) }
  end

  def update(title:, content:)
    memos = Memo.all
    # each_with_object や select との併用も考えたが、シンプルに対応
    memos.map! do |m|
      if m[:id] == @id
        m[:title] = h(title)
        m[:content] = h(content)
      end
      m
    end
    File.open(PATH, 'w') { |f| JSON.dump(memos, f) }
  end

  def destroy
    memos = Memo.all.delete_if { |m| m[:id] == @id }
    File.open(PATH, 'w') { |f| JSON.dump(memos, f) }
  end

  private

  def create_id
    memos = Memo.all
    memos.sort_by! { |memo| memo[:id] }
    memos.last[:id] + 1
  end
end
