class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, Post
    if user
      can [:index,:destroy], Comment
      can [:create,:update], Comment
      can :show, User
      can :update, User, id:user.id
      can :show, Day
      can [:show, :new,:create], Post
      can [:update,:destroy], Post
      can [:show,:index], TrainingType
      can :create, CurrentState
      can [:update,:destroy], CurrentState, user_id:user.id
      can :read, Noticement, user_id:user.id
    end
    # :read, :create, :update and :destroy.
  end
end
