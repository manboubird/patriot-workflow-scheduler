require 'init_test'

describe Patriot::Util::DBClient::Base do

  before :each do 
    @obj = Patriot::Util::DBClient::Base.new
    @obj.class.class_eval do 
      def quote(v)
        return "'#{v}'" if v.is_a?(String)
        return v
      end
    end
  end

  describe "select" do
    it "should execute select" do
      query ="SELECT * FROM tbl WHERE col = 'val'"
      expect(@obj).to receive(:execute_statement).with(query, :select)
      @obj.select("tbl", {:col => "val"})
    end

    it "should execute select with multiple condition" do
      query ="SELECT * FROM tbl WHERE col1 = 'val1' AND col2 = 1"
      expect(@obj).to receive(:execute_statement).with(query, :select)
      @obj.select("tbl", {:col1 => "val1", :col2 => 1})
    end

    it "should execute select with limit" do
      query ="SELECT * FROM tbl WHERE col1 = 'val1' AND col2 = 1 LIMIT 10"
      expect(@obj).to receive(:execute_statement).with(query, :select)
      @obj.select("tbl", {:col1 => "val1", :col2 => 1}, {:limit => 10})
    end

    it "should execute select with limit and offset" do
      query ="SELECT * FROM tbl WHERE col1 = 'val1' AND col2 = 1 LIMIT 5 OFFSET 10"
      expect(@obj).to receive(:execute_statement).with(query, :select)
      @obj.select("tbl", {:col1 => "val1", :col2 => 1}, {:limit =>5, :offset => 10})
    end

    it "should execute select with column selection" do
      query ="SELECT col3 FROM tbl WHERE col1 = 'val1' AND col2 = 1"
      expect(@obj).to receive(:execute_statement).with(query, :select)
      @obj.select("tbl", {:col1 => "val1", :col2 => 1}, {:items => [:col3]})

      query ="SELECT col3, col4 FROM tbl WHERE col1 = 'val1' AND col2 = 1"
      expect(@obj).to receive(:execute_statement).with(query, :select)
      @obj.select("tbl", {:col1 => "val1", :col2 => 1}, {:items => [:col3, :col4]})
    end

  end

  describe "insert" do
    it "should execute update" do
      query ="INSERT INTO tbl (col) VALUES ('val')"
      expect(@obj).to receive(:execute_statement).with(query, :insert)
      @obj.insert("tbl", {:col => "val"})
    end
  end

  describe "update" do
    it "should execute select" do
      query ="UPDATE tbl SET col1 = 'val2',col2 = 2 WHERE col1 = 'val1' AND col2 = 1"
      expect(@obj).to receive(:execute_statement).with(query, :update)
      @obj.update("tbl", {:col1 => "val2", :col2 => 2}, {:col1 => 'val1', :col2 =>1})
    end
  end

  describe "delete" do
    it "should execute delete" do
      query ="DELETE FROM tbl WHERE col1 = 'val1' AND col2 = 1"
      expect(@obj).to receive(:execute_statement).with(query, :update)
      @obj.delete("tbl", {:col1 => 'val1', :col2 =>1})
    end
  end
end
