require 'spec_helper'

describe CurrentState do
  let(:user){ create(:user)}
  let(:day){ create(:day)}
  let(:state){ user.current_states.build }
  before{ state.day = day }
  let(:save_state){ lambda{ state.save! }}

  context "weight set" do
    before do
      state.weight = '82'
      save_state.call
    end

    subject{ CurrentState.last } 
    its(:weight){ should eq '82' }
    its(:note){ should be_nil }
  end

  context "note set" do
    before do
      state.note = 'Just a note'
      save_state.call
    end

    subject{ CurrentState.last } 
    its(:weight){ should be_nil }
    its(:note){ should eq 'Just a note' }
  end

  context "not weight nor note set" do
    it{ lambda{ save_state.call
    }.should raise_error(ActiveRecord::RecordInvalid, "Validation failed: Weight can't be blank if note is blank, Note can't be blank if weight is blank")}
  end
end
