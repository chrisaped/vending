require 'securerandom'
require_relative 'product'
require_relative 'money_manager'

class VendingMachine
  attr_accessor :products

  def initialize
    @products = {
      generate_code => Product.new("Cheetos", 100),
      generate_code => Product.new("Fritos", 25),
      generate_code => Product.new("Twinkies", 50),
      generate_code => Product.new("Pringles", 150),
    }
    @money_manager = MoneyManager.new
  end

  def incorrect_entry_message
    puts 'Incorrect entry'
  end	

  def generate_code
    # generate a random string with 4 characters
    SecureRandom.hex(2)
  end

  def insert(amount)
  	@money_manager.insert(amount)
  end

  def total_inserted
  	@money_manager.total_inserted
  end

  def select_product(code)
    if @money_manager.slot.empty?
      puts "Insert money"
    else
      product = @products[code]
      if product
        purchase(product)
      else
        incorrect_entry_message
      end
    end
  end	

  def purchase(product)
    if product.quantity == 0
      puts "This product is out of stock."
    elsif total_inserted < product.price
      puts "Please insert more money."
    else
      sell(product)
    end
  end

  def sell(product)
    @money_manager.change_check(product.price)
    product.quantity -= 1
    puts "You've purchased #{product.name}. Yum!"
  end   

  def cancel
    if total_inserted
      @money_manager.dispense_change(total_inserted)
      @money_manager.reset
    end		
    puts "Thank you for your business!"
  end

  def restock(code, quantity)
    product = @products[code]
    if product && quantity > 0
      product.increase_quantity(quantity)
    else
      incorrect_entry_message
    end
  end

  def stock(name, price)
    if !name.empty? && price > 0
      @products[generate_code] = Product.new(name, price)
    else
      incorrect_entry_message
    end
  end
end