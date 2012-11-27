require 'spec_helper'

describe NoticementPresenter do
  let(:creator){ create :user, userid:'Batman' }
  let(:notification){ create :notification, content:'some notification', creator:creator}
  let(:noticement){ stub_model(Noticement, notification:notification)}
  let(:presenter){ NoticementPresenter.new(noticement,view)}

  describe ".content div.content a" do
    context "new" do
      before{ notification.type_mask = Notification.type(:new) }
      subject{ Capybara.string(presenter.content).find('div.content a')}
      specify{ subject[:href].should eq read_noticement_path(noticement)}
      its(:text){ should eq 'some notification' }
    end

    context "edit" do
      before{ notification.type_mask = Notification.type(:edit) }
      subject{ Capybara.string(presenter.content).find('div.content a')}
      specify{ subject[:href].should eq read_noticement_path(noticement)}
      its(:text){ should eq 'Edit: some notification' }
    end

    context "delete" do
      before{ notification.type_mask = Notification.type(:delete) }
      subject{ Capybara.string(presenter.content).find('div.content a')}
      specify{ subject[:href].should eq read_noticement_path(noticement)}
      its(:text){ should eq 'Delete: some notification' }
    end

    context "revive" do
      before{ notification.type_mask = Notification.type(:revive) }
      subject{ Capybara.string(presenter.content).find('div.content a')}
      specify{ subject[:href].should eq read_noticement_path(noticement)}
      its(:text){ should eq 'Revive: some notification' }
    end
  end

  describe ".timestamp div.timestamp" do
    subject{ Capybara.string(presenter.timestamp).find('div.timestamp')}
    its(:text){ should eq 'less than a minute ago' }
  end

  describe ".creator" do
    describe "div.creator" do
      subject{ Capybara.string(presenter.creator).find('div.creator')}
      its(:text){ should eq 'by Batman' }

      describe "a" do
        subject{ Capybara.string(presenter.creator).find('div.creator a')}
        its(:text){ should eq 'Batman' }
        specify{ subject[:href].should eq user_path(creator)}
      end
    end
  end
end
