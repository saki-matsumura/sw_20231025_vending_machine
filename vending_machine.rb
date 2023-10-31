# 入金用のクラス
class SlotMoney
  # 初期化
  def initialize
    @slot_money = 0    # 使用可能な投入金額（残高）
    @change_money = 0  # お釣り
  end
  
  # 投入できるお金を設定する。.freezeによって、値が変わることを防ぐ
  MONEY = [10, 50, 100, 500, 1000].freeze

  # 入金する
  def slot_money
    puts "a:入金を止める, 半角数字:お金を入れる"
    while true 
      input = gets.chomp 
      money = input.to_i
      return @slot_money if input == "a"  # a が入力されたら、入金処理を終了
      if MONEY.include?(money)  # 使用可能であれば、残高に加算
        @slot_money += money
      elsif input =~ /^[0-9]+$/    # 使用不可能なお金であれば、そのまま返却
        puts "#{input}円が返却されました。"
      else
        puts "aまたは半角数字を入力してください"
      end
    end
  end
end

# 自販機のクラス
class VendingMachine
  # 初期化
  def initialize(slot_money)
    @current_slot_money = slot_money  #　残高を代入
    @sales = 0         # 売上リセット     
    default_stock = 5  # 各飲み物のストックをリセット
    @slot_drinks = [{drink: "コーラ", price: 120, stock: default_stock},
                    {drink: "レッドブル", price: 200, stock: default_stock},
                    {drink: "水", price: 100, stock: default_stock}]
  end

  # 現在、自販機に残っている飲み物
  def current_slot_drinks
    @slot_drinks
  end

  # 残高表示
  def credit
     "残高:#{@current_slot_money}円"  
  end
  
  # 商品を並べる
  def drink_list
    puts "購入したい商品番号を入力してください。"
    message = ["a:お釣りを出す"]
    current_slot_drinks.each_with_index do | slot_drink, i |
      message << "#{i}:#{slot_drink[:drink]}:#{slot_drink[:price]}円"
    end
    puts message.join(', ')
  end

  # お釣りと売上表示
  def refund
    puts "——————————————————————————————————————————————"
    puts "ありがとうございました。またのご利用、お待ちしております。"
    puts "お釣り:#{@current_slot_money}円, 売上:#{@sales}円"
    puts "———————————————————————————————————————— end_▼"
  end

  # 購入処理
  def buy(drink_id)
    drink = @slot_drinks[drink_id][:drink]
    price = @slot_drinks[drink_id][:price]
    stock = @slot_drinks[drink_id][:stock]
    
    if stock.zero?
      puts "#{drink}は売り切れました。 #{credit}"
      drink_list

    elsif @current_slot_money < price
      puts "残高が足りません。 #{credit}"
      drink_list

    else
      @current_slot_money -= price                # 残高から商品の価格を引く
      @sales += price                             # 売上に加算
      @slot_drinks[drink_id][:stock] = stock - 1  # 対象商品のストックを1減らす

      puts "#{drink}を購入しました。 #{credit}"

      # 残高が0になったら、処理を終了する。
      if @current_slot_money == 0
        refund
        exit
      else
        drink_list
      end
    end
  end

  # 購入する商品を選ぶ
  def choice_drink
    puts "- - - - - - - - - -"
    drink_list

    drink_kinds = (current_slot_drinks.length.to_i - 1).to_i  # 飲み物の種類
    while true
      input = gets.chomp  #入力受付
      puts "- - - - - - - - - -"
      choice = input.to_i
      if input == "a"     # aが入力されたら、お釣りを出して終了
        refund
        return
      elsif (0..drink_kinds).include?(choice) && input =~ /^[0-9]+$/ # 0〜nの半角数字が入力されたら、購入処理を実行
        drink_id = choice
        buy(drink_id)
      else
        drink_list
      end
    end
  end
end

# 実行用のクラス
class VendingMachineStart
  def self.vending_machine_start
    # お金を入れる
    money = SlotMoney.new
    slot_money = money.slot_money

    # 自販機の動作
    vending_machine = VendingMachine.new(slot_money)
    vending_machine.choice_drink
  end
end

# 実行
VendingMachineStart.vending_machine_start
