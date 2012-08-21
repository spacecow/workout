class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, Post
    if user
      can :show, User
      can [:new,:create], Post
    end
    # :read, :create, :update and :destroy.
  end
end
