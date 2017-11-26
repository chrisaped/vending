require 'vending_machine'

describe VendingMachine do
	it "can generate a code" do
		vm = VendingMachine.new
		expect(vm.generate_code.length).to eq 4
	end

	it "should insert and calculate the total inserted" do
		vm = VendingMachine.new
		vm.insert(25)
		vm.insert(100)
		expect(vm.total_inserted).to eq 125
	end	

	it "should be able to buy a product with exact change" do
		vm = VendingMachine.new
		vm.insert(100)
		cheetos_code = vm.products.keys[0]
		expect(vm).to receive(:puts).with("You've purchased Cheetos. Yum!")
		vm.select_product(cheetos_code)
	end

	it "should be able to buy a product with more money than required" do
		vm = VendingMachine.new
		vm.insert(100)
		vm.insert(25)
		cheetos_code = vm.products.keys[0]
		expect(vm).to receive(:puts).with("You've purchased Cheetos. Yum!")
		vm.select_product(cheetos_code)		
	end

	it "should not be able to buy a product with no money" do
		vm = VendingMachine.new
		cheetos_code = vm.products.keys[0]
		expect(vm).to receive(:puts).with("Insert money")
		vm.select_product(cheetos_code)		
	end

	it "should not be able to buy a product with less money than required" do
		vm = VendingMachine.new
		vm.insert(25)
		cheetos_code = vm.products.keys[0]
		expect(vm).to receive(:puts).with("Please insert more money.")
		vm.select_product(cheetos_code)		
	end

	it "should not be able to select a product with an incorrect code" do
		vm = VendingMachine.new
		vm.insert(100)
		code = "AAAAAA"
		expect(vm).to receive(:puts).with('Incorrect entry')
		vm.select_product(code)		  
	end

	it "should not be able to purchase a product if it is out of stock" do
		vm = VendingMachine.new
		vm.insert(100)
		cheetos_code = vm.products.keys[0]
		cheetos = vm.products[cheetos_code]
		cheetos.quantity = 0
		expect(vm).to receive(:puts).with('This product is out of stock.')
		vm.select_product(cheetos_code)		
	end

	it "should decrease the product quantity by 1 if it is sold" do
		vm = VendingMachine.new
		vm.insert(100)
		cheetos_code = vm.products.keys[0]
		cheetos = vm.products[cheetos_code]
		expect(cheetos.quantity).to eq 2
		vm.select_product(cheetos_code)
		expect(cheetos.quantity).to eq 1
	end

	it "should be able to cancel" do
		vm = VendingMachine.new
		vm.insert(100)
		vm.cancel
		expect(vm.total_inserted).to eq 0	
	end

	it "can restock a product" do
		vm = VendingMachine.new
		cheetos_code = vm.products.keys[0]
		cheetos = vm.products[cheetos_code]
		expect(cheetos.quantity).to eq 2
		vm.restock(cheetos_code, 2)
		expect(cheetos.quantity).to eq 4
	end

	it "does not restock a product with a bad quantity" do
		vm = VendingMachine.new
		cheetos_code = vm.products.keys[0]
		cheetos = vm.products[cheetos_code]
		expect(cheetos.quantity).to eq 2
		expect(vm).to receive(:puts).with('Incorrect entry')
		vm.restock(cheetos_code, -3)
		expect(cheetos.quantity).to eq 2
	end

	it "does not restock a product with a bad code" do
		vm = VendingMachine.new
		code = "AAAAAA"
		expect(vm).to receive(:puts).with('Incorrect entry')
		vm.restock(code, 2)
	end	

	it "can stock a product" do
		vm = VendingMachine.new
		vm.stock("Fluff", 50)
		expect(vm.products.values.map(&:name)).to include "Fluff"
	end

	it "does not stock a product if the name is empty" do
		vm = VendingMachine.new
		expect(vm).to receive(:puts).with('Incorrect entry')
		vm.stock("", 50)
	end

	it "does not stock a product if the price is less than zero" do
		vm = VendingMachine.new
		expect(vm).to receive(:puts).with('Incorrect entry')
		vm.stock("Fluff", -5)		
	end
end