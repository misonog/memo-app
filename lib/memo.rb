# frozen_string_literal: true

require 'json'
require 'erb'
require 'pg'
require 'yaml'

class Memo
  include ERB::Util
  attr_reader :id, :title, :content

  def self.connect_db(conf_path)
    dbconf = YAML.safe_load(ERB.new(File.read(conf_path)).result)['db']
    @@conn = PG.connect(dbconf)
  end

  def self.all
    @@conn.exec('SELECT * FROM memos')
  end

  def self.find_by_id(id)
    result = @@conn.exec('SELECT * FROM memos WHERE id = $1', [id]).first
    Memo.new(id: result['id'], title: result['title'], content: result['content'])
  end

  def initialize(title:, content:, id: nil)
    @id = id
    @title = h(title)
    @content = h(content)
  end

  def save
    @@conn.exec('INSERT INTO memos (title, content) VALUES ($1, $2)', [@title, @content])
    @id = @@conn.exec('SELECT LASTVAL()').getvalue(0, 0)
  end

  def update(title:, content:)
    @@conn.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, @id])
  end

  def destroy
    @@conn.exec('DELETE FROM memos WHERE id = $1', [@id])
  end
end
