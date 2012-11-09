class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, Post
    if user
      can [:index,:create,:destroy], Comment
      can :show, User
      can :update, User, id:user.id
      can :show, Day
      can [:new,:create], Post
      can [:update,:destroy], Post
      can [:show,:index], TrainingType
    end
    # :read, :create, :update and :destroy.
  end
end
