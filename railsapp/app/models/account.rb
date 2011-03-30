class InsufficientFundsError < Exception; end
class Account < ActiveRecord::Base
  after_initialize :set_defaults
  before_create :set_defaults
  
  def deposit(amount)
    if overdraft < overdraft_limit
      if (amount - overdraft_difference) >= 0
        amount -= overdraft_difference
        self.overdraft += overdraft_difference
        self.balance += amount
      else
        self.overdraft += amount
      end
    else
      self.balance += amount
    end
  end
  
  def withdraw(amount)
    if balance >= amount
      self.balance -= amount
    elsif total >= amount
      amount -= self.balance
      self.balance = 0
      self.overdraft -= amount
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
    
    def set_defaults
      self.overdraft_limit = overdraft if new_record?
    end
end
