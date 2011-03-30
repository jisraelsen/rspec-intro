class InsufficientFundsError < Exception; end
class Account
  attr_reader :balance, :overdraft, :overdraft_limit
  
  def initialize(overdraft=0)
    @balance = 0
    @overdraft = overdraft
    @overdraft_limit = overdraft
  end
  
  def deposit(amount)
    if overdraft < overdraft_limit
      if (amount - overdraft_difference) >= 0
        amount -= overdraft_difference
        @overdraft += overdraft_difference
        @balance += amount
      else
        @overdraft += amount
      end
    else
      @balance += amount
    end
  end
  
  def withdraw(amount)
    if balance >= amount
      @balance -= amount
    elsif total >= amount
      amount -= @balance
      @balance = 0
      @overdraft -= amount
    else
      raise InsufficientFundsError, "#{amount} greater than balance."
    end
  end
  
  def transfer(amount, account)
    withdraw(amount)
    account.deposit(amount)
  end
  
  def total
    balance + overdraft
  end
  
  private
    def overdraft_difference
      overdraft_limit - overdraft
    end
end
