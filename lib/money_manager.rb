class MoneyManager
  attr_accessor :slot
  attr_reader :denominations

  def initialize
    @slot = []
    @denominations = [100, 25, 10, 5]
  end

  def total_inserted
    @slot.sum
  end

  def reset
    @slot.clear
  end

  def insert(denomination)
    if @denominations.include?(denomination)
      @slot << denomination
    else
      puts "Incorrect denomination"
    end
  end		

  def change_check(product_price)
    change = total_inserted - product_price
    if change == 0
      puts "No change, thank you for your purchase"
    else
      dispense_change(change)
    end
    reset
  end

  def dispense_change(amount)
    change = []
    i = 0

    while amount > 0
      denomination = @denominations[i]

      # larger amounts first, so there's less change to carry
      if denomination > amount
        i += 1
      else
        change << denomination
        amount -= denomination
      end
    end
    total_change = change.sum

    puts "Your total change: #{total_change}"
    puts "#{change}"
  end		
end