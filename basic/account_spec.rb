require './account'

describe Account do
  describe "#initialize" do
    it "assigns balance to 0" do
      account = Account.new
      account.balance.should == 0
    end
    
    context "with overdraft amount" do
      it "assigns overdraft to amount" do
        account = Account.new(100)
        account.overdraft.should == 100
      end
      
      it "assigns overdraft_limit to amount" do
        account = Account.new(100)
        account.overdraft_limit.should == 100
      end
    end
    
    context "without overdraft amount" do
      it "assigns overdraft to 0" do
        account = Account.new
        account.overdraft.should == 0
      end
      
      it "assigns overdraft_limit to 0" do
        account = Account.new
        account.overdraft_limit.should == 0
      end
    end
  end
  
  describe "#deposit" do
    it "adds amount to balance" do
      account = Account.new
      account.deposit(100)
      account.balance.should == 100
    end
    
    context "with used overdraft" do
      before(:each) do
        @account = Account.new(100)
        @account.withdraw(50)
      end
      
      it "adds amount to overdraft" do        
        @account.deposit(100)
        @account.overdraft.should == 100        
        @account.balance.should == 50
      end
      
      it "adds difference to balance" do
        @account.deposit(100)
        @account.overdraft.should == 100        
        @account.balance.should == 50
      end
    end
  end
  
  describe "#withdraw" do
    before(:each) do
      @account = Account.new
      @account.deposit(100)
    end
    
    context "amount <= balance" do
      it "subtracts amount from balance" do
        @account.withdraw(50)
        @account.balance.should == 50
      end
    end
    
    context "amount <= balance + overdraft" do
      before(:each) do
        @account = Account.new(100)
        @account.deposit(100)
      end
      
      it "assigns balance to 0" do
        @account.withdraw(150)
        @account.balance.should == 0
      end
      
      it "subtracts difference from overdraft" do
        @account.withdraw(150)
        @account.overdraft.should == 50
      end
    end
    
    context "amount > balance + overdraft" do
      it "raises InsufficientFundsError" do
        expect { @account.withdraw(150) }.to raise_error(InsufficientFundsError, '150 greater than balance.')
      end
      
      it "does not subtract amount from balance" do
        expect { @account.withdraw(150) }.to raise_error
        @account.balance.should == 100
      end
    end
  end
  
  describe "#transfer" do
    before(:each) do
      @transferee = Account.new
      @account = Account.new
      @account.deposit(100)
    end
    
    context "amount <= balance" do
      it "transfers amount to transferee" do
        @account.transfer(50, @transferee)
        @transferee.balance.should == 50
      end
    
      it "subtracts amount from balance" do
        @account.transfer(50, @transferee)
        @account.balance.should == 50
      end
    end
    
    context "amount <= balance + overdraft" do
      before(:each) do
        @account = Account.new(100)
        @account.deposit(100)
      end
      
      it "transfers amount to transferee" do
        @account.transfer(150, @transferee)
        @transferee.balance.should == 150
      end
      
      it "assigns balance to 0" do
        @account.transfer(150, @transferee)
        @account.balance.should == 0
      end
      
      it "subtracts difference from overdraft" do
        @account.transfer(150, @transferee)
        @account.overdraft.should == 50
      end
    end
    
    context "amount > balance" do
      it "raises InsufficientFundsError" do
        expect { @account.transfer(150, @transferee) }.to raise_error(InsufficientFundsError, '150 greater than balance.')
      end
    
      it "does not transfer amount to transferee" do
        expect { @account.transfer(150, @transferee) }.to raise_error
        @transferee.balance.should == 0
      end
    
      it "does not subtract amount from balance" do
        expect { @account.transfer(150, @transferee) }.to raise_error
        @account.balance.should == 100
      end
    end
  end
  
  describe "#total" do
    it "returns balance + overdraft" do
      account = Account.new(50)
      account.deposit(100)
      account.total.should == 150
    end
  end
end
