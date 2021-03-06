module Treat::Specs::Learning

  describe Treat::Learning::Export do

    describe "#initialize" do
      context "when supplied with acceptable parameters" do
        it "should give access to the parameters" do
          export = Treat::Learning::Export.new(:name, 0, "->(e) { e }")
          export.name.should eql :name
          export.default.should eql 0
          export.proc_string.should eql "->(e) { e }"
          export.proc.should be_instance_of Proc
          export.proc.call('x').should eql 'x'
        end
      end
      context "when supplied with wrong parameters" do
        it "should raise an exception" do
          # First argument should be a symbol representing the name of the export.
          expect { Treat::Learning::Export.new(nil) }.to raise_error
          # Third argument, if supplied, should be a string that
          # evaluates to a proc (NOT a proc/lambda).
          expect { Treat::Learning::Export.new(:name, 0, lambda { x } ) }.to raise_error
          # Third argument should be proper ruby syntax.
          expect { Treat::Learning::Export.new(:name, 0, "->(e) { ") }.to raise_error
          # Third argument should evaluate to a proc.
          expect { Treat::Learning::Export.new(:name, 0, "2") }.to raise_error
        end
      end
    end

    describe "#==(question)" do
      context "when supplied with an equal question" do
        it "should return true" do
          Treat::Learning::Export.new(:name).
          should == Treat::Learning::Export.new(:name)
          Treat::Learning::Export.new(:name, 0).
          should == Treat::Learning::Export.new(:name, 0)
          Treat::Learning::Export.new(:name, 0, "->(e) { }").
          should == Treat::Learning::Export.new(:name, 0, "->(e) { }")
        end
      end
      context "when supplied with a different question" do
        it "should return false" do
          Treat::Learning::Export.new(:name).
          should_not == Treat::Learning::Export.new(:name2)
          Treat::Learning::Export.new(:name, 0).
          should_not == Treat::Learning::Export.new(:name, 1)
          Treat::Learning::Export.new(:name, 0, "->(e) { }").
          should_not == Treat::Learning::Export.new(:name, 0, "->(e) { x }")
        end
      end
    end

  end

end
