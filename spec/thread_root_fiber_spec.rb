require 'spec_helper'

describe Thread do
  describe "#root_fiber" do
    it "is the root fiber of the thread" do
      thread = Thread.new{ Fiber.current }
      expect(thread.root_fiber).to be thread.value
    end

    it "is not another fiber in the thread" do
      thread = Thread.new{ Fiber.new{ Fiber.current }.resume }
      expect(thread.root_fiber).not_to be thread.value
    end
  end
end

describe Fiber do
  describe ".root" do
    context "when executed inside the thread" do
      it "returns the root fiber of the thread" do
        thread = Thread.new{ Fiber.root }
        expect(thread.value).to be thread.root_fiber
      end
    end

    context "when executed outside the thread" do
      it "does not return the root fiber of the thread" do
        thread = Thread.new{}
        expect(Fiber.root).not_to be thread.root_fiber
      end
    end
  end

  %i(root? root_fiber?).each do |method|
    describe "##{method}" do
      context "when executed inside the thread" do
        context "when send to the root fiber" do
          subject { Thread.new{ Fiber.current.__send__ method }.value }
          it { is_expected.to be true }
        end

        context "when send to another fiber" do
          subject { Thread.new{ Fiber.new{ Fiber.current.__send__ method }.resume }.value }
          it { is_expected.to be false }
        end
      end

      context "when executed outside the thread" do
        subject { fiber.__send__ method }

        let(:fiber) { thread.value }

        context "when send to the root fiber" do
          let(:thread) { Thread.new{ Fiber.current } }
          it { is_expected.to be false }
        end

        context "when send to another fiber" do
          let(:thread) { Thread.new{ Fiber.new{ Fiber.current }.resume } }
          it { is_expected.to be false }
        end
      end
    end
  end
end
