def create_member(h={})
  create_user_with_role(:member,h)
end

private

  def create_user_with_hash(h={})
    FactoryGirl.create(:user,h)
  end
  def create_user_with_role(s,h={})
    create_user_with_hash h.merge({:roles_mask=>Authorization.role(s)})
  end
