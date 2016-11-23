require 'spec_helper'

describe Thread do
  describe "#root_fiber" do
    context "when send to a created thread" do
      it "is the root fiber of the thread" do
        thread = Thread.new{ Fiber.current }
        expect(thread.root_fiber).to be thread.value
      end

      it "is not another fiber in the thread" do
        thread = Thread.new{ Fiber.new{ Fiber.current }.resume }
        expect(thread.root_fiber).not_to be thread.value
      end
    end

    context "when sent to Thread.main" do
      it "is the root fiber of the main thread" do
        expect(Thread.main.root_fiber).to be Fiber.current
      end

      it "is not another fiber in the thread" do
        expect(Thread.main.root_fiber).not_to be Fiber.new{ Fiber.current }.resume
      end
    end
  end
end

describe Fiber do
  describe ".root" do
    context "when executed inside a created thread" do
      it "returns the root fiber of the thread" do
        thread = Thread.new{ Fiber.root }
        expect(thread.value).to be thread.root_fiber
      end
    end

    context "when executed outside any thread (i.e. inside Thread.main)" do
      it "returns the root fiber of Thread.main" do
        expect(Fiber.root).to be Thread.main.root_fiber
      end
    end
  end

  %i(root? root_fiber?).each do |method|
    describe "##{method}" do
      context "when send to a fiber created inside of a created thread" do
        context "when send to the fiber inside this thread" do
          context "when send to its root fiber" do
            subject { Thread.new{ Fiber.current.__send__ method }.value }
            it { is_expected.to be true }
          end

          context "when send to another fiber" do
            subject { Thread.new{ Fiber.new{ Fiber.current.__send__ method }.resume }.value }
            it { is_expected.to be false }
          end
        end

        context "when send to the fiber after it has been passed to the outside of the thread" do
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

      context "when send to a fiber created inside Thread.main" do
        context "when send to the fiber inside Thread.main" do
          context "when send to its root fiber" do
            subject { Fiber.current.__send__ method }
            it { is_expected.to be true }
          end

          context "when send to another fiber" do
            subject { Fiber.new{ Fiber.current.__send__ method }.resume }
            it { is_expected.to be false }
          end
        end

        context "when send to the fiber after it has been passed to a created thread" do
          subject { thread.value }

          let!(:fiber) { Fiber.current }

          context "when send to the root fiber" do
            let(:thread) { Thread.new{ fiber.__send__ method } }
            it { is_expected.to be false }
          end

          context "when send to another fiber" do
            let(:thread) { Thread.new{ Fiber.new{ fiber.__send__ method }.resume } }
            it { is_expected.to be false }
          end
        end
      end
    end
  end
end