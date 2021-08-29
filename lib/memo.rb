# frozen_string_literal: true

require 'json'

class Memo
  attr_reader :id, :title, :content

  PATH = 'data/memos.json'

  def self.all
    File.open(PATH) do |f|
      JSON.parse(f.read, symbolize_names: true) # load を利用すると Rubocop の警告がでるため、文字列として読み込み、parse する
    end
  end

  def self.find_by_id(id)
    memos = Memo.all
    memo = memos.find { |m| m[:id] == id }
    Memo.new(**memo)
  end

  def initialize(title:, content:, id: nil)
    @id = id.nil? ? create_id : id
    @title = title
    @content = content
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
        m[:title] = title
        m[:content] = content
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
