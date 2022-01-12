require "csv"
memos = []

puts "1(新規でメモを作成) 2(既存のメモ編集する)"
memo_type = gets.to_s.chomp

if memo_type == "1"
  puts "保存するファイル名を入力してください(拡張子除く)"
  title = gets.chomp

  puts "メモの内容を入力してください"
  puts "ctrl + D で入力を終了します"

  while memo = gets
    memos << memo.chomp
    puts "追加のメモを入力してください"
  end

  CSV.open(title + '.csv','w') do |csv|
    p memos
    memos.each do |memo|
      csv << [memo]
    end
  end
elsif memo_type == "2"
  puts "編集するcsvファイル名を入力してください(拡張子除く)"
  path = ARGV[0] ? ARGV[0] : '.'
  title = gets.chomp

  Dir.glob("#{path}/#{title}.csv") do |item|
    memos = CSV.read(item)
    memos.each do |memo|
      puts "#{memos.index(memo)} #{memo}"
    end
    puts "編集したいインデックス番号を入力してください"
    puts "ctrl + D で入力を終了します"
    while index = gets
      if memos.count <= index.chomp.to_i || !(index.chomp =~ /^[0-9]+$/) #数値でない または memos.count 以上
        puts "0から#{memos.count - 1}までの数字で指定してください"
        next
      end
      if index == "0D"
        break
      end
      puts "編集後の内容を入力してください"
      memo = gets
      if !memo.empty?
        memos[index.to_i] = [memo.chomp]
      end
      memos.each do |memo|
        puts "#{memos.index(memo)} #{memo}"
      end
      puts "編集したいインデックス番号を入力してください"
      puts "ctrl + D で入力を終了します"
    end

    CSV.open(title + '.csv','w') do |csv|
      memos.each do |memo|
        csv << memo
      end
    end
  end
  if memos == []
    puts "指定したタイトルのcsvファイルは見つかりませんでした"
  end
else
  puts "1か2を入力してください"
end
