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
    puts "q:入金を止める, 半角数字:お金を入れる"
    while true 
      input = gets.chomp 
      money = input.to_i
      return @slot_money if input == "q"  # q が入力されたら、入金処理を終了
      if MONEY.include?(money)     # 使用可能であれば、残高に加算
        @slot_money += money
      elsif input =~ /^[0-9]+$/    # 使用不可能なお金であれば、そのまま返却
        puts "#{input}円が返却されました。"
      else
        puts "qまたは半角数字を入力してください"
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
    @stock_drinks = [{drink: "コーラ", price: 120, stock: default_stock},
                     {drink: "レッドブル", price: 200, stock: default_stock},
                     {drink: "水", price: 100, stock: default_stock}]
  end

  # 残高表示
  def credit
     "残高:#{@current_slot_money}円"  
  end
  
  # 商品を並べる
  def drink_list
    puts "購入したい商品番号、またはqを入力してください。"
    message = ["q:お釣りを出す"]
    @stock_drinks.each_with_index do | stock_drink, i |
      message << "#{i}:#{stock_drink[:drink]}:#{stock_drink[:price]}円"
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
    drink = @stock_drinks[drink_id][:drink]
    price = @stock_drinks[drink_id][:price]
    stock = @stock_drinks[drink_id][:stock]
    
    if stock.zero?
      puts "#{drink}は売り切れました。 #{credit}"
      drink_list

    elsif @current_slot_money < price
      puts "残高が足りません。 #{credit}"
      drink_list

    else
      @current_slot_money -= price                 # 残高から商品の価格を引く
      @sales += price                              # 売上に加算
      @stock_drinks[drink_id][:stock] = stock - 1  # 対象商品のストックを1減らす

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

    drink_kinds = @stock_drinks.length.to_i - 1  # 飲み物の種類
    while true
      input = gets.chomp  #入力受付
      puts "- - - - - - - - - -"
      choice = input.to_i
      return refund if input == "q"     # qが入力されたら、お釣りを出して終了
      if (0..drink_kinds).include?(choice) && input =~ /^[0-9]+$/ # 0〜nの半角数字が入力されたら、購入処理を実行
        buy(choice)
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
