require 'money_manager'

describe MoneyManager do
	it "should insert and calculate the total inserted" do
		mm = MoneyManager.new
		mm.insert(25)
		mm.insert(100)
		expect(mm.total_inserted).to eq 125
	end

	it "will not insert an incorrect denomination" do
		mm = MoneyManager.new
		expect(mm).to receive(:puts).with("Incorrect denomination")
		mm.insert(31)		
	end

	it "can reset" do
		mm = MoneyManager.new
		mm.insert(25)
		expect(mm.total_inserted).to eq 25
		mm.reset
		expect(mm.slot).to eq []
	end

	it "properly dispenses change" do
		mm = MoneyManager.new
		mm.insert(100)
		product_price = 10
		expect(mm).to receive(:puts).with("Your total change: 90")
		expect(mm).to receive(:puts).with("[25, 25, 25, 10, 5]")
		mm.change_check(product_price)
		expect(mm.slot).to eq []
	end

	it "does not dispense change if there is none" do
		mm = MoneyManager.new
		mm.insert(100)
		product_price = 100
		expect(mm).to receive(:puts).with("No change, thank you for your purchase")
		mm.change_check(product_price)
		expect(mm.slot).to eq []
	end
end