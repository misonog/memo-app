# frozen_string_literal: true

require 'json'

class Memo
  PATH = 'data/memos.json'

  def self.all
    File.open(PATH) do |f|
      JSON.parse(f.read, symbolize_names: true) # load を利用すると Rubocop の警告がでるため、文字列として読み込み、parse する
    end
  end

  def initialize(title, content)
    @id = create_id
    @title = title
    @content = content
  end

  def save
    memos = Memo.all
    memos << { id: @id, title: @title, content: @content }
    open(PATH, 'w') { |f| JSON.dump(memos, f) }
  end

  private

  def create_id
    memos = Memo.all
    memos.sort_by! { |memo| memo[:id] }
    memos.last[:id] + 1
  end
end
