# frozen_string_literal: true

require 'json'

class Memo
  PATH = 'data/memos.json'

  def self.all
    File.open(PATH) do |f|
      JSON.parse(f.read, symbolize_names: true) # load を利用すると Rubocop の警告がでるため、文字列として読み込み、parse する
    end
  end
end
