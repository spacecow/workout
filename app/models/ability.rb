class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, Post
    if user
      can :show, User
      can :show, Day
      can [:new,:create], Post
      can [:update,:destroy], Post
      can [:show,:index], TrainingType
    end
    # :read, :create, :update and :destroy.
  end
end
