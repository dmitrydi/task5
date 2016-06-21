require_relative '../lib/cash_desk'

describe CashDesk do

  let(:tester) { Class.new { include CashDesk } }
  let(:instance) { tester.new }
  let(:klass) { Class.new { extend CashDesk } }

  it{ expect(instance).to respond_to(:cash, :put_cash, :take) }
  it{ expect(klass).to respond_to(:cash, :put_cash, :take) }

  describe '#put_cash' do
    it{ expect{ instance.put_cash(10) }.to change{ instance.cash }.from(0).to(10) }
  end

  describe '#take' do
    before(:example) do
      instance.put_cash(10)
    end

    it{ expect{ instance.take('Not Bank') }.to raise_error EncashmentError }
    it{ expect{ instance.take('Bank') }.to change{ instance.cash }.from(10).to(0) }
    it{ expect{ instance.take('Bank') }.to output(/Cash collected by Bank, amount taken: #{instance.cash}/).to_stdout }
  end

end

